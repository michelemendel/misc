require "java"

module J
	include_package "java.io"
end

filename = "java2.rb"
fr = J::FileReader.new(filename)
br = J::BufferedReader.new fr

s = br.readLine

print "------ ", filename, "------\n"

while s
  puts s.to_s
  s = br.readLine
end

print "------ ", filename, " end ------\n";

br.close


