# Stage 1: Build the Angular app
FROM node:18-alpine as build

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular application in production mode
RUN npm run build --prod

# Debugging: Verify the build output
RUN ls -la /app/dist/first-project/browser

# Stage 2: Serve the app with Nginx
FROM nginx:stable-alpine

# Copy the built Angular app from the previous stage
COPY --from=build /app/dist/first-project/browser /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
