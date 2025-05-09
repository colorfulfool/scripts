#!/usr/bin/env ruby
require "thor"
require "io/console"

class CLI < Thor
  desc "add_import TRIGGER IMPORT", "Adds import" 
  def add_import(trigger, import)
    files(trigger, import).each do |filename|
      imports, *rest = File.read(filename).split(/^$/)

      puts "#{filename} y/n?"
      if $stdin.getch != "y" then next end

      File.write filename, [imports, import, "\n", *rest].join("")
    end
  end

  desc "add_hook TRIGGER HOOK", "Adds import" 
  def add_hook(trigger, hook)
    files(trigger, hook).each do |filename|
      lines = File.read(filename).split("\n")

      dispatch_hook = lines.detect { |line| line.include? "const dispatch = " }
      translate_hook = lines.detect { |line| line.include? "const [translate] = " }
      function_component_start = lines.detect { |line| line.start_with? "export default function " }
      const_component_start = lines.detect { |line| line.start_with? "const " }
      index = lines.index(dispatch_hook || translate_hook || function_component_start || const_component_start)

      if not index then next end

      puts "#{filename} y/n?"
      if $stdin.getch != "y" then next end

      File.write filename, [
        *lines.slice(0..index), 
        "  " + hook, 
        *lines.slice(index+1..)
      ].join("\n")
    end
  end

  private

  def files(trigger, missing)
    `grep -rl '#{trigger}' src | xargs grep -L '#{missing}'`.split("\n")
  end
end

CLI.start(ARGV)
