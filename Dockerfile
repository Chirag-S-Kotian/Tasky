# Use the official Node.js image from Docker Hub
FROM node:22-alpine

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json first to optimize layer caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Generate Prisma client (requires the DATABASE_URL environment variable)
RUN npx prisma generate

# Build the application (this will likely build your Next.js app)
RUN npm run build

# Expose the port the app will run on
EXPOSE 3000

# Default command to run the app
CMD ["npm", "run", "start"]
