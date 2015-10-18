#!/bin/bash

echo "Running skeptic..."
skeptic --line-length 80 --no-semicolons --no-trailing-whitespace --check-syntax --no-global-variables --naming-conventions solution.rb
printf "\n"

echo "Running spec..."
rspec spec.rb --require ./solution.rb --colour --format documentation
