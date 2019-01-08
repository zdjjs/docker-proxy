FROM nginx:alpine
ENV WAIT_HOSTS=nginx:80

RUN apk --no-cache update \
&& apk --no-cache add openssl \
&& wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_linux_x86_64.tgz \
&& tar -xvzf entrykit_0.4.0_linux_x86_64.tgz \
&& rm entrykit_0.4.0_linux_x86_64.tgz \
&& mv entrykit /usr/local/bin/ \
&& entrykit --symlink \
&& wget https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait \
&& chmod +x /wait \
&& mv wait /usr/local/bin/

COPY ./generate_cert.sh /
COPY ./hosts.sh /

ENTRYPOINT [ \
"switch", \
	"hosts=sh /hosts.sh", \
"--", \
"render", \
	"/etc/nginx/nginx.conf", \
"--", \
"prehook",  \
	"sh /generate_cert.sh",  \
	"wait", \
"--", \
"nginx" \
]
