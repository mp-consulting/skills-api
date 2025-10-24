#!/usr/bin/env ruby
# analyze_cv.rb
# Backward compatibility wrapper for Thor-based CLI

require_relative 'cli'

# This script provides backward compatibility with the old analyze_cv.rb interface
# The actual CLI logic has been refactored into cli.rb using the Thor framework
#
# Usage remains the same:
#   ruby analyze_cv.rb --role <role> --cv <cv_file.pdf> [--output <output_file>]
#
# For new usage with Thor, use:
#   ruby cli.rb analyze <role> <cv_file> [--output OUTPUT] [--logging]
