class String
  def presses_for_char()
    case self
      when 'B', 'E', 'H', 'K', 'N', 'Q', 'U', 'X', '0' then 2
      when 'C', 'F', 'I', 'L', 'O', 'R', 'V', 'Y' then 3
      when '2', '3', '4', '5', '6', '8', 'S', 'Z' then 4
      when '7', '9' then 5
      else 1
    end
  end
end

def button_presses(message)
  message.upcase.each_char.map(&:presses_for_char).reduce(:+)
end
