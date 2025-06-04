# 🍻 BarKeep

> A modern inventory management system designed for bars, restaurants, and beverage establishments. Built with Ruby on Rails and containerized with Docker for easy deployment.

## ✨ Features

- **📦 Inventory Management** - Track all your beverages, ingredients, and supplies
- **📸 Image Support** - Upload and display product images
- **🏷️ Category System** - Organize items with flexible categorization
- **🚨 Stock Alerts** - Automatic low-stock and out-of-stock notifications
- **🔍 Smart Filtering** - Search and filter by name, category, type, and stock status
- **📊 Restocking Dashboard** - Dedicated view for items needing attention
- **🔐 User Authentication** - Secure login system with session management
- **🌙 Dark Theme** - Modern dark UI that's easy on the eyes

## 🐳 Docker Setup

BarKeep is designed to run in Docker containers for consistent deployment across environments.

### Prerequisites

- Docker and Docker Compose installed
- Git (to clone the repository)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bar_keep.git
   cd bar_keep
   ```

2. **Set up the database** (Important: Do this before starting the container!)
   ```bash
   # Create the storage directory if it doesn't exist
   mkdir -p storage

   # Run database setup in a temporary container
   docker run --rm -v $(pwd):/app -w /app ruby:3.4 bash -c "
     gem install bundler &&
     bundle install &&
     bundle exec rails db:create &&
     bundle exec rails db:migrate &&
     bundle exec rails db:seed
   "
   ```

3. **Build and run the container**
   ```bash
   # Build the Docker image
   docker build -t barkeep .

   # Run the container with persistent storage
   docker run -d \
     --name barkeep \
     -p 3000:3000 \
     -v $(pwd)/storage:/app/storage \
     barkeep
   ```

4. **Access the application**

   Open your browser and navigate to `http://localhost:3000`

### Docker Compose (Recommended)

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - ./storage:/app/storage
    environment:
      - RAILS_ENV=production
      - SECRET_KEY_BASE=your_secret_key_here
```

Then run:
```bash
docker-compose up -d
```

## 📁 Data Persistence

All application data is stored in the `storage` directory:
- **SQLite databases** - All environments (development, production, test)
- **Uploaded images** - Product images via ActiveStorage
- **User sessions** - Authentication data

When replacing or updating containers, ensure you mount the same storage volume to maintain your data.

## 🛠️ Development Setup

If you want to run BarKeep without Docker for development:

### Requirements

- Ruby 3.4.0
- Bundler
- SQLite3

### Installation

```bash
# Install dependencies
bundle install

# Set up the database
rails db:create
rails db:migrate
rails db:seed  # Creates sample data

# Start the server
rails server
```

## 🔧 Configuration

### Environment Variables

- `RAILS_ENV` - Set to `production` for production deployments
- `SECRET_KEY_BASE` - Required for production (generate with `rails secret`)
- `RAILS_MAX_THREADS` - Number of threads (default: 5)

### Database

BarKeep uses SQLite by default with databases stored in the `storage` directory:
- Development: `storage/development.sqlite3`
- Production: `storage/production.sqlite3`
- Test: `storage/test.sqlite3`

## 📱 Usage

### Default Credentials

If you ran the seed command, you can log in with:
- **Email**: admin@example.com
- **Password**: password123

### Key Features

1. **Adding Items**: Click "Add New Item" to add beverages and supplies
2. **Managing Stock**: Use the +/- buttons to quickly adjust quantities
3. **Restocking**: Visit `/items/restocking` to see what needs ordering
4. **Categories**: Create categories like "Spirits", "Beer", "Wine", "Mixers"
5. **Filtering**: Use the sidebar filters to find items quickly

## 🚀 Production Deployment

For production deployments:

1. Generate a secret key:
   ```bash
   docker run --rm barkeep rails secret
   ```

2. Set the SECRET_KEY_BASE environment variable
3. Ensure the storage volume is backed up regularly
4. Consider using a reverse proxy (nginx, Caddy) for SSL

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- Styled with [Bootstrap](https://getbootstrap.com/)
- Icons from Unicode Emoji

---

<p align="center">Made with ❤️ for the service industry</p>
