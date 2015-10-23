#!/bin/bash

echo "Running skeptic..."
skeptic --lines-per-method 15 --line-length 100 --max-nesting-depth 2 --methods-per-class 10 --no-semicolons --no-trailing-whitespace --check-syntax --no-global-variables --english-words-for-names='fibonacci' --naming-conventions solution.rb
printf "\n"

echo "Running spec..."
rspec spec.rb --require ./solution.rb --colour --format documentation
