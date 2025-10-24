#!/bin/bash
# Setup script for Dev Container
# Run after container is created to configure environment

set -e

echo "🚀 Configuring Skills API Dev Container..."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
# Anthropic API Configuration
ANTHROPIC_API_KEY=your-anthropic-api-key-here

# Optional: Enable LLM response logging
# LLM_LOGGING=true
EOF
    echo "✅ .env file created. Please add your ANTHROPIC_API_KEY."
else
    echo "✅ .env file already exists"
fi

# Verify Ruby version
echo "📦 Verifying Ruby installation..."
ruby_version=$(ruby --version)
echo "   $ruby_version"

# Verify bundler
echo "📦 Verifying Bundler..."
bundle --version

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p reports logs/llm

echo ""
echo "✨ Dev Container setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your ANTHROPIC_API_KEY"
echo "2. Test with: ruby cli.rb --help"
