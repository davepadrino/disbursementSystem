# Makefile for managing the disbursement system application

.PHONY: setup build up stop logs console migrate db-reset health clean

# Initial setup - builds and starts the app
setup: build up migrate

# Build Docker image
build:
	@echo "Building Docker image..."
	docker-compose build

# Start services
up:
	@echo "Starting services..."
	docker-compose up -d

# Stop services
stop:
	@echo "Stopping services..."
	docker-compose stop

# View logs
logs:
	docker-compose logs -f

# Open Rails console
console:
	docker-compose exec web bundle exec rails c

# Generate migration
generate-migration:
ifndef NAME
	@echo "Usage: make generate-migration NAME=<migration_name>"
	@echo "Example: make generate-migration NAME=CreateUsers"
	@exit 1
endif
	docker-compose exec web bundle exec rails generate migration $(NAME)

# Run database migrations
migrate:
	@echo "Migrating database..."
	docker-compose exec web bundle exec rails db:migrate

# Reset database
db-reset:
	docker-compose exec web bundle exec rails db:drop db:create db:migrate

# Check health status
health:
	@echo "Checking health status..."
	curl -f http://localhost:3000/up || echo "Health check failed"

# Clean up Docker resources
clean:
	docker-compose down -v --remove-orphans
