require 'minitest/autorun'
require 'set'

class CodeTest < Minitest::Test

  def test_construction
    assert_raises ArgumentError do
      Code.new([0])
    end

    Code.new(["a", "b_", "c ", "a"])
  end

  def test_alphabet
    code = Code.new(["a", "b", "c_"])
    assert_equal(code.alphabet.size, 4)
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
  end

  def test_uniquely_decodability
    code1 = Code.new(["0", "01", "011"])
    assert(code1.uniquely_decodable?)

    code2 = Code.new(["1", "011", "01110", "1110", "10011"])
    refute(code2.uniquely_decodable?)
  end
end


class Code

  attr_reader :alphabet
  attr_reader :codewords

  def initialize codewords
    @alphabet = Set.new
    @codewords = Set.new

    codewords.each do |codeword|
      unless codeword.is_a? String
        raise ArgumentError, 'Codewords must be strings.'
      end

      @codewords.add codeword
      codeword.each_char do |char| 
        @alphabet.add char 
      end
    end

    @codewords.freeze
    @alphabet.freeze
  end

  # Sardinas - Patterson algorithm
  def uniquely_decodable?
    sets = Array.new
    currentSet = quotient(@codewords, @codewords)
    currentSet.delete ""
    while true
      if sets.include? currentSet or currentSet.size == 0
        return true
      elsif currentSet.include? "" or currentSet.intersect? @codewords
        return false
      end
          
      sets.push currentSet
      currentSet = quotient(@codewords, currentSet) + quotient(currentSet, @codewords)
    end
  end

  def divide(other)
    return Code.new(quotient(self.codewords, other.codewords))
  end

  private
  # quotient(L1, L2) = L1\L2 = { y | xy in L2 and x in L1 }
  def quotient(l1, l2)
    output = Set.new
    l1.each do |x|
      l2.each do |z|
        if z.start_with? x
          new = z.dup
          new.slice! x
          output.add new
        end
      end
    end
    return output
  end
  public

  def ==(other)
    return false unless other.is_a? Code
    return false unless other.alphabet == @alphabet
    return false unless other.codewords == @codewords
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