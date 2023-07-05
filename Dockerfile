# Use a base Node.js image
FROM node:14 as build-stage

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the entire application to the container
COPY . .

# Build the Vue.js application
RUN npm run build

# Use a smaller base image for the production stage
FROM nginx:alpine as production-stage

# Copy the built files from the build-stage container to the production-stage container
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]