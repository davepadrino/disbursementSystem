# Makefile for managing the disbursement system application

.PHONY: setup build up stop logs console migrate db-reset health clean

# Initial setup - builds and starts the app
setup: build up migrate import-data

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

import-data:
	@echo "Starting CSV import..."
	docker-compose exec web bundle exec rails runner scripts/import_data.rb

test-file:
	@echo "Usage make test-file file=<file_route>"
	@echo "Running tests..."
	docker-compose exec web bundle exec rspec ${file}

# Run disbursement tasks manually (for testing/development purposes)
disbursements:
	@echo "Running disbursement tasks..."
	docker-compose exec web bundle exec rake disbursements:process

# Run all disbursement to calculate data to populate reports
disbursements-all:
	@echo "Running disbursement tasks..."
	docker-compose exec web bundle exec rake disbursements:process_all

# Run monthly_fee tasks manually (for testing/development purposes)
monthly-fees:
	@echo "Running monthly_fee tasks..."
	docker-compose exec web bundle exec rake monthly_fees:process

# Run all monthly_fee to calculate data to populate reports
monthly-all:
	@echo "Running monthly_fee tasks..."
	docker-compose exec web bundle exec rake monthly_fees:process_all

# Generate reports
report:
	@echo "Generating reports..."
	docker-compose exec web bundle exec rails runner scripts/report.rb

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
