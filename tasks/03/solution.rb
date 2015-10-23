class Integer
  def prime?
    return false if self == 1

    root = Math.sqrt(self)
    divisor = 2

    while divisor <= root
      return false if self % divisor == 0
      divisor += 1
    end

    true
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    current = Rational(1)
    direction = DIRECTIONS[:down]
    counter = 0

    while counter < @limit
      yield current

      current = calculate_next(current, direction)
      direction = change_direction(current, direction)
      counter += 1
    end
  end

  private

  DIRECTIONS = {down: [1, 0], right: [0, 1], down_left: [1, -1], up_right: [-1, 1]}

  def reducible?(numerator, denominator)
    numerator.gcd(denominator) != 1
  end

  def calculate_next_irreducible(numerator, denominator, direction)
    if reducible?(numerator, denominator)
      calculate_next_irreducible(numerator + direction[0], denominator + direction[1], direction)
    else
      Rational(numerator, denominator)
    end
  end

  def calculate_next(current, direction)
    numerator = current.numerator + direction[0]
    denominator = current.denominator + direction[1]

    calculate_next_irreducible(numerator, denominator, direction)
  end

  def change_direction(current, direction)
    case
      when direction == DIRECTIONS[:down] then DIRECTIONS[:up_right]
      when direction == DIRECTIONS[:right] then DIRECTIONS[:down_left]
      when (direction == DIRECTIONS[:down_left] and current.denominator == 1) then DIRECTIONS[:down]
      when (direction == DIRECTIONS[:up_right] and current.numerator == 1) then DIRECTIONS[:right]
      else direction
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    current = 2
    counter = 0

    while counter < @limit
      if current.prime?
        yield current
        counter += 1
      end

      current += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    current_number, next_number = @first, @second
    counter = 0

    while counter < @limit
      yield current_number

      current_number, next_number = next_number, current_number + next_number
      counter += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    groups = RationalSequence.new(n).partition do |rational|
      rational.numerator.prime? or rational.denominator.prime?
    end

    groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
  end

  def aimless(n)
    pairs = PrimeSequence.new(n).each_slice(2).to_a
    pairs.last << 1 if n.odd?

    rationals = pairs.map { |pair| Rational(pair[0], pair[1]) }
    rationals.reduce(0, :+)
  end

  def worthless(n)
    return [] if n == 0

    fibonacci_number = FibonacciSequence.new(n).to_a.last

    cut_size = 1
    rationals_cut = RationalSequence.new(cut_size)
    while rationals_cut.reduce(:+) <= fibonacci_number
      cut_size += 1
      rationals_cut = RationalSequence.new(cut_size)
    end

    RationalSequence.new(cut_size - 1).to_a
  end
end
