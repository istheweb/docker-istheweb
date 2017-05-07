FROM nginx:1.13


RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf

ADD /docker/nginx/default.conf /etc/nginx/conf.d/default.conf
ADD /docker/nginx/default.conf /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
