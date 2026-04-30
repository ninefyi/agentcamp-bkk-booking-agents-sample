# Real-Time AirBnB Property Search with Location and Text-based Filters

### Not on Codespaces Yet?

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/documentdb/booking-agents-sample?quickstart=1)

### At Your Codespace? [Start Here](exercises/Module-00.md)

## Features

- **Vector Search**: MongoDB Atlas native vector search for efficient similarity search
- **Geospatial Queries**: Find properties within a radius using MongoDB 2dsphere indexes
- **Semantic Search**: Azure OpenAI embeddings for natural language understanding
- **Hybrid Search**: Combine vector similarity with filters (amenities, location, price)

## Quick Start

### Option 1: GitHub Codespaces (Recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/documentdb/booking-agents-sample?quickstart=1)

1. Click the badge above or create a new Codespace from this repository
2. **Set your Azure OpenAI credentials** (choose one method):
   - **Codespaces Secrets** (recommended):
     - Go to [GitHub Settings → Codespaces](https://github.com/settings/codespaces)
     - Add secrets: `AZURE_OPENAI_ENDPOINT`, `AZURE_OPENAI_API_KEY`
   - **Or edit `.env` file** in the Codespace
3. **Set your MongoDB Atlas connection string** in `.env`
4. Start the backend: `cd src/api && uvicorn main:app --reload`
5. Start the frontend: `cd src/frontend && npm start`

The Codespace includes:

- ✅ Python 3.11 + Node.js 18
- ✅ All dependencies pre-installed
- ✅ MongoDB VS Code extension
- ✅ Ports auto-forwarded (3000, 8000)

### Option 2: Docker Compose (Full Stack)

The easiest way to run the complete application locally:

```bash
# Use make commands
make up      # Start all services
make down    # Stop all services
make logs    # View logs
```

This will start:

- **Frontend**: http://localhost:3000 (React app)
- **Backend API**: http://localhost:8000/docs (FastAPI with Swagger UI)
- Connects to: MongoDB Atlas via `MONGODB_CONNECTION_STRING` env var

See `make help` for all available commands.

### Option 3: Local Development (Manual Setup)

## Prerequisites

- Python 3.8+
- Node.js 16+
- MongoDB Atlas account and connection string
- Azure OpenAI account with deployments for embeddings and chat

## How to run locally

### 1. Set up MongoDB Atlas

Create a MongoDB Atlas cluster and get your connection string:

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a new cluster or use an existing one
3. Whitelist your IP address in Network Access
4. Create a database user
5. Get your connection string (looks like `mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority`)

### 2. Set Environment variables:

Copy the `.env.example` file and rename it to `.env`:

```bash
cp .env.example .env
```

Update the `.env` file with your values:

```env
MONGODB_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority
AZURE_OPENAI_ENDPOINT=https://<resource-name>.openai.azure.com/
AZURE_OPENAI_API_KEY=your-azure-api-key-here
AZURE_OPENAI_API_VERSION=2024-10-21
AZURE_OPENAI_EMBEDDING_DEPLOYMENT=text-embedding-3-small
AZURE_OPENAI_CHAT_DEPLOYMENT=gpt-4o-mini
```

### 3. Load the data:

Follow the workshop modules in `notebooks/` to:

1. Connect to MongoDB Atlas
2. Create vector search index (native MongoDB Atlas vector search)
3. Create geospatial and amenity indexes
4. Load the Airbnb listing data
5. Generate embeddings using Azure OpenAI for each listing

The setup will create:

- **Vector Search Index**: Native MongoDB Atlas vector search for similarity queries
- **Geospatial Index**: `2dsphere` for location-based queries
- **Amenity Index**: For fast filtering by amenities

### 4. Install dependencies:

```bash
cd src/api && pip install -r ../../requirements.txt
cd ../frontend && npm install
```

### 5. Run the app:

Terminal 1 (Backend):

```bash
cd src/api && uvicorn main:app --reload
```

Terminal 2 (Frontend):

```bash
cd src/frontend && npm run start
```

The application will be available at `http://localhost:3000`

## Architecture

- **Backend**: FastAPI with Azure OpenAI for embeddings and chat completions
- **Database**: MongoDB Atlas with native vector search support
  - **Vector Search**: MongoDB Atlas native `$vectorSearch` operator
  - **Geospatial**: MongoDB 2dsphere indexes
  - **Filters**: Compound queries combining vector similarity, location, and amenities
- **Frontend**: React with Leaflet/OpenStreetMap integration
- **Search Flow**:
  1. User query → Azure OpenAI embedding generation
  2. MongoDB Atlas finds similar listings via vector search
  3. Filters applied (location radius, amenities)
  4. Results ranked by similarity score

## MongoDB Atlas Vector Search

MongoDB Atlas supports native vector search through the `$vectorSearch` operator:

- **Index Type**: HNSW (Hierarchical Navigable Small World) for efficient approximate search
- **Similarity Metrics**: Cosine (default), L2 distance, dot product
- **Dimensions**: Flexible vector dimensions (typically 1536 for OpenAI models)
- **Performance**: Optimized for large-scale vector similarity search
