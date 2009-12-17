require 'rubygems'
require 'tmpdir'

require 'ramaze'
require 'sequel'
require 'uv'

Ramaze::Inform.debug "Initializing UltraViolet..."

Uv.copy_files "xhtml", __DIR__/"public"
Uv.init_syntaxes

UV_PRIORITY_NAMES = %w[ ruby plain_text html css javascript yaml diff ]

STYLE = 'iplastic'

Ramaze::Inform.debug "done."
Ramaze.contrib :route

DB = Sequel('sqlite:///rapaste.sqlite')

require 'model/paste'
require 'controller/paste'

Ramaze.start :adapter => :mongrel, :port => 9952
