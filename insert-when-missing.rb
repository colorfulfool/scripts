#!/usr/bin/env ruby
require "thor"
require "io/console"

class CLI < Thor
  desc "add_import TRIGGER IMPORT", "Adds import" 
  def add_import(trigger, import)
    files(trigger, import).each do |filename|
      puts "#{filename} y/n?"
      if $stdin.getch != "y" then next end

      insert_import filename, import
    end
  end

  desc "add_beginning TRIGGER BEGINNING", "Adds line at the beginning" 
  def add_beginning(trigger, beginning)
    files(trigger, beginning).each do |filename|
      puts "#{filename} y/n?"
      if $stdin.getch != "y" then next end

      insert_beginning filename, beginning
    end
  end

  desc "add_hook TRIGGER HOOK [IMPORT]", "Adds import" 
  def add_hook(trigger, hook, import)
    files(trigger, hook).each do |filename|
      puts "#{filename} y/n?"
      if $stdin.getch != "y" then next end

      insert_hook filename, hook

      unless not import or File.read(filename).include? import
        insert_import filename, import
      end
    end
  end

  private

  def files(trigger, missing)
    `grep -rl '#{trigger}' src | xargs grep -L '#{missing}'`.split("\n")
  end

  def insert_import(filename, import)
    imports, *rest = File.read(filename).split(/^$/)
    File.write filename, [imports, import, "\n", *rest].join("")
  end

  def insert_beginning(filename, beginning)
    content = File.read(filename)
    File.write filename, [beginning, content].join("\n")
  end

  def insert_hook(filename, hook)
    lines = File.read(filename).split("\n")

    dispatch_hook = lines.detect { |line| line.include? "const dispatch = " }
    translate_hook = lines.detect { |line| line.include? "const [translate] = " }
    function_component_start = lines.detect { |line| line.start_with? "export default function " }
    const_component_start = lines.detect { |line| line.start_with? "const " }
    index = lines.index(dispatch_hook || translate_hook || function_component_start || const_component_start)

    if not index then return end

    File.write filename, [
      *lines.slice(0..index), 
      "  " + hook, 
      *lines.slice(index+1..)
    ].join("\n")
  end
end

CLI.start(ARGV)
