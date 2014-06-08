require 'pry'


class String
  def operator?
    ["*", "^", "+", "$", "[", "]", "?", "|"].any? { |oper| oper == self }
  end

  def literal?
    (('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a).include?(self)
  end
end


class Xeger
  attr_reader :capture
  def initialize(pattern)
    @pattern = pattern
    @capture = ''
  end

  def patterns
    ['(', ')', '[', ']', '{', '}', '*', '?', '$', '^', '|', '+']
  end

  def match(str)
    i = 0
    loop do
      break if @pattern[i].nil?
      if @pattern[i].literal? && @pattern[i] == str[i]
        @capture += @pattern[i]
      else
        @capture = nil
        break
      end
      i += 1
    end
    return @capture
  end
end
reg = Xeger.new('asomething')
match = reg.match('something')