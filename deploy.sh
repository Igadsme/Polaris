#!/bin/bash

echo ""
echo "🚀 Polaris Deployment Script"
echo "=========================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed!"
        echo "Please install Node.js from https://nodejs.org/"
        exit 1
    fi
    print_success "Node.js detected: $(node --version)"
}

# Deploy to Vercel
deploy_vercel() {
    print_status "Deploying to Vercel..."
    
    if ! command -v vercel &> /dev/null; then
        print_status "Installing Vercel CLI..."
        npm install -g vercel
    fi
    
    vercel --prod --yes
    print_success "Deployed to Vercel!"
}

# Deploy to Netlify
deploy_netlify() {
    print_status "Deploying to Netlify..."
    
    if ! command -v netlify &> /dev/null; then
        print_status "Installing Netlify CLI..."
        npm install -g netlify-cli
    fi
    
    netlify deploy --prod --dir .
    print_success "Deployed to Netlify!"
}

# Deploy to Heroku
deploy_heroku() {
    print_status "Deploying to Heroku..."
    
    if ! command -v heroku &> /dev/null; then
        print_error "Heroku CLI is not installed!"
        echo "Please install Heroku CLI from https://devcenter.heroku.com/articles/heroku-cli"
        exit 1
    fi
    
    # Check if git repository exists
    if [ ! -d ".git" ]; then
        print_status "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    # Create Heroku app if it doesn't exist
    if ! heroku apps:info &> /dev/null; then
        print_status "Creating Heroku app..."
        heroku create polaris-$(date +%s)
    fi
    
    git add .
    git commit -m "Deploy to Heroku"
    git push heroku main
    print_success "Deployed to Heroku!"
}

# Deploy with Docker
deploy_docker() {
    print_status "Building Docker image..."
    docker build -t polaris-showcase .
    
    print_status "Running Docker container..."
    docker run -d -p 3001:3001 --name polaris polaris-showcase
    
    print_success "Docker container running on port 3001!"
    print_status "Access your app at: http://localhost:3001"
}

# Main deployment menu
show_menu() {
    echo ""
    echo "Choose deployment option:"
    echo "1) Vercel (Recommended - Free & Fast)"
    echo "2) Netlify (Great for Static Sites)"
    echo "3) Heroku (Full Control)"
    echo "4) Docker (Local/Server)"
    echo "5) Show deployment URLs"
    echo "6) Exit"
    echo ""
    read -p "Enter your choice (1-6): " choice
}

# Show deployment URLs
show_urls() {
    echo ""
    echo "🌐 Your Polaris showcase is accessible at:"
    echo ""
    echo "📍 Local: http://localhost:3001"
    echo "📍 Vercel: https://your-project.vercel.app"
    echo "📍 Netlify: https://your-site.netlify.app"
    echo "📍 Heroku: https://your-app.herokuapp.com"
    echo "📍 Railway: https://your-app.railway.app"
    echo ""
}

# Main script
main() {
    print_status "Starting Polaris deployment..."
    
    # Check prerequisites
    check_node
    
    # Show menu and handle choice
    while true; do
        show_menu
        case $choice in
            1)
                deploy_vercel
                break
                ;;
            2)
                deploy_netlify
                break
                ;;
            3)
                deploy_heroku
                break
                ;;
            4)
                deploy_docker
                break
                ;;
            5)
                show_urls
                ;;
            6)
                print_status "Exiting deployment script..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please try again."
                ;;
        esac
    done
    
    print_success "Deployment completed!"
    show_urls
}

# Run main function
main
