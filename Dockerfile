# Use an official Ruby runtime as a parent image
FROM ruby:3.2

# Set the working directory to /app
WORKDIR /app
# Copy the Gemfile and Gemfile.lock from the current directory to the container
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install
# Copy the rest of the application code to the container
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]