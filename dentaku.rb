#!/usr/bin/env ruby

require "reline"
require "fileutils"
require "prism"

class Dentaku
  HSITORY_FILE = File.expand_path("~/.config/dentaku/history")

  def self.run
    new.run
  end

  def initialize
    FileUtils.mkdir_p(File.dirname(HSITORY_FILE))
  
    if File.exist?(HSITORY_FILE)
      File.readlines(HSITORY_FILE).each do |line|
        Reline::HISTORY << line.chomp
      end
    end
  end
 
  def run
    begin
      loop do
        line = Reline.readline("dentaku> ", true)
        break if line.nil?
  
        begin
          result = calc(line)
          puts "=> #{result}"
        rescue Exception => e
          puts "Error: #{e.message}"
        end
      end
    ensure
      File.open(HSITORY_FILE, "w") do |f|
        Reline::HISTORY.to_a.each do |line|
          f.puts(line)
        end
      end
    end
  end

  def calc(line)
    chunks = line.split(/\s*\|\s*/)
    result = 0
    chunks.each do |chunk|
      case chunk
      when "copy"
        copy(result)
      else
        result = evaluate(normalize_number(chunk))
      end
    end
    result
  end

  def evaluate(expr)
    result = Prism.parse(expr)
    raise "Parse error" unless result.success?

    statements = result.value.statements.body
    raise "Empty expression" if statements.empty?

    eval_node(statements.first)
  end

  private

  def eval_node(node)
    case node
    when Prism::IntegerNode
      node.value
    when Prism::FloatNode
      node.value
    when Prism::ParenthesesNode
      eval_node(node.body.body.first)
    when Prism::CallNode
      case node.name
      when :+
        eval_node(node.receiver) + eval_node(node.arguments.arguments.first)
      when :-
        eval_node(node.receiver) - eval_node(node.arguments.arguments.first)
      when :*
        eval_node(node.receiver) * eval_node(node.arguments.arguments.first)
      when :/
        eval_node(node.receiver) / eval_node(node.arguments.arguments.first)
      else
        raise "Unsupported operator: #{node.name}"
      end
    else
      raise "Unsupported node type: #{node.class}"
    end
  end

  def normalize_number(line)
    line.gsub(/[$¥]?([\d,]+)(\.\d+)?/, '\1\2').gsub(",", "")
  end

  def copy(val)
    IO.popen("pbcopy", "wb") { |io| io.write val; io.close_write }
  end
end

if __FILE__ == $0
  Dentaku.run
end
