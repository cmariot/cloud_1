# syntax=docker/dockerfile:1

# Get the container Image
FROM alpine:3.16

# Update the index of available packages
# Upgrade the currently installed packages
# Install nginx
RUN apk update && apk upgrade && apk add --no-cache\
	nginx

# Creating new user and group 'www' for nginx
# Create a directory for html files
RUN adduser -D -g 'www' www\
	&& mkdir -p /var/www/wordpress/\
		/log\
	&& chown -R www:www /var/lib/nginx /var/www/wordpress/

# Add the custom nginx configuration files
COPY ./conf/app.conf /etc/nginx/http.d/

# Set the entrypoint on the port 443
EXPOSE 443

# Launch the webserver
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
