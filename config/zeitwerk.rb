# config/zeitwerk.rb
# Zeitwerk loader configuration for automatic class loading

require 'zeitwerk'

# Create and configure loader for the gem
loader = Zeitwerk::Loader.for_gem

# Setup eager loading
loader.eager_load

loader
