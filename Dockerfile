# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:latest as build

# Set the working directory
WORKDIR /usr/local/app

# Add the source code to app
COPY ./ /usr/local/app/

# Install all the dependencies
RUN npm install

# Generate the build of the application
RUN npm run build

ARG APP_NAME

RUN ls -la /usr/local/app/dist/${APP_NAME}

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:alpine

# Define ARG to accept environment variable
ARG APP_NAME

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/local/app/dist/${APP_NAME}/browser/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf
# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
