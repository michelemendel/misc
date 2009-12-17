/**
 * Wrap unpacker stub.
 * NOTE: Currently windows-specific.
 * NOTE: Does not support compressed files. Instead we encourage you to
 *       compress the wrap exe (unpacker+wrap) file using upx!
 *
 * Copyright 2001 (c) Robert Feldt. All rights reserved.
 *
 * This is free software and you may use it as you please but you MUST:
 *   Email to feldt@ce.chalmers.se with a short description on
 *   how you've used it. (This is to motivate me to continue develop it)
 *
 * Use at your own risk. NO WARRANTY.
 */
#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include <process.h>
#include <windows.h>

// NOTE: Length of WRAPID must be multiple of 4
#define WRAPID "Feldt rbwrap 0.1.0\000\000"

# define ERRMSG(x) printf(x)

/**
 * Format of a wrap:
 *   Binary data for file 1
 *   Binary data for file 2
 *   ...
 *   Binary data for file n
 *   FileInfo for file 1
 *   ...
 *   FileInfo for file n
 *   WrapInfo
 *   Cookie
 */
struct FileInfo {
  int structlen;     // len of this one - including full len of name
  int pos;	     // file pos relative to start of wrap
  int len;	     // length of the data
  int unpack_dir;    // 0 => tempdir, 1 => current dir 
  char name[1];	     // file name
};

struct WrapInfo {
  char substitution_matchstr[16]; // String to match for command line substs.
  char command_line[1]; // Command line to run after unpacking files
};

struct Cookie {
  int count;         // Number of files wrapped
  int len;	     // length of entire wrap (excl unpacker and cookie)
  int fileinfo_pos;  // pos (relative to start of wrap) of first FileInfo
  int fileinfo_len;  // total length of FileInfo's
  int wrapinfo_pos;  // pos (relative to start of wrap) of WrapInfo
  int wrapinfo_len;  // length of WrapInfo
  char wrapid[20];   // Wrapid cookie so that we know this is a valid archive
};

// Forward decls
void write_file(char* name, char* path, char* data, int len);
void exitfunc();
void parse_args(int argc, char* argv[], char *exe_argv);
void vps(char *basestr, char *str);
void vpi(char *basestr, int i);
void gsub(char* dest, char* src, char* matchstr, char *replacestr);

// Globals
char *toc_buffer = NULL;
char homepath[MAX_PATH+1];
struct Cookie *c;
char *wd_inmem;
extern int wd_len;
extern char* wrapdata_buffer();

// Parameters
int verbose;
int info;
int run;

/**
 * Arguments can be given in the format
 *  --unwrap,ARG[= VAL]
 *
 * Arguments not in this format will be sent to the wrapped program.
 * 
 * Following arguments are valid:
 *
 *  --unwrap,help
 *     Print help for the unwrapper
 *
 *  --unwrap,toc OR --rbwrap,info
 *     Print a table-of-contents and info for the wrap. Lists all files and
 *     the command line to run when the files have been unpacked.
 *
 *  --unwrap,verbose
 *     Be verbose.
 */
int main(int argc, char* argv[])
{
  char thisfile[MAX_PATH+1]; // Name (with path) of this (the wrapped exe) file
  char temppath[MAX_PATH+1];
  char tempdir[MAX_PATH+1];
  char program_name[MAX_PATH+1];
  char cmdline[MAX_PATH+1];
  char subst_cmdline[MAX_PATH+1];
  char *p;
  char *wi_buffer;
  int wrap_start;
  int pid;
  int stat;
  char exe_argv[MAX_PATH+1];
  struct FileInfo *toc;
  struct WrapInfo *wrap_info;
  int i;

  // Parse args and set global vars indicating actions to take. Strips args
  // intended for us from args intended for the wrapped program.
  parse_args(argc, argv, exe_argv);

  if(info || verbose)
    printf("Unwrapper stub for rbwrap version 0.1.0\n");

  if(strlen(exe_argv) > 0)
    vps("  Args passed on to command:%s\n", exe_argv);

  // Get name of this file, ie. the wrap.
  if (!GetModuleFileNameA(NULL, thisfile, MAX_PATH)) {
    ERRMSG("System error - unable to load!");
    return -1;
  }
  p = thisfile+strlen(thisfile) - 4;
  if (strnicmp(p, ".exe", 4) != 0) // Make sure we have exe file extension
    strcat(thisfile, ".exe");
  
  // Strip final delimiter from absolute path
  strcpy(homepath, thisfile);
  for (p=homepath+strlen(homepath); *p != '\\' && p >= homepath; --p);
  *++p = '\0';

  // Get a unique temp directory were we can unpack.
  GetTempPath(MAX_PATH, temppath);
  strcpy(tempdir, temppath);
  strcat(tempdir, "rbw");
  sprintf(tempdir+strlen(tempdir), "%d\\", rand()); // TODO: Search for a unique one!
  vps("  Tempdir: %s\n", tempdir);

  // Create tempdir. We assume it's unique.
  if (run) 
    CreateDirectory(tempdir, 0);

  wd_inmem = wrapdata_buffer();
  
  // Get Cookie and check identifier
  c = (struct Cookie *)(wd_inmem + wd_len - sizeof(struct Cookie));

  vps("  Reading Cookie:\n", "");
  vps("    Id:      %s\n", c->wrapid);
  vpi("    # files: %d\n", c->count);
  if (strncmp(c->wrapid, WRAPID, 20)) {
    ERRMSG("Archive has bad identifier - quiting!");
    return -1;
  }

  // Get TOC
  toc_buffer = (char*)(wd_inmem + c->fileinfo_pos);
  toc = (struct FileInfo *)toc_buffer;

  // Unpack all files into tempdir
  if(info)
    printf("  Files wrapped (total size = %d):\n", wd_len);
  else
    vps("  Unpacking files\n", "");
  for(i = 0; i < c->count; i++) {
    if(info || verbose)
      printf("    %s (size = %d)\n", toc->name, toc->len); 

    if(run) {
      // Write file to disc
      if(toc->unpack_dir == 0)
	write_file(toc->name, tempdir, (char*)(wd_inmem + toc->pos), toc->len);
      else if(toc->unpack_dir == 1)
	write_file(toc->name, "", (char*)(wd_inmem + toc->pos), toc->len);
      else {
	ERRMSG("Unknown unpack directory specifier");
	return -1;
      }
    }

    toc = (struct FileInfo *)((char*)toc + toc->structlen);
    if (toc == NULL) {
      ERRMSG("Error while reading TOC\n");
      return -1;
    }
  }

  // Get WrapInfo
  wrap_info = (struct WrapInfo *)(wd_inmem + c->wrapinfo_pos);
  
  // Substitute substitution_matchstr for tempdir
  gsub(subst_cmdline, wrap_info->command_line,
       wrap_info->substitution_matchstr, tempdir);
  
  // Execute command line
  p = strchr(subst_cmdline, ' ');
  program_name[0] = '\0';
  if(NULL == p) {
    strcat(program_name, subst_cmdline);
    strcat(program_name, exe_argv);
    vps("  Commandline: %s\n", program_name);
    cmdline[0] = '\0';
  } else {
    while(*p == ' ') p++;
    strncat(program_name, subst_cmdline, 
	    p-1-subst_cmdline);
    strcpy(cmdline, program_name);
    strcat(cmdline, p-1);
    strcat(cmdline, exe_argv);
    vps("  Commandline with args: %s\n", cmdline);
  }
  if(run) {
    vps("\n",""); // Extra before output from command
    pid = _spawnlp(_P_NOWAIT, program_name, cmdline, 0);
    _cwait(&stat, pid, WAIT_CHILD);
    vps("\n",""); // Extra after output from command
  }

  // Return
  return 0;
}

void
create_directories(char* name, int num_bytes_in_name, char* path)
{
  char *p = name;
  char *last = name;
  char buff[MAX_PATH+1];

  strcpy(buff, path);
  while(p-name < num_bytes_in_name) {
    p = strstr(p, "\\");
    strncat(buff, last, p-last);
    last = p;
    CreateDirectory(buff, NULL);
    p++; // Skip delimiter
  }
}

void write_file(char* name, char* path, char* data, int len)
{
  char fnm[MAX_PATH+1];
  char *p;
  char *last;
  FILE *out;
  int i;
  int dirs_in_name = 0; // 1 iff there are dirs in name

  // PC-SPECIFIC: Using '\' as dir separator
  for(i = 0, p = name; i<strlen(name); i++) {
    if((*p == '/') || (*p == '\\')) {
      *p = '\\';
      dirs_in_name = 1;
      last = p;
    }
    p++;
  }
    
  // Make sure directories are there
  if(dirs_in_name)
    create_directories(name, last-name, path);

  // Now write file
  strcpy(fnm, path);
  strcat(fnm, name);
  out = fopen(fnm, "wb");
  fwrite(data, len, 1, out);
  fclose(out);
}

void
parse_args(int argc, char* argv[], char *exe_argv)
{
  char *next_free = exe_argv;
  char *p;
  char matchstr[] = "--unwrap,";
  int match_len = strlen(matchstr);
  int i = 0;

  exe_argv[0] = '\0';

  // Set up default values for parameters
  verbose = 0;    // no verbosity
  info = 0;       // no info about wrapped program
  run = 1;        // run command as default

  for(i = 0; i < argc; i++) {
    if(strstr(argv[i], matchstr) == argv[i]) {
      p = argv[i] + match_len;
      if(strstr(p, "toc") == p) {
	info = 1; 
	run = 0;
      } else if(strstr(p, "info") == p) {
	info = 1; 
	run = 0;
      } else if(strstr(p, "verbose") == p) {
	verbose = 1;
      } else if(strstr(p, "help") == p) {
	printf("Unwrapper stub for rbwrap version 0.1.0\n\n");
	printf("Commands:\n");
	printf("  --unwrap,toc or --unwrap,info\n");
	printf("     List wrapped files and their sizes\n");
	printf("  --unwrap,verbose\n");
	printf("     Be verbose\n");
      }
    } else {
      // Copy to exe_argv if not first arg since it is the name of the
      // wrapped exe.
      if(i != 0) {
	// Add space before each param to seperate them.
	strcat(next_free, " ");
	next_free++;
	strcat(next_free, argv[i]);
	next_free += strlen(argv[i]);
      }
    }
  }  
}

void vps(char *basestr, char *str)
{
  if(verbose) printf(basestr, str);
}

void vpi(char *basestr, int i)
{
  if(verbose) printf(basestr, i);
}

void gsub(char* dest, char* src, char* matchstr, char *replacestr)
{
  char* next_occurence = strstr(src, matchstr);
  char* post_last_occurence = src;
  char* d = dest;
  int len;
  int match_len = strlen(matchstr);
  int replace_len = strlen(replacestr);

  *d = '\0';

  while(next_occurence != NULL) {
    len = next_occurence-post_last_occurence;
    strncat(d, post_last_occurence, len);
    d += len;
    strncat(d, replacestr, replace_len);
    d += replace_len;
    post_last_occurence = next_occurence + match_len;
    next_occurence = strstr(post_last_occurence, matchstr);
  }
  // Copy rest
  strcat(d, post_last_occurence);
}
