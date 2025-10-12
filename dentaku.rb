#!/usr/bin/env ruby

require "bigdecimal"
require "reline"
require "fileutils"
require "prism"

class Dentaku
  HISITORY_FILE = File.expand_path("~/.config/dentaku/history")

  def self.run
    new.run
  end

  def initialize
    FileUtils.mkdir_p(File.dirname(HISITORY_FILE))

    if File.exist?(HISITORY_FILE)
      File.readlines(HISITORY_FILE).each do |line|
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
      File.open(HISITORY_FILE, "w") do |f|
        Reline::HISTORY.to_a.each do |line|
          f.puts(line)
        end
      end
    end
  end

  def calc(line)
    chunks = line.split(/\s*\|\s*/)
    @result = 0
    chunks.each do |chunk|
      case chunk
      when "copy"
        copy(@result)
      else
        @result = evaluate(normalize_number(chunk))
      end
    end
    to_print(@result)
  end

  def evaluate(chunk)
    exp = Prism.parse(chunk)
    raise "Parse error" unless exp.success?

    statements = exp.value.statements.body
    raise "Empty expression" if statements.empty?

    eval_node(statements.first)
  end

  private

  def eval_node(node)
    case node
    when Prism::IntegerNode
      node.value
    when Prism::FloatNode
      BigDecimal(node.slice)
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
      when :_1
        @result
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
    IO.popen("pbcopy", "wb") { |io| io.write to_print(val); io.close_write }
  end

  def to_print(val)
    case val
    when BigDecimal
      if val.frac.zero?
        val.to_i.to_s
      else
        val.round(2).to_s("F")
      end
    else
      val.to_s
    end
  end
end

if __FILE__ == $0
  Dentaku.run
end
