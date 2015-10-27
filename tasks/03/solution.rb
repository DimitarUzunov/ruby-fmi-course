class Integer
  def prime?
    return false if self == 1
    2.upto(self ** 0.5).all? { |divisor| self % divisor != 0 }
  end
end

class RationalSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each(&block)
    enum_for(:all_ordered_pairs).
      lazy.
      select { |numerator, denominator| numerator.gcd(denominator) == 1 }.
      map { |numerator, denominator| Rational(numerator, denominator) }.
      take(@count).
      each(&block)
  end

  private

  def all_ordered_pairs
    numerator, denominator = [1, 1]

    loop do
      yield [numerator, denominator]

      numerator += 1

      while numerator > 1
        yield [numerator, denominator]
        numerator -= 1
        denominator += 1
      end

      yield [numerator, denominator]

      denominator += 1

      while denominator > 1
        yield [numerator, denominator]
        numerator += 1
        denominator -= 1
      end
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each(&block)
    enum_for(:all_primes).
      lazy.
      take(@count).
      each(&block)
  end

  private

  def all_primes
    current_number = 2
    loop do
      yield current_number if current_number.prime?
      current_number += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(count, first: 1, second: 1)
    @count = count
    @first = first
    @second = second
  end

  def each(&block)
    enum_for(:all_numbers).
      lazy.
      take(@count).
      each(&block)
  end

  def all_numbers
    previous, current = @first, @second

    yield previous
    yield current

    loop do
      yield previous + current
      previous, current = current, previous + current
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    sequence = RationalSequence.new(n)
    primeish, non_primeish = sequence.partition { |r| r.numerator.prime? or r.denominator.prime? }

    primeish.reduce(1, :*) / non_primeish.reduce(1, :*)
  end

  def aimless(n)
    sequence = PrimeSequence.new(n)
    sequence.each_slice(2).map { |first, second| Rational(first, second || 1) }.reduce(0, :+)
  end

  def worthless(n)
    return [] if n == 0

    limit = FibonacciSequence.new(n).to_a.last
    sum = 0

    RationalSequence.new(limit ** 2).take_while do |rational|
      sum += rational
      sum <= limit
    end
  end
end
