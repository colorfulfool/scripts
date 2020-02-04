#!/usr/local/bin/ruby
require 'listen'

@command = ARGV.join(' ')

def run_command
  print "\033c"
  system(@command)
end


listener = Listen.to(Dir.pwd) do |modified, added, removed|
  run_command
end


run_command
listener.start
sleep