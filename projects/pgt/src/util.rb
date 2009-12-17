#
# Miscellaneous utilities.
#
# Author:: Michele Mendel
# Date:: Oslo 2009-04-27
#
# see:: http://builder.rubyforge.org/
#

require 'yaml'
require 'digest/md5'

include Digest

REPORT_DIR = 'reports'

def report_dir(filename)
  Dir.mkdir(REPORT_DIR) if !File.exists?(REPORT_DIR)
  File.join(REPORT_DIR, filename)
end

def get_file(filename)
  File.open(report_dir(filename), 'w')
end

def save_file(data, filename)
  File.open(report_dir(filename), 'w') { |f| f.puts(data) }
end

def save_yaml_file(data, filename)
  File.open(report_dir(filename), "w") {|f| YAML.dump(data, f)}
end

def load_yaml_file(filename)
  YAML::load(File.open(report_dir(filename)))
end

#
def uid(teams, division)
  MD5.hexdigest(teams[0] + teams[1] + division.to_s)
end
