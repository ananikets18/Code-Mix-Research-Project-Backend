#!/bin/bash
# ========================================
# DigitalOcean Droplet Deployment Script
# NLP API - Code-Mix Research Project
# Droplet: 139.59.34.173 (BLR1, 8GB RAM)
# ========================================

set -e

echo "================================================"
echo "  NLP API - DigitalOcean Deployment"
echo "  Droplet: 139.59.34.173"
echo "================================================"

# ========================================
# Step 1: System Setup
# ========================================
echo ""
echo "[1/7] Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# ========================================
# Step 2: Install Docker & Docker Compose
# ========================================
echo ""
echo "[2/7] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker installed successfully"
else
    echo "Docker already installed"
fi

# Install Docker Compose plugin
echo "Installing Docker Compose..."
sudo apt-get install -y docker-compose-plugin 2>/dev/null || {
    # Fallback to standalone docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

# ========================================
# Step 3: Create Swap (4GB)
# ========================================
echo ""
echo "[3/7] Setting up 4GB swap..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo "4GB swap created"
else
    echo "Swap already exists"
fi

# ========================================
# Step 4: Setup Firewall
# ========================================
echo ""
echo "[4/7] Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
echo "Firewall configured (SSH, HTTP, HTTPS)"

# ========================================
# Step 5: Clone Repository
# ========================================
echo ""
echo "[5/7] Setting up project..."
PROJECT_DIR="/opt/nlp-api"

if [ ! -d "$PROJECT_DIR" ]; then
    sudo mkdir -p $PROJECT_DIR
    sudo chown $USER:$USER $PROJECT_DIR
    echo "Created project directory: $PROJECT_DIR"
    echo ""
    echo ">>> Clone your repo now:"
    echo "    cd $PROJECT_DIR"
    echo "    git clone https://github.com/ananikets18/Code-Mix-Research-Project-Backend.git ."
    echo ""
    echo ">>> Or copy files from local machine:"
    echo "    scp -r ./* root@139.59.34.173:$PROJECT_DIR/"
else
    echo "Project directory exists: $PROJECT_DIR"
fi

# Create required directories
mkdir -p $PROJECT_DIR/logs
mkdir -p $PROJECT_DIR/logs/nginx
mkdir -p $PROJECT_DIR/data
mkdir -p $PROJECT_DIR/adaptive_learning

# ========================================
# Step 6: Environment Setup
# ========================================
echo ""
echo "[6/7] Environment setup..."
if [ ! -f "$PROJECT_DIR/.env" ]; then
    if [ -f "$PROJECT_DIR/.env.production" ]; then
        cp $PROJECT_DIR/.env.production $PROJECT_DIR/.env
        echo "Copied .env.production to .env"
        echo ""
        echo ">>> IMPORTANT: Edit .env with your production keys:"
        echo "    nano $PROJECT_DIR/.env"
        echo ""
        echo "    You need to set:"
        echo "    - API_KEY (run: python3 generate-keys.py)"
        echo "    - JWT_SECRET_KEY"
        echo "    - UPSTASH_REDIS_REST_URL"
        echo "    - UPSTASH_REDIS_REST_TOKEN"
    else
        echo "WARNING: No .env.production found. Create .env manually."
    fi
else
    echo ".env file exists"
fi

# ========================================
# Step 7: ML Models Check
# ========================================
echo ""
echo "[7/7] ML Models check..."
echo ""
echo "Your ML models (~5.6 GB) need to be on the Droplet."
echo "Required model folders:"
echo "  - ai4bharatIndicBERTv2-alpha-SentimentClassification"
echo "  - cardiffnlptwitter-xlm-roberta-base-sentiment"
echo "  - cis-lmuglotlid"
echo "  - oleksiizirka-xlm-roberta-toxicity-classifier"
echo ""
echo "Transfer them with:"
echo "  scp -r ./ai4bharatIndicBERTv2-alpha-SentimentClassification root@139.59.34.173:$PROJECT_DIR/"
echo "  scp -r ./cardiffnlptwitter-xlm-roberta-base-sentiment root@139.59.34.173:$PROJECT_DIR/"
echo "  scp -r ./cis-lmuglotlid root@139.59.34.173:$PROJECT_DIR/"
echo "  scp -r ./oleksiizirka-xlm-roberta-toxicity-classifier root@139.59.34.173:$PROJECT_DIR/"

# ========================================
# Summary
# ========================================
echo ""
echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "  1. Clone/copy the repo to $PROJECT_DIR"
echo "  2. Copy ML models to $PROJECT_DIR"
echo "  3. Edit .env with production keys"
echo "  4. Start the application:"
echo ""
echo "     cd $PROJECT_DIR"
echo "     docker compose up -d --build"
echo ""
echo "  5. Check health:"
echo "     curl http://139.59.34.173/health"
echo ""
echo "  6. View logs:"
echo "     docker compose logs -f"
echo ""
echo "================================================"
