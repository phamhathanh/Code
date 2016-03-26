require 'minitest/autorun'
require 'set'

class CodeTest < Minitest::Test

  def test_construction
    assert_raises ArgumentError do
      Code.new(0)
    end

    Code.new("a", "b_", "c ")
  end

  def test_alphabet
    code = Code.new("a", "b", "c_")
    assert_equal(code.alphabet.size, 4)
  end

  def test_uniquely_decodability
    code1 = Code.new("0", "01", "011")
    assert(code1.uniquely_decodable?)

    code2 = Code.new("1", "011", "01110", "1110", "10011")
    refute(code2.uniquely_decodable?)
  end
end


class Code

  attr_reader :alphabet

  def initialize *codewords
    @alphabet = Set.new

    codewords.each do |codeword|
      unless codeword.is_a? String
        raise ArgumentError, 'Codewords must be strings.'
      end

      codeword.each_char do |char|
        @alphabet.add char unless @alphabet.include? char
      end
    end

    @codewords = codewords

    @codewords.freeze
    @alphabet.freeze
  end

  def uniquely_decodable?
    return true
  end

  def to_s
    if @codewords.length == 0
      return ""
    end

    output = @codewords[0]
    @codewords.drop(1).each do |codeword|
      output += ", " + codeword
    end

    return output
  end
end