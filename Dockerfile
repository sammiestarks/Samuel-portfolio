# NOTE for most react application. First, Add "/node_modules" folder in the ".dockerignore" file
# Delete all previous npm module files. Paste below in terminal:

# rm -rf node_modules package-lock.json

# Then re-install the npm module again in your new system. Paste below in terminal:

# npm install

# Use the line below to build so you can see the progress of your build and where there is any error
# docker build -t <image-name:tag> . --progress=plain

# Then the dockerfile can proceed with the build instructions below:

# ---------- Stage 1: build the application ----------
# Using an Alpine-based Node image (for compact and tiny images)
# FROM node:20-alpine AS builder

#Or

# Using a Debian-based Node image (if apline doesn't work. It’s slightly bigger than apline, but just works.)
# FROM node:20-bullseye AS builder

# Set working directory
# WORKDIR /app

# Copy only package manifests first (for caching)
# COPY package*.json ./
# COPY package-lock.json ./

# Clean npm cache and install dependencies
# RUN npm cache clean --force && npm install

# Explicitly install the platform binary: (Use for node:20-bullseye)
# RUN npm install @rollup/rollup-linux-x64-gnu --save-dev

# Install dependencies
# RUN npm ci

# Copy all source files
# COPY . .

# Build the production bundle
# RUN npm run build

# ---------- Stage 2: serve with nginx ----------
FROM nginx:alpine

# Remove any default nginx static assets (optional)
RUN rm -rf /usr/share/nginx/html/*

# Copying index.html and all other supporting css & JS and plugin files to the nginx default html path
COPY . /usr/share/nginx/html

# (Optional) Add nginx config to support client-side routing for React Router
# You can uncomment and provide your own nginx.conf if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Launch nginx in foreground
CMD ["nginx", "-g", "daemon off;"]