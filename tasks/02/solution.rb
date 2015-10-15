def snake_ahead_position(snake, direction)
  [snake.last, direction].transpose.map { |coordinates| coordinates.reduce(:+) }
end

def grow(snake, direction)
  snake + [snake_ahead_position(snake, direction)]
end

def move(snake, direction)
  moved_snake = grow(snake, direction)
  moved_snake.shift
  moved_snake
end

def generate_random_food(dimensions)
  xs = rand(dimensions[:width])
  ys = rand(dimensions[:height])
  [xs, ys]
end

def new_food(food, snake, dimensions)
  if (food.length + snake.length) >= dimensions[:width] * dimensions[:height]
    return []
  end

  random_food = generate_random_food(dimensions)
  while food.include? random_food or snake.include? random_food do
    random_food = generate_random_food(dimensions)
  end

  random_food
end

def not_in_bounds?(position, dimensions)
  xs = position[0]
  ys = position[1]
  xs < 0 or xs >= dimensions[:width] or ys < 0 or ys >= dimensions[:height]
end

def wall_ahead?(snake, direction, dimensions)
  not_in_bounds?(snake_ahead_position(snake, direction), dimensions)
end

def snake_part_ahead?(snake, direction)
  snake.include? snake_ahead_position(snake, direction)
end

def obstacle_ahead?(snake, direction, dimensions)
  wall_ahead?(snake, direction, dimensions) or
    snake_part_ahead?(snake, direction)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
