FROM nginx
# comment
COPY top10movies /usr/share/nginx/html
COPY top10games /usr/share/nginx/html
COPY top10songs /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
