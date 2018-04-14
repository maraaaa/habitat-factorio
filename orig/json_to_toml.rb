#!/usr/bin/env ruby

require 'json'
require 'toml-rb'

file = ARGV.shift
config = JSON.parse File.read(file)

section_name = File.basename(file, File.extname(file)).sub('.example', '')
doc = TomlRB.dump ({ section_name => config })

puts '#' * 50
puts "#!!!!!!!!!!! map-settings start here !!!!!!!!!!!!!"
puts '#' * 50
puts doc
