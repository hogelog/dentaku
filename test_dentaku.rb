#!/usr/bin/env ruby

require "minitest/autorun"
require_relative "dentaku"

class TestDentaku < Minitest::Test
  def setup
    @dentaku = Dentaku.new
  end

  def test_addition
    assert_equal 5, @dentaku.calc("2 + 3")
  end

  def test_subtraction
    assert_equal 7, @dentaku.calc("10 - 3")
  end

  def test_multiplication
    assert_equal 12, @dentaku.calc("3 * 4")
  end

  def test_division
    assert_equal 5, @dentaku.calc("10 / 2")
  end

  def test_integer_division
    assert_equal 2, @dentaku.calc("5 / 2")
  end

  def test_operator_precedence_multiplication_first
    assert_equal 14, @dentaku.calc("2 + 3 * 4")
  end

  def test_operator_precedence_division_first
    assert_equal 30, @dentaku.calc("100 / 4 + 5")
  end

  def test_operator_precedence_complex
    assert_equal 4, @dentaku.calc("10 - 2 * 3")
  end

  def test_parentheses_simple
    assert_equal 20, @dentaku.calc("(2 + 3) * 4")
  end

  def test_parentheses_division
    assert_equal 2, @dentaku.calc("10 / (2 + 3)")
  end

  def test_nested_parentheses
    assert_equal 13, @dentaku.calc("((1 + 2) * 3) + 4")
  end

  def test_float_numbers
    assert_equal 6.0, @dentaku.calc("1.5 * 2 + 3")
  end

  def test_float_division_result
    assert_equal 3.5, @dentaku.calc("7.0 / 2")
  end

  def test_normalize_comma
    assert_equal 1234, @dentaku.calc("1,234")
  end

  def test_normalize_dollar_sign
    assert_equal 1234.56, @dentaku.calc("$1,234.56")
  end

  def test_normalize_yen_sign
    assert_equal 1234, @dentaku.calc("¥1,234")
  end

  def test_normalize_in_expression
    assert_equal 1734, @dentaku.calc("$1,234 + 500")
  end

  def test_pipe_sequential_calculations
    assert_equal 8, @dentaku.calc("2 + 3 | 5 + 3")
  end

  def test_pipe_last_result
    result = @dentaku.calc("10 * 2 | 100 / 5")
    assert_equal 20, result
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
end
