#
# Description: 
# Changes five timestamps in jpg files.
#
# Author: Michele Mendel
# Oslo 2006.20.08
#
# Uses jhead.exe
# see http://www.sentex.net/~mwandel/jhead/usage.html
#
# Usage:
# This is a simple script which doesn't take any fancy parameters.
# You need to change data in the code to make it fit your needs.
# You can can run from the editor or from the shell. 
#

year_current = "2005"
year_new = "2006"

CHECK_ONLY = false
jpg_files = "**/*.jpg"


def get_timestamp(file, verbose=false)
    # Get EXIF data
    pre_exif_data = `jhead -v "#{file}"`
    puts pre_exif_data if verbose
    
    # Parse some EXIF data
    re_date_time_original = /DateTimeOriginal = "(\d\d\d\d):(\d\d):(\d\d) (.*)"/
    dto = re_date_time_original.match(pre_exif_data)
    return dto
end

def print_timestamp(dt)
    year, month, day, time = dt[1], dt[2], dt[3], dt[4] 
    printf("%4s:%2s:%2s-%8s ", year, month, day, time)
end

def set_timestamp(file, date_time)
    `jhead -ts#{date_time} "#{file}"`
end


puts "NO CHANGES WILL BE MADE" if(CHECK_ONLY)
puts "UPDATING FILES" if(!CHECK_ONLY)

@tot_nof_files = 0
@nof_changed_files = 0
@nof_unchanged_files = 0

Dir.glob(jpg_files, File::FNM_CASEFOLD).sort.each { |f|
    @tot_nof_files += 1
    print("#{@tot_nof_files}: #{f} / ")
    dt = get_timestamp(f)
    print_timestamp(dt)
    year, month, day, time = dt[1], dt[2], dt[3], dt[4] 

    if(year == year_current)
        dt_new = year_new + ":" + month + ":" + day + "-" +time
        set_timestamp(f, dt_new) if(!CHECK_ONLY)
        print(" / Changed to ")
        print_timestamp(get_timestamp(f)) if(!CHECK_ONLY)
        print(dt_new) if(CHECK_ONLY)
        @nof_changed_files += 1
    else
        print(" / Not Changed")
        @nof_unchanged_files += 1
    end
    
    puts
}

puts
puts "Total nof files #{@tot_nof_files}" 
puts "Total nof changed files #{@nof_changed_files}" 
puts "Total nof unchanged files #{@nof_unchanged_files}" 

