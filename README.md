# README

# Disbursement system

...

## Features

- Setup a docker repository production ready for a rails app
- Setup data model
- Create DB migrations
- Inject data via rake task and store it in DB
- Add business logic services / controllers and routes
- Add test suite and specs

## Getting Started

1. **Setup and start the application:**

   ```bash
   make setup
   ```

2. **Check if the application is running:**

   ```bash
   make health
   ```

3. **View logs:**

   ```bash
   make logs
   ```

4. **Access Rails console:**
   ```bash
   make console
   ```

## Available Commands

- `make setup` - Build and start the application
- `make build` - Build Docker image
- `make up` - Start services
- `make stop` - Stop services
- `make logs` - View logs
- `make console` - Open Rails console
- `make migrate` - Run database migrations
- `make db-reset` - Reset database
- `make health` - Check health status
- `make clean` - Clean up Docker resources for this project

## Health Check

The application includes a health check endpoint at `/up` that returns:

- 200 OK if the application is running properly
- 500 Internal Server Error if there are any issues

## Database

The application uses MySQL 8.0 with the following default configuration:

- Database: `sequra_development`
- Username: `sequra_user`
