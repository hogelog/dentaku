#!/usr/bin/env ruby

require "minitest/autorun"
require_relative "dentaku"

class TestDentaku < Minitest::Test
  def setup
    @dentaku = Dentaku.new
  end

  def test_addition
    assert_equal "5", @dentaku.calc("2 + 3")
  end

  def test_subtraction
    assert_equal "7", @dentaku.calc("10 - 3")
  end

  def test_multiplication
    assert_equal "12", @dentaku.calc("3 * 4")
  end

  def test_division
    assert_equal "5", @dentaku.calc("10 / 2")
  end

  def test_integer_division
    assert_equal "2", @dentaku.calc("5 / 2")
  end

  def test_operator_precedence_multiplication_first
    assert_equal "14", @dentaku.calc("2 + 3 * 4")
  end

  def test_operator_precedence_division_first
    assert_equal "30", @dentaku.calc("100 / 4 + 5")
  end

  def test_operator_precedence_complex
    assert_equal "4", @dentaku.calc("10 - 2 * 3")
  end

  def test_parentheses_simple
    assert_equal "20", @dentaku.calc("(2 + 3) * 4")
  end

  def test_parentheses_division
    assert_equal "2", @dentaku.calc("10 / (2 + 3)")
  end

  def test_nested_parentheses
    assert_equal "13", @dentaku.calc("((1 + 2) * 3) + 4")
  end

  def test_float_numbers
    assert_equal "6", @dentaku.calc("1.5 * 2 + 3")
  end

  def test_float_division_result
    assert_equal "3.5", @dentaku.calc("7.0 / 2")
  end

  def test_normalize_comma
    assert_equal "1234", @dentaku.calc("1,234")
  end

  def test_normalize_dollar_sign
    assert_equal "1234.56", @dentaku.calc("$1,234.56")
  end

  def test_normalize_yen_sign
    assert_equal "1234", @dentaku.calc("¥1,234")
  end

  def test_normalize_in_expression
    assert_equal "1734", @dentaku.calc("$1,234 + 500")
  end

  def test_pipe_sequential_calculations
    assert_equal "8", @dentaku.calc("2 + 3 | 5 + 3")
  end

  def test_pipe_last_result
    result = @dentaku.calc("10 * 2 | 100 / 5")
    assert_equal "20", result
  end

  def test_unsupported_operator
    assert_raises(RuntimeError) do
      @dentaku.calc("2 ++ 3")
    end
  end

  def test_unsupported_method
    assert_raises(RuntimeError) do
      @dentaku.calc("system('ls')")
    end
  end

  def test_high_precision_multiplication
    result = @dentaku.calc("1.000000000000000000000000001 * 1000000000000000000000000000")
    assert_equal "1000000000000000000000000001", result
  end

  def test_floating_point_precision_addition
    result = @dentaku.calc("0.1 + 0.2")
    assert_equal "0.3", result
  end

  def test_underscore_one_with_pipe
    result = @dentaku.calc("100 | _1 / 2")
    assert_equal "50", result
  end

  def test_to_print_formats_integer_from_float
    result = @dentaku.calc("10.0 / 2.0")
    assert_equal "5", result
  end

  def test_to_print_rounds_to_two_decimals
    result = @dentaku.calc("10.0 / 3.0")
    assert_equal "3.33", result
  end

  def test_minus
    result = @dentaku.calc("-(1+1)")
    assert_equal "-2", result
  end

  def test_prev_result
    assert_equal "100", @dentaku.calc("10*10")
    result = @dentaku.calc("10*10")
    assert_equal "1000", @dentaku.calc("_*10")
  end
end
