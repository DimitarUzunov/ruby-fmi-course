describe Card do
  it 'can be converted to a string' do
    expect(Card.new(10, :spades).to_s).to eq '10 of Spades'
    expect(Card.new(:jack, :diamonds).to_s).to eq 'Jack of Diamonds'
  end

  it 'can be compared to another card' do
    expect(Card.new(:queen, :spades) == Card.new(:queen, :spades)).to eq true
    expect(Card.new(2, :hearts) == Card.new(2, :hearts)).to eq true
    expect(Card.new(:ace, :spades) == Card.new(10, :clubs)).to eq false
    expect(Card.new(6, :diamonds) == Card.new(:king, :clubs)).to eq false
    expect(Card.new(9, :clubs) == Card.new(5, :clubs)).to eq false
    expect(Card.new(3, :clubs) == Card.new(3, :diamonds)).to eq false
  end
end

describe Deck do
  it 'implements Enumerable' do
    expect(Deck).to include (Enumerable)
  end

  it 'is the standart 52-card deck if no initialize parameters are given' do
    expect(Deck.new.size).to eq 52
  end

  it 'can be converted to a string' do
    ace_of_spades = Card.new(:ace, :spades)
    jack_of_diamonds = Card.new(:jack, :diamonds)
    ten_of_clubs = Card.new(10, :clubs)

    deck = Deck.new([ace_of_spades, jack_of_diamonds, ten_of_clubs])

    expect(deck.to_s).to eq "Ace of Spades\nJack of Diamonds\n10 of Clubs"
  end

  describe '#size' do
    it 'returns the size of the deck' do
      jack_of_diamonds = Card.new(:jack, :diamonds)
      ten_of_clubs = Card.new(10, :clubs)

      expect(Deck.new([jack_of_diamonds, ten_of_clubs]).size).to eq 2
    end
  end

  describe '#draw_top_card' do
    let(:jack_of_diamonds) { Card.new(:jack, :diamonds) }
    let(:ten_of_clubs) { Card.new(10, :clubs) }
    let(:cards) { [jack_of_diamonds, ten_of_clubs] }
    let(:deck) { Deck.new(cards) }
    let!(:top_card) { deck.draw_top_card }

    it 'removes top card from deck' do
      expect(cards).to eq [ten_of_clubs]
    end

    it 'returns top card from deck' do
      expect(top_card).to eq jack_of_diamonds
    end
  end

  describe '#draw_bottom_card' do
    let(:jack_of_diamonds) { Card.new(:jack, :diamonds) }
    let(:ten_of_clubs) { Card.new(10, :clubs) }
    let(:cards) { [jack_of_diamonds, ten_of_clubs] }
    let(:deck) { Deck.new(cards) }
    let!(:bottom_card) { deck.draw_bottom_card }

    it 'removes bottom card from deck' do
      expect(cards).to eq [jack_of_diamonds]
    end

    it 'returns bottom card from deck' do
      expect(bottom_card).to eq ten_of_clubs
    end
  end

  describe '#top_card' do
    let(:jack_of_diamonds) { Card.new(:jack, :diamonds) }
    let(:ten_of_clubs) { Card.new(10, :clubs) }
    let(:cards) { [jack_of_diamonds, ten_of_clubs] }
    let(:deck) { Deck.new(cards) }

    it 'does not remove top card from deck' do
      expect(cards).to eq [jack_of_diamonds, ten_of_clubs]
    end

    it 'returns top card from deck' do
      expect(deck.top_card).to eq jack_of_diamonds
    end
  end

  describe '#bottom_card' do
    let(:jack_of_diamonds) { Card.new(:jack, :diamonds) }
    let(:ten_of_clubs) { Card.new(10, :clubs) }
    let(:cards) { [jack_of_diamonds, ten_of_clubs] }
    let(:deck) { Deck.new(cards) }

    it 'does not remove bottom card from deck' do
      expect(cards).to eq [jack_of_diamonds, ten_of_clubs]
    end

    it 'returns bottom card from deck' do
      expect(deck.bottom_card).to eq ten_of_clubs
    end
  end

  describe '#sort' do
    it 'sorts two cards of the same suit' do
      two_of_clubs  = Card.new(2, :clubs)
      jack_of_clubs = Card.new(:jack, :clubs)

      deck = Deck.new([two_of_clubs, jack_of_clubs])

      expect(deck.sort.to_a).to eq [jack_of_clubs, two_of_clubs]
    end

    it 'sorts cards of different suits' do
      two_of_clubs  = Card.new(2, :clubs)
      jack_of_clubs = Card.new(:jack, :clubs)
      three_of_hearts = Card.new(3, :hearts)
      ace_of_spades = Card.new(:ace, :spades)

      deck = Deck.new([two_of_clubs, jack_of_clubs,
                          three_of_hearts, ace_of_spades])

      expect(deck.sort.to_a).to eq [ace_of_spades, three_of_hearts,
                                    jack_of_clubs, two_of_clubs]
    end
  end
end

describe WarDeck do
  it 'implements Enumerable' do
    expect(WarDeck).to include(Enumerable)
  end

  it 'fills the deck if no initialize parameters are given' do
    deck = WarDeck.new

    expect(deck.size).to eq 52
  end

  it 'implements all required methods' do
    deck = WarDeck.new

    expect(deck).to respond_to(:size)
    expect(deck).to respond_to(:draw_top_card)
    expect(deck).to respond_to(:draw_bottom_card)
    expect(deck).to respond_to(:top_card)
    expect(deck).to respond_to(:bottom_card)
    expect(deck).to respond_to(:shuffle)
    expect(deck).to respond_to(:sort)
    expect(deck).to respond_to(:to_s)
    expect(deck).to respond_to(:deal)
  end

  describe '#sort' do
    it 'sorts two cards of the same suit' do
      two_of_clubs  = Card.new(2, :clubs)
      jack_of_clubs = Card.new(:jack, :clubs)

      deck = WarDeck.new([two_of_clubs, jack_of_clubs])

      expect(deck.sort.to_a).to eq [jack_of_clubs, two_of_clubs]
    end
  end

  describe 'hand' do
    subject(:hand) { WarDeck.new.deal }

    it 'implements all required methods' do
      expect(hand).to respond_to(:size)
      expect(hand).to respond_to(:play_card)
      expect(hand).to respond_to(:allow_face_up?)
    end

    describe '#deal' do
      it 'deals 26 cards' do
        expect(hand.size).to eq 26
      end
    end

    describe '#allow_face_up?' do
      it 'returns false if the cards are more than 3' do
        expect(hand.allow_face_up?).to eq false
      end

      it 'returns true if the cards are 3' do
        23.times { hand.play_card }

        expect(hand.allow_face_up?).to eq true
      end

      it 'returns true if the cards are less than 3' do
        25.times { hand.play_card }

        expect(hand.allow_face_up?).to eq true
      end
    end
  end
end

describe BeloteDeck do
  it 'implements Enumerable' do
    expect(BeloteDeck).to include(Enumerable)
  end

  it 'fills the deck if no initialize parameters are given' do
    deck = BeloteDeck.new

    expect(deck.size).to eq 32
  end

  it 'implements all required methods' do
    deck = BeloteDeck.new

    expect(deck).to respond_to(:size)
    expect(deck).to respond_to(:draw_top_card)
    expect(deck).to respond_to(:draw_bottom_card)
    expect(deck).to respond_to(:top_card)
    expect(deck).to respond_to(:bottom_card)
    expect(deck).to respond_to(:shuffle)
    expect(deck).to respond_to(:sort)
    expect(deck).to respond_to(:to_s)
    expect(deck).to respond_to(:deal)
  end

  describe 'hand' do
    subject(:hand) { BeloteDeck.new.deal }

    it 'implements all required methods' do
      expect(hand).to respond_to(:size)
      expect(hand).to respond_to(:highest_of_suit)
      expect(hand).to respond_to(:belote?)
      expect(hand).to respond_to(:tierce?)
      expect(hand).to respond_to(:quarte?)
      expect(hand).to respond_to(:quint?)
      expect(hand).to respond_to(:carre_of_jacks?)
      expect(hand).to respond_to(:carre_of_nines?)
      expect(hand).to respond_to(:carre_of_aces?)
    end

    describe '#deal' do
      it 'deals 8 cards' do
        expect(hand.size).to eq 8
      end
    end

    describe '#highest_of_suit' do
      let(:ten_of_clubs) { Card.new(10, :clubs) }
      let(:jack_of_clubs) { Card.new(:jack, :clubs) }
      let(:seven_of_hearts) { Card.new(7, :hearts) }
      let(:ace_of_spades) { Card.new(:ace, :spades) }
      let(:belote_hand) { BeloteHand.new([jack_of_clubs, ten_of_clubs,
                                          seven_of_hearts, ace_of_spades]) }

      it 'returns the card in hand with highest rank of clubs suit' do
        expect(belote_hand.highest_of_suit(:clubs)).to eq ten_of_clubs
      end

      it 'returns the card in hand with highest rank of spades suit' do
        expect(belote_hand.highest_of_suit(:spades)).to eq ace_of_spades
      end
    end

    describe '#belote?' do
      it 'returns true if hand includes King and Queen of same suit' do
        king_of_clubs = Card.new(:king, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        belote_hand = BeloteHand.new([king_of_clubs, queen_of_clubs])

        expect(belote_hand.belote?).to eq true
      end

      it 'returns false if hand does not include King and Queen of same suit' do
        queen_of_spades = Card.new(:queen, :spades)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_spades])

        expect(belote_hand.belote?).to eq false
      end
    end

    describe '#tierce?' do
      it 'returns true if hand includes three cards with sequent ranks of same suit' do
        jack_of_clubs = Card.new(:jack, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_clubs])

        expect(belote_hand.tierce?).to eq true
      end

      it 'returns false if hand does not include three cards with sequent ranks of same suit' do
        jack_of_spades = Card.new(:jack, :spades)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_spades])

        expect(belote_hand.tierce?).to eq false
      end
    end

    describe '#quarte?' do
      it 'returns true if hand includes four cards with sequent ranks of same suit' do
        jack_of_clubs = Card.new(:jack, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_clubs = Card.new(10, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_clubs,
                                      ten_of_clubs])

        expect(belote_hand.quarte?).to eq true
      end

      it 'returns false if hand does not include four cards with sequent ranks of same suit' do
        jack_of_spades = Card.new(:jack, :spades)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_spades])

        expect(belote_hand.quarte?).to eq false
      end
    end

    describe '#quint?' do
      it 'returns true if hand includes five cards with sequent ranks of same suit' do
        nine_of_clubs = Card.new(9, :clubs)
        jack_of_clubs = Card.new(:jack, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_clubs = Card.new(10, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_clubs,
                                      ten_of_clubs, nine_of_clubs])

        expect(belote_hand.quint?).to eq true
      end

      it 'returns false if hand does not include five cards with sequent ranks of same suit' do
        jack_of_spades = Card.new(:jack, :spades)
        queen_of_clubs = Card.new(:queen, :clubs)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds,
                                      queen_of_clubs, jack_of_spades])

        expect(belote_hand.quint?).to eq false
      end
    end

    describe '#carre_of_jacks?' do
      it 'returns true if hand includes 4 jacks' do
        suits = [:spades, :hearts, :diamonds, :clubs]
        jacks = suits.map { |suit| Card.new(:jack, suit) }
        jacks_hand = BeloteHand.new(jacks)

        expect(jacks_hand.carre_of_jacks?).to eq true
      end

      it 'returns false if hand does not include 4 jacks' do
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds])

        expect(belote_hand.carre_of_jacks?).to eq false
      end
    end

    describe '#carre_of_nines?' do
      it 'returns true if hand includes 4 nines' do
        suits = [:spades, :hearts, :diamonds, :clubs]
        nines = suits.map { |suit| Card.new(9, suit) }
        nines_hand = BeloteHand.new(nines)

        expect(nines_hand.carre_of_nines?).to eq true
      end

      it 'returns false if hand does not include 4 nines' do
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds])

        expect(belote_hand.carre_of_nines?).to eq false
      end
    end

    describe '#carre_of_aces?' do
      it 'returns true if hand includes 4 aces' do
        suits = [:spades, :hearts, :diamonds, :clubs]
        aces = suits.map { |suit| Card.new(:ace, suit) }
        aces_hand = BeloteHand.new(aces)

        expect(aces_hand.carre_of_aces?).to eq true
      end

      it 'returns false if hand does not include 4 aces' do
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        belote_hand = BeloteHand.new([king_of_clubs, ten_of_diamonds])

        expect(belote_hand.carre_of_aces?).to eq false
      end
    end
  end
end

describe SixtySixDeck do
  it 'implements Enumerable' do
    expect(SixtySixDeck).to include(Enumerable)
  end

  it 'fills the deck if no initialize parameters are given' do
    deck = SixtySixDeck.new

    expect(deck.size).to eq 24
  end

  it 'implements all required methods' do
    deck = SixtySixDeck.new

    expect(deck).to respond_to(:size)
    expect(deck).to respond_to(:draw_top_card)
    expect(deck).to respond_to(:draw_bottom_card)
    expect(deck).to respond_to(:top_card)
    expect(deck).to respond_to(:bottom_card)
    expect(deck).to respond_to(:shuffle)
    expect(deck).to respond_to(:sort)
    expect(deck).to respond_to(:to_s)
    expect(deck).to respond_to(:deal)
  end

  describe 'hand' do
    subject(:hand) { SixtySixDeck.new.deal }

    it 'implements all required methods' do
      expect(hand).to respond_to(:size)
      expect(hand).to respond_to(:twenty?)
      expect(hand).to respond_to(:forty?)
    end

    describe '#deal' do
      it 'deals 6 cards' do
        expect(hand.size).to eq 6
      end
    end

    describe '#twenty?' do
      it 'returns true if hand includes King and Queen of the same suit but not of trump suit' do
        king_of_clubs = Card.new(:king, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, queen_of_clubs])

        expect(sixty_six_hand.twenty?(:diamonds)).to eq true
      end

      it 'returns false if hand includes King and Queen of different suits' do
        queen_of_spades = Card.new(:queen, :spades)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, ten_of_diamonds,
                                           queen_of_spades])

        expect(sixty_six_hand.twenty?(:spades)).to eq false
      end

      it 'returns false if hand includes King and Queen of trump suit' do
        king_of_clubs = Card.new(:king, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, queen_of_clubs])

        expect(sixty_six_hand.twenty?(:clubs)).to eq false
      end

      it 'returns false if hand does not include King and Queen' do
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, ten_of_diamonds])

        expect(sixty_six_hand.twenty?(:clubs)).to eq false
      end
    end

    describe '#forty?' do
      it 'returns true if hand includes King and Queen of trump suit' do
        king_of_clubs = Card.new(:king, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, queen_of_clubs])

        expect(sixty_six_hand.forty?(:clubs)).to eq true
      end

      it 'returns false if hand includes King and Queen of different suits' do
        queen_of_spades = Card.new(:queen, :spades)
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, ten_of_diamonds,
                                           queen_of_spades])

        expect(sixty_six_hand.forty?(:spades)).to eq false
      end

      it 'returns false if hand includes King and Queen of same suit but not trump suit' do
        king_of_clubs = Card.new(:king, :clubs)
        queen_of_clubs = Card.new(:queen, :clubs)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, queen_of_clubs])

        expect(sixty_six_hand.forty?(:diamonds)).to eq false
      end

      it 'returns false if hand does not include King or Queen' do
        king_of_clubs = Card.new(:king, :clubs)
        ten_of_diamonds = Card.new(10, :diamonds)
        sixty_six_hand = SixtySixHand.new([king_of_clubs, ten_of_diamonds])

        expect(sixty_six_hand.forty?(:hearts)).to eq false
      end
    end
  end
end
