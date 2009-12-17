require 'pp'
# require 'rake/clean'



task :default => [:hello]

desc "Prints half of hello world"
task :hello do
    puts "hello"
end



