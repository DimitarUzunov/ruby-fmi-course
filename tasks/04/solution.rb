class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def to_s
    rank.to_s.capitalize + ' of ' + suit.to_s.capitalize
  end

  def ==(other)
    rank == other.rank and suit == other.suit
  end
end

class Deck
  include Enumerable

  def initialize(cards = generate_deck)
    @cards = cards
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    suits_order = {}
    suits.each_with_index { |suit, index| suits_order[suit] = index }

    ranks_order = {}
    ranks.each_with_index { |rank, index| ranks_order[rank] = -index }

    @cards.sort_by! { |card| [suits_order[card.suit], ranks_order[card.rank]] }
  end

  def to_s
    @cards.map(&:to_s).join("\n")
  end

  def deal(cards_count)
    cards_in_hand = @cards.shift(cards_count)
  end

  private

  def suits
    [:spades, :hearts, :diamonds, :clubs]
  end

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def generate_deck
    ranks.product(suits).map { |rank, suit| Card.new(rank, suit) }
  end
end

class WarDeck < Deck
  def deal
    WarHand.new(super(26))
  end
end

class WarHand < WarDeck
  def play_card
    draw_bottom_card
  end

  def allow_face_up?
    size <= 3
  end
end

class BeloteDeck < Deck
  def deal
    BeloteHand.new(super(8))
  end

  private

  def ranks
    [7, 8, 9, :jack, :queen, :king, 10, :ace]
  end
end

module CardMethods
  def same_suit?(cards)
    cards.all? { |card| card.suit == cards.first.suit }
  end

  def belote_pair?(pair)
    pair.first.rank == :king and pair.last.rank == :queen and same_suit?(pair)
  end

  def sequential?(cards)
    ranks_of_cards = cards.map(&:rank)
    ranks.reverse.each_cons(cards.size).any? { |ranks| ranks == ranks_of_cards }
  end

  def n_sequential_cards?(n)
    sort.each_cons(n).any? { |cards| sequential?(cards) and same_suit?(cards) }
  end

  def carre_of_rank?(rank)
    @cards.count { |card| card.rank == rank } == 4
  end

  def card_of_trump_suit?(card, trump_suit)
    card.suit == trump_suit
  end

  def twenty_pair?(pair, trump_suit)
    belote_pair?(pair) and not card_of_trump_suit?(pair.first, trump_suit)
  end

  def forty_pair?(pair, trump_suit)
    belote_pair?(pair) and card_of_trump_suit?(pair.first, trump_suit)
  end
end

class BeloteHand < BeloteDeck
  include CardMethods

  def highest_of_suit(suit)
    sort.detect { |card| card.suit == suit }
  end

  def belote?
    sort.each_cons(2).any? { |pair| belote_pair?(pair) }
  end

  def tierce?
    n_sequential_cards?(3)
  end

  def quarte?
    n_sequential_cards?(4)
  end

  def quint?
    n_sequential_cards?(5)
  end

  def carre_of_jacks?
    carre_of_rank?(:jack)
  end

  def carre_of_nines?
    carre_of_rank?(9)
  end

  def carre_of_aces?
    carre_of_rank?(:ace)
  end
end

class SixtySixDeck < Deck
  def deal
    SixtySixHand.new(super(6))
  end

  private

  def ranks
    [9, :jack, :queen, :king, 10, :ace]
  end
end

class SixtySixHand < SixtySixDeck
  include CardMethods

  def twenty?(trump_suit)
    sort.each_cons(2).any? { |pair| twenty_pair?(pair, trump_suit) }
  end

  def forty?(trump_suit)
    sort.each_cons(2).any? { |pair| forty_pair?(pair, trump_suit) }
  end
end
