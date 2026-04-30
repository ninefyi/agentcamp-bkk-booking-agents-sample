#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Fix permissions if needed
echo "🔧 Configuring environment..."

# Install MongoDB Shell (mongosh) for Atlas connectivity and local inspection
echo "📦 Installing MongoDB Shell (mongosh)..."
wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-7.0.asc > /dev/null
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null
sudo apt-get update -qq
sudo apt-get install -y -qq mongodb-mongosh
echo "✅ mongosh installed: $(mongosh --version)"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Install frontend dependencies
echo "📦 Installing Node.js dependencies..."
cd src/frontend
npm install
cd ../..

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from example..."
    cp .env.example .env
    
    echo ""
    echo "⚠️  IMPORTANT: Configure your environment variables!"
    echo "   1. Edit .env file and add your MONGODB_CONNECTION_STRING"
    echo "   2. Add your Azure OpenAI settings (endpoint, key, deployments)"
    echo "   3. Or set them as Codespaces secrets:"
    echo "      https://github.com/settings/codespaces"
    echo ""
fi

# If Azure credentials are set as environment variables, update .env file
if [ -n "$AZURE_OPENAI_API_KEY" ]; then
    echo "✅ AZURE_OPENAI_API_KEY is configured (from environment)"
    sed -i "s|^AZURE_OPENAI_API_KEY=.*|AZURE_OPENAI_API_KEY=$AZURE_OPENAI_API_KEY|" .env
else
    echo "⚠️  WARNING: AZURE_OPENAI_API_KEY is not set!"
    echo "   Set it as a Codespaces secret or in your .env file"
fi

if [ -n "$AZURE_OPENAI_ENDPOINT" ]; then
    sed -i "s|^AZURE_OPENAI_ENDPOINT=.*|AZURE_OPENAI_ENDPOINT=$AZURE_OPENAI_ENDPOINT|" .env
fi

if [ -n "$MONGODB_CONNECTION_STRING" ]; then
    echo "✅ MONGODB_CONNECTION_STRING is configured (from environment)"
    sed -i "s|^MONGODB_CONNECTION_STRING=.*|MONGODB_CONNECTION_STRING=$MONGODB_CONNECTION_STRING|" .env
else
    echo "⚠️  WARNING: MONGODB_CONNECTION_STRING is not set!"
    echo "   Set it as a Codespaces secret or in your .env file"
fi

# Create helpful aliases
echo "📝 Creating helpful bash aliases..."
cat >> ~/.bashrc << 'EOF'

# Booking workshop aliases
alias workspace='cd /workspaces/booking-agents-sample'
alias start-backend='cd /workspaces/booking-agents-sample/src/api && uvicorn main:app --reload --host 0.0.0.0'
alias start-frontend='cd /workspaces/booking-agents-sample/src/frontend && npm start'
alias start-all='start-backend & start-frontend'
alias db-connect='[[ -n "$MONGODB_CONNECTION_STRING" ]] && mongosh "$MONGODB_CONNECTION_STRING" || echo "Set MONGODB_CONNECTION_STRING first"'

EOF

echo ""
echo "✨ ============================================== ✨"
echo "   Setup Complete! 🎉"
echo "✨ ============================================== ✨"
echo ""
echo "📚 Next Steps:"
echo ""
echo "   1. Configure your MongoDB Atlas connection string"
echo "   2. Configure Azure OpenAI endpoint, key, and deployment names"
echo "   3. Start the backend: cd src/api && uvicorn main:app --reload --host 0.0.0.0"
echo "   4. Start the frontend: cd src/frontend && npm start"
echo ""
echo "💡 Helpful aliases available (run 'source ~/.bashrc' first):"
echo "   - start-backend  : Start FastAPI backend"
echo "   - start-frontend : Start React frontend"
echo "   - db-connect     : Connect to MongoDB with mongosh"
echo ""
