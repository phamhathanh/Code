require 'set'

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
      if sets.include? currentSet or currentSet.empty?
        return true
      elsif currentSet.include? "" or currentSet.intersect? @codewords
        return false
      end
          
      sets.push currentSet
      currentSet = quotient(@codewords, currentSet) + quotient(currentSet, @codewords)
    end
  end

  def divide(other)
    newCodewords = quotient(self.codewords, other.codewords)
    return Code.new(newCodewords)
  end

  private
  # quotient(L1, L2) = L1\L2 = { y | xy in L2 and x in L1 }
  def quotient(l1, l2)
    output = Set.new
    l1.each do |x|
      l2.each do |z|
        if z.start_with? x
          newZ = z.dup
          newZ.slice! x
          output.add newZ
        end
      end
    end
    return output
  end
  public

  def deciphering_delay
    u = Array.new
    v = Array.new

    currentU = quotient(@codewords, @codewords)
    currentU.delete ""
    currentU = currentU + quotient(@codewords, currentU)
    
    v.push @codewords
    currentV = quotient(currentU, @codewords) + quotient(@codewords, @codewords)
    currentV.delete ""

    d = 0
    while true
      if currentV.empty?
        return d
      end
      
      d += 1

      u.push currentU
      v.push currentV

      currentU = quotient(currentV, @codewords)
      currentU = currentU + quotient(@codewords, currentU)
      currentV = quotient(currentU, @codewords) + quotient(@codewords, currentV)

      if u.include? currentU or v.include? currentV
        return Float::INFINITY
      end
    end
  end

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