def snake_ahead_position(snake, direction)
  snake.last.zip(direction).map do |snake_coordinate, direction_coordinate|
    snake_coordinate + direction_coordinate
  end
end

def grow(snake, direction)
  snake + [snake_ahead_position(snake, direction)]
end

def move(snake, direction)
  grow(snake, direction).drop(1)
end

def new_food(food, snake, dimensions)
  xs, ys = (0...dimensions[:width]).to_a, (0...dimensions[:height]).to_a
  all_positions = xs.product(ys)

  occupied_positions = food + snake

  free_positions = all_positions - occupied_positions
  free_positions.sample
end

def not_in_bounds?(position, dimensions)
  x, y = position
  x < 0 or x >= dimensions[:width] or y < 0 or y >= dimensions[:height]
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
