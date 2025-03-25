# Use the official NGINX image as the base
FROM nginx:alpine

# Remove the default NGINX static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the Flutter build output to NGINX's default public folder
COPY build/web /usr/share/nginx/html

# Expose port 80 (NGINX default)
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
