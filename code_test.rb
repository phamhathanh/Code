require 'minitest/autorun'
require './code'

class CodeTest < Minitest::Test

  def test_construction
    assert_raises ArgumentError do
      Code.new([0])
    end

    Code.new(["a", "b_", "c ", "a"])
  end

  def test_alphabet
    code = Code.new(["a", "b", "c_"])
    assert_equal(4, code.alphabet.size)
  end

  def test_equality
    code1 = Code.new(["01", "011"])
    code2 = Code.new(["011", "01"])
    assert_equal(code1, code2)

    code1 = Code.new([""])
    code2 = Code.new([""])
    assert_equal(code1, code2)
  end

  def test_division
    code1 = Code.new(["0"])
    code2 = Code.new(["0", "10", "010"])
    code3 = Code.new(["", "10"])
    code4 = code1.divide code2
    assert_equal(code3, code4)

    emptyCode = Code.new([])
    code6 = emptyCode.divide code1
    assert_equal(emptyCode, code6)
  end

  def test_uniquely_decodability
    code1 = Code.new(["0", "01", "011"])
    assert(code1.uniquely_decodable?)

    code2 = Code.new(["1", "011", "01110", "1110", "10011"])
    refute(code2.uniquely_decodable?)
  end

  def test_deciphering_delay
    code1 = Code.new(["0", "10", "110"])
    assert_equal(0, code1.deciphering_delay)

    code2 = Code.new(["ab", "abb", "baab"])
    assert_equal(1, code2.deciphering_delay)

    code3 = Code.new(["00", "10", "1"])
    assert_equal(Float::INFINITY, code3.deciphering_delay)

    code4 = Code.new(["ca1", "c", "a1b1", "b1a2", "a2b2", "b2a3", "a3b3"])
    assert_equal(3, code4.deciphering_delay)
  end
end