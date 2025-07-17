FROM ruby:3.3.8-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    curl \
    libyaml-dev \
    libffi-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install specific bundler version
RUN gem install bundler -v 2.6.9

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Remove server.pid if it exists to avoid issues on startup
CMD rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0

