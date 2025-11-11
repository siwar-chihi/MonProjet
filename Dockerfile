FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css
EXPOSE 80
Test local (facultatif) :
docker build -t monapp:dev .
docker run -d -p 8082:80 --name monappdev monapp:dev
# http://localhost:8080
