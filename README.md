# 🍻 BarKeep

> A modern inventory management system designed for bars, restaurants, and beverage establishments. Built with Ruby on Rails and containerized with Docker for easy deployment.

[GHCR](https://github.com/nckslvrmn/bar_keep/pkgs/container/bar_keep)
[![License](https://img.shields.io/github/license/nckslvrmn/bar_keep)](LICENSE)

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

BarKeep is available as a pre-built Docker image on GitHub Container Registry (GHCR) for easy deployment.

### Prerequisites

- Docker and Docker Compose installed

### Quick Start

1. **Generate a secret key** (Required!)
   ```bash
   # Pull the image and generate a secret key
   docker run --rm ghcr.io/nckslvrmn/bar_keep:latest rails secret
   ```

   **Copy this key - you'll need it for the next step. Keep it safe and never commit it to version control!**

2. **Run the container**
   ```bash
   # Run the container with persistent storage and your secret key
   docker run -d \
     --name barkeep \
     -p 3000:3000 \
     -v $(pwd)/storage:/app/storage \
     -e SECRET_KEY_BASE=YOUR_GENERATED_SECRET_KEY_HERE \
     -e ALLOWED_HOST=barkeep.yourdomain.com  # Set to your custom domain \
     -e FORCE_SSL=false \
     ghcr.io/nckslvrmn/bar_keep:latest
   ```

   > **Note**: The database will be automatically created, migrated, and seeded on first run!

   > **For production deployments**: Remove `-e FORCE_SSL=false` to enable SSL security unless behind a proxy

3. **Access the application**

   Open your browser and navigate to `http://localhost:3000`

### Docker Compose (Recommended)

1. **Create a `docker-compose.yml` file**:
   ```yaml
   version: '3.8'

   services:
     app:
       image: ghcr.io/nckslvrmn/bar_keep:latest
       ports:
         - "3000:3000"
       volumes:
         - ./storage:/app/storage
       environment:
         - RAILS_ENV=production
         - SECRET_KEY_BASE=YOUR_GENERATED_SECRET_KEY_HERE  # Required!
         - ALLOWED_HOST=barkeep.yourdomain.com  # Set to your custom domain
         - FORCE_SSL=false  # leave as false if hosted behind proxy
   ```

2. Run:
   ```bash
   docker-compose up -d
   ```

### Available Tags

- `latest` - The most recent stable release
- `vX.Y.Z` - Specific release versions (e.g., `v1.0.0`)

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

### Building Docker Image from Source

If you want to build the Docker image from source for development:

1. **Clone the repository**
   ```bash
   git clone https://github.com/nckslvrmn/bar_keep.git
   cd bar_keep
   ```

2. **Build the container**
   ```bash
   docker build -t bar_keep .
   ```

3. **Generate a secret key**
   ```bash
   docker run --rm bar_keep:latest rails secret
   ```

4. **Run your local build**
   ```bash
   docker run -d \
     --name barkeep-dev \
     -p 3000:3000 \
     -v $(pwd)/storage:/app/storage \
     -e SECRET_KEY_BASE=YOUR_GENERATED_SECRET_KEY_HERE \
     -e ALLOWED_HOST=localhost \
     -e FORCE_SSL=false \
     bar_keep:latest
   ```

## 🔧 Configuration

### Environment Variables

- `SECRET_KEY_BASE` - **Required!** Generate with `docker run --rm bar_keep:latest rails secret`
- `RAILS_ENV` - Set to `production` for production deployments (default: production)
- `RAILS_MAX_THREADS` - Number of threads (default: 5)
- `FORCE_SSL` - Set to `false` to disable SSL for local testing or if hosting behind proxy
- `ALLOWED_HOST` - Hostname to accept requests from (default: localhost). Set to your domain in production
- `SEED_DATABASE` - Set to "true" to seed the database in production (optional)

### Host Configuration

By default, Rails accepts requests from localhost (including 127.0.0.1 and ::1) in production mode. Rails uses a security feature that blocks requests from unknown hosts to prevent DNS rebinding attacks.

The `ALLOWED_HOST` environment variable tells Rails which additional hostname to accept requests from. You'll need to set this when:

- Running behind a reverse proxy (nginx, Caddy, etc.)
- Using a custom domain or subdomain
- Accessing the application from a non-localhost address
- Testing with tools like ngrok during development

For example, if your BarKeep instance is accessible at `barkeep.yourdomain.com`, you would set `ALLOWED_HOST=barkeep.yourdomain.com`. If you're using a reverse proxy, make sure the host matches what the proxy forwards.

### Database

BarKeep uses SQLite by default with databases stored in the `storage` directory:
- Development: `storage/development.sqlite3`
- Production: `storage/production.sqlite3`
- Test: `storage/test.sqlite3`

## 📱 Usage

### Default Credentials

If you ran the seed command, you can log in with:
- **Username**: `admin`
- **Password**: `changeme123`

⚠️ **Please change the password after first login!**

### Key Features

1. **Adding Items**: Click "Add New Item" to add beverages and supplies
2. **Managing Stock**: Use the +/- buttons to quickly adjust quantities
3. **Restocking**: Visit `/items/restocking` to see what needs ordering
4. **Categories**: Create categories like "Spirits", "Beer", "Wine", "Mixers"
5. **Filtering**: Use the sidebar filters to find items quickly

## 🚀 Production Deployment

For production deployments:

1. **Use a proper secret key** - Generate one using the method shown in the Docker Setup section
2. **Use a stable version tag** - Consider using a specific version tag (e.g., `ghcr.io/nckslvrmn/bar_keep:v1.0.0`) instead of `latest` for production
3. Ensure the storage volume is backed up regularly
4. Consider using a reverse proxy (nginx, Caddy) for SSL
5. Monitor your logs: `docker logs -f barkeep`

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
