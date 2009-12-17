#
# $Date: 2001/12/01 05:24:58 $
# $Author: yoshi $
#

require "rbconfig"
Config::CONFIG.each do |k,v|  Config::MAKEFILE_CONFIG[k] = v.dup end
require "mkmf"

gl_libname = ""
glu_libname = ""
glut_libname = ""

modules = ""
ogl_flg = false
glut_flg = false

File.unlink("Makefile") if (FileTest.exist? "Makefile")
File.unlink("Makefile.ogl") if (FileTest.exist? "Makefile.ogl")
File.unlink("Makefile.glut") if (FileTest.exist? "Makefile.glut")

if (/cygwin/ =~ PLATFORM)
  $CFLAGS="-DWIN32"
  gl_libname = "opengl32"
  glu_libname = "glu32"
  glut_libname = "glut32"
elsif (/mswin32/ =~ PLATFORM)
  $CFLAGS="-DWIN32"
  gl_libname = "opengl32"
  glu_libname = "glu32"
  glut_libname = "glut32"
else
  $CFLAGS += " -I."

  dir_config("x11", "/usr/X11R6")

  $libs = append_library($libs, "Xmu")
  $libs = append_library($libs, "X11")
  gl_libname = "GL"
  glu_libname = "GLU"
  glut_libname = "glut"
end

$objs = ["glu.o", "ogl.o", "rbogl.o"]
#have_library("pthread", "pthread_create")
(have_library(gl_libname, nil) || have_library("Mesa"+gl_libname, nil)) &&
  (have_library(glu_libname, nil) ||  have_library("Mesa"+glu_libname, nil)) &&
  create_makefile("opengl")
if (FileTest.exist? "Makefile")
    open("Makefile") {|f|
        open("Makefile.ogl", "w") {|wfile|
           wfile.write(f.read)
        }
    }
    File.unlink("Makefile")
    modules = modules + "opengl.#{CONFIG['DLEXT']}" 
    ogl_flg = true
else
    p "can't create OpenGL module!"
    exit 1
end

$objs = ["glut.o"]
have_library("Xi", "XAllowDeviceEvents") &&
  have_library("Xext", "XMITMiscGetBugMode") &&
  have_library("Xmu", "XmuAddCloseDisplayHook")
have_library(glut_libname, nil) &&
  create_makefile("glut")
if (FileTest.exist? "Makefile")
    open("Makefile") {|f|
        open("Makefile.glut", "w") {|wfile|
           wfile.write(f.read)
        }
    }
    File.unlink("Makefile")
    modules = "glut.#{CONFIG['DLEXT']} " + modules
    glut_flg = true
end

open("Makefile", "w") {|f|
  f.write <<"MAKEFILE"
SHELL = /bin/sh
all: #{modules}

opengl.#{CONFIG['DLEXT']}: rbogl.c ogl.c glu.c rbogl.h
	@echo Now Making opengl extend module
	@$(MAKE) -f Makefile.ogl

glut.#{CONFIG['DLEXT']}: glut.c
	@echo Now Making glut extend module
	@$(MAKE) -f Makefile.glut

clean:
	@rm -f *.o *.so *.sl *.a
	@rm -f $(TARGET).lib $(TARGET).exp
	@rm -f core ruby$(EXEEXT) *~
	@rm -f Makefile.ogl Makefile.glut
	@rm -f Makefile extconf.h conftest.*

install: #{modules}
#{"\t@$(MAKE) -f Makefile.ogl install" if (ogl_flg)}
#{"\t@$(MAKE) -f Makefile.glut install" if (glut_flg)}

site-install: #{modules}
#{"\t@$(MAKE) -f Makefile.ogl site-install" if (ogl_flg)}
#{"\t@$(MAKE) -f Makefile.glut site-install" if (glut_flg)}
MAKEFILE
}

