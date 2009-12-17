

puts RUBY_PLATFORM

if(RUBY_PLATFORM == 'java')
  require 'graphxml_jruby'
else
  require 'graphxml_mri'
end
