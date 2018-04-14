#!/usr/bin/env ruby

require 'json'
require 'toml'

file = ARGV.shift
config = JSON.parse File.read(file)

section_name = File.basename(file, File.extname(file)).sub('.example', '')
doc = TOML::Generator.new(config).body

puts '#' * 50
puts "#!!!!!!!!!!! map-settings start here !!!!!!!!!!!!!"
puts '#' * 50
puts "[#{section_name}]"
puts doc
