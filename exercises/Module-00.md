# Module 0: Setup & Environment

## 🎯 Learning Objectives

By the end of this module, you will:

- ✅ Have a working Codespaces environment
- ✅ Understand the project structure and architecture
- ✅ Configure your OpenAI API key
- ✅ Verify MongoDB Atlas connection
- ✅ Understand the dataset you'll be working with

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- GitHub account
- OpenAI API key ([Get one here](https://platform.openai.com/api-keys))
- Codespace created from this repository

---

## Step 1: Configure Workshop Environment

This workshop is designed to run entirely in **GitHub Codespaces**, providing a consistent, pre-configured development environment for all participants.

> 💡 **Why Codespaces?** No local setup required, consistent environment for everyone, and automatic dependency installation.

### Launch Your Codespace

1. **Navigate to the repository**:
   - Go to: `https://github.com/documentdb/booking-agents-sample`

2. **Open in GitHub Codespaces**:
   - Click the green **"Code"** button
   - Select the **"Codespaces"** tab
   - Click **"Create codespace on workshop"**

   Alternatively, click this badge:

   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/documentdb/booking-agents-sample/tree/workshop)

3. **Wait for the environment to build** (first launch takes 2-3 minutes):
   - Python 3.11 environment
   - Node.js 20
   - Docker-in-Docker
   - VS Code extensions (MongoDB, Python, Docker)
   - All dependencies automatically installed

4. **Verify Codespace is ready**:
   - You should see VS Code in your browser
   - Extensions should be installed (check the sidebar)
   - Terminal should be available at the bottom

5. **Open a terminal** (Terminal → New Terminal) and proceed to Activity 2

---

## Step 2: Set Up MongoDB Atlas Connection

You'll connect your application to an external MongoDB Atlas cluster.

### Create MongoDB Atlas Cluster

1. **Go to MongoDB Atlas**:
   - Visit [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Sign up or log in with your account

2. **Create a new project and cluster**:
   - Click "Create a Project"
   - Click "Create a Deployment"
   - Choose M0 (free tier) or your preferred tier
   - Select your region
   - Complete the setup

3. **Whitelist Your IP Address**:
   - In the Atlas dashboard, go to "Network Access"
   - Click "Add IP Address"
   - For development, you can select "Allow Access from Anywhere" (or add your Codespace IP)

4. **Create a Database User**:
   - Go to "Database Access"
   - Click "Create a Database User"
   - Save the username and password

5. **Get Your Connection String**:
   - Click the "Connect" button on your cluster
   - Select "Connect your application"
   - Copy the connection string (looks like `mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority`)

### Connect to MongoDB Atlas with VS Code Extension

You can use the MongoDB for VS Code extension to explore your cluster:

1. **Install MongoDB for VS Code**:
   - Go to the Extensions sidebar
   - Search for "MongoDB for VS Code"
   - Click Install

2. **Add a connection**:
   - Click the MongoDB icon in the sidebar
   - Click "Add Connection"
   - Paste your connection string
   - Click "Connect"

3. **Verify the connection** - You should see your cluster in the MongoDB explorer

---

## Step 3: Load Sample Data into MongoDB Atlas

Now that you have a MongoDB Atlas cluster, let's load sample data for the workshop.

### Understanding the Sample Data

The workshop includes a JSON file with sample data that already contains vector embeddings:

- `data/embedded_data.json` - Combined Airbnb listings with pre-generated embeddings

### Load Data Using MongoDB for VS Code Extension

1. **Open the MongoDB extension**:
   - Click the MongoDB icon in the left sidebar
   - Expand your connection to see databases

2. **Create the database and collections**:
   - Right-click on your connection
   - Select **"Create Database"**
   - Enter database name: `db`
   - Press Enter

3. **Create the listings collection**:
   - Expand the `db` database
   - Right-click on the database
   - Select **"Create Collection"**
   - Enter collection name: `listings`
   - Press Enter

4. **Import data**:
   - Right-click on the `listings` collection
   - Select **"Import Documents"**
   - Navigate to: `data/embedded_data.json`
   - Click **"Open"**
   - Wait for the import confirmation message

---

## 🔑 Step 4: Configure Azure OpenAI Credentials

You need Azure OpenAI credentials to generate embeddings and use chat completions.

1. Create a `.env` file in the project root if it isn't created already:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your Azure OpenAI credentials:

   ```env
   MONGODB_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority
   AZURE_OPENAI_ENDPOINT=https://<resource-name>.openai.azure.com/
   AZURE_OPENAI_API_KEY=your-azure-api-key-here
   AZURE_OPENAI_API_VERSION=2024-10-21
   AZURE_OPENAI_EMBEDDING_DEPLOYMENT=text-embedding-3-small
   AZURE_OPENAI_CHAT_DEPLOYMENT=gpt-4o-mini
   ```

3. Save the file

### Verify Your Credentials

Run this Python snippet to test:

```bash
python -c "import os; from dotenv import load_dotenv; load_dotenv(); print('✅ MongoDB configured' if os.getenv('MONGODB_CONNECTION_STRING') else '❌ MongoDB missing'); print('✅ Azure OpenAI configured' if os.getenv('AZURE_OPENAI_API_KEY') else '❌ Azure OpenAI missing')"
```

---

## ✅ Verification Checklist

Before moving to Module 1, verify:

- [ ] ✅ Codespace is running without errors
- [ ] ✅ Azure OpenAI credentials are configured
- [ ] ✅ MongoDB Atlas connection works
- [ ] ✅ You understand the project structure
- [ ] ✅ You've explored the dataset
- [ ] ✅ You understand the architecture

---

## 🎓 Concepts to Remember

### Vector Search

- Converts text to numerical vectors (embeddings)
- Finds similar items by comparing vector distances
- Enables semantic search ("find me something cozy" vs exact keyword match)

### MongoDB Atlas Vector Search

- Native vector search operator
- Supports IVF (Inverted File Index) and HNSW algorithms
- Allows combining vector similarity with other filters

### RAG (Retrieval-Augmented Generation)

- Retrieves relevant documents from a database
- Augments LLM prompts with retrieved context
- Generates accurate, grounded responses

### Multi-Agent Systems

- Multiple specialized AI agents working together
- Each agent has a specific role/expertise
- Agents coordinate to solve complex tasks

---

## 🐛 Troubleshooting

### Codespace won't start

- Wait a few minutes (initial build takes 2-3 min)
- Check GitHub status page
- Try rebuilding: Codespaces menu → Rebuild Container

### MongoDB Atlas not connecting

```bash
# Verify .env file has correct connection string
grep MONGODB_CONNECTION_STRING .env

# Test connection using mongosh
mongosh "your-connection-string"
```

### Azure OpenAI API errors

- Verify your API key and endpoint are correct in `.env`
- Check your Azure OpenAI account has available quota
- Make sure the key has permission to use embeddings and chat deployments

### Import errors

```bash
# Reinstall dependencies
pip install -r requirements.txt
```

---

## 🚀 Next Steps

You're all set! Time to build your first vector search implementation.

**Continue to**: [Module 1: Vector Search Fundamentals](Module-01.md)

---

**Questions?** Ask your instructor or check the [troubleshooting guide](Home.md#debugging).
