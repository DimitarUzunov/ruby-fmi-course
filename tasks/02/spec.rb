describe '#snake_ahead_position' do
  it 'returns snake\'s next front position in particular direction' do
    expect(snake_ahead_position([[4, 5], [4, 6], [5, 6], [5, 7]], [0, 1])).
      to eq [5, 8]

    expect(snake_ahead_position([[4, 5], [4, 6], [5, 6], [5, 7]], [0, -1])).
      to eq [5, 6]

    expect(snake_ahead_position([[4, 5], [4, 6], [5, 6], [5, 7]], [1, 0])).
      to eq [6, 7]

    expect(snake_ahead_position([[4, 5], [4, 6], [5, 6], [5, 7]], [-1, 0])).
      to eq [4, 7]
  end
end

describe '#move' do
  it 'moves snake right' do
    expect(move([[4, 5], [4, 6], [5, 6], [5, 7]], [0, 1])).
      to eq [[4, 6], [5, 6], [5, 7], [5, 8]]

    expect(move([[4, 5], [4, 6], [5, 6], [5, 7]], [0, -1])).
      to eq [[4, 6], [5, 6], [5, 7], [5, 6]]

    expect(move([[4, 5], [4, 6], [5, 6], [5, 7]], [1, 0])).
      to eq [[4, 6], [5, 6], [5, 7], [6, 7]]

    expect(move([[4, 5], [4, 6], [5, 6], [5, 7]], [-1, 0])).
      to eq [[4, 6], [5, 6], [5, 7], [4, 7]]
  end
end

describe '#grow' do
  it 'grows snake right' do
    expect(grow([[4, 6], [5, 6], [5, 7]], [0, 1])).
      to eq [[4, 6], [5, 6], [5, 7], [5, 8]]

    expect(grow([[4, 6], [5, 6], [5, 7]], [0, -1])).
      to eq [[4, 6], [5, 6], [5, 7], [5, 6]]

    expect(grow([[4, 6], [5, 6], [5, 7]], [1, 0])).
      to eq [[4, 6], [5, 6], [5, 7], [6, 7]]

    expect(grow([[4, 6], [5, 6], [5, 7]], [-1, 0])).
      to eq [[4, 6], [5, 6], [5, 7], [4, 7]]
  end
end

describe '#new_food' do
  it 'generates new food' do
    expect(new_food([[0, 0]], [[0, 1], [1, 1]], {width: 2, height: 2})).
      to eq [1, 0]

    expect(new_food([[0, 0], [0, 1], [0, 2], [0, 3], [1, 2]],
                    [[1, 0], [1, 1], [2, 1], [2, 2], [2, 3], [1, 3]],
                    {width: 3, height: 4})).
    to eq [2, 0]
  end
end

describe '#obstacle_ahead?' do
  it 'returns true if wall in front of snake' do
    expect(obstacle_ahead?([[3, 8], [3, 9]], [0, 1], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[3, 1], [3, 0]], [0, -1], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[8, 8], [9, 8]], [1, 0], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[1, 8], [0, 8]], [-1, 0], {width: 10, height: 10})).
      to eq true
  end

  it 'returns true if part of snake in front of snake' do
    expect(obstacle_ahead?([[3, 1], [3, 0]], [0, 1], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[3, 8], [3, 9]], [0, -1], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[1, 8], [0, 8]], [1, 0], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[8, 8], [9, 8]], [-1, 0], {width: 10, height: 10})).
      to eq true

    expect(obstacle_ahead?([[1, 1], [1, 2], [2, 2], [2, 3], [1, 3]], [0, -1],
                           {width: 10, height: 10})).
    to eq true
  end
end

describe '#danger?' do
  it 'returns true if position in front of snake is a wall' do
    expect(danger?([[3, 8], [3, 9]], [0, 1], {width: 10, height: 10})).
      to eq true

    expect(danger?([[3, 7], [3, 8]], [0, 1], {width: 10, height: 10})).
      to eq true
  end

  it 'returns true if position in front of snake is a part of snake' do
    expect(danger?([[1, 1], [1, 2], [2, 2], [2, 3], [1, 3]], [0, -1],
                   {width: 10, height: 10})).
    to eq true

    expect(danger?([[1, 1], [1, 2], [2, 2], [2, 3], [2, 4], [1, 4]], [0, -1],
                   {width: 10, height: 10})).
    to eq true
  end
end
