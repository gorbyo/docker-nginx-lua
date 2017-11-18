# Version: 0.0.2
FROM centos:latest
MAINTAINER Oleh Horbachov <gorbyo@gmail.com>
RUN yum clean all \
    && yum update -y \
    && yum install epel-release -y \
    && yum groups install 'Development Tools' -y
RUN yum install luajit luajit-devel openssl openssl-devel pcre pcre-devel zlib zlib-devel wget -y \
    && yum clean all
RUN wget -c http://nginx.org/download/nginx-1.13.6.tar.gz \
    && wget -c https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz \
    && wget -c https://github.com/openresty/lua-nginx-module/archive/v0.10.11.tar.gz
RUN tar -xzvf nginx-1.13.6.tar.gz &&  tar -xzvf v0.3.0.tar.gz && tar -xzvf v0.10.11.tar.gz
RUN cd nginx-1.13.6/ \
    && LUAJIT_LIB=/usr/lib64/ \
       LUAJIT_INC=/usr/include/luajit-2.0 \
      ./configure --with-ld-opt='-Wl,-rpath,/usr/lib/x86_64-linux-gnu/' --add-module=../ngx_devel_kit-0.3.0 --add-module=../lua-nginx-module-0.10.11 \
    && make -j2 \
    && make install
RUN yum groups remove 'Development Tools' -y \
    && yum remove luajit-devel openssl-devel pcre-devel zlib-devel kernel-debug-devel kernel-headers -y \
    && yum clean all && rm -rf /var/cache/yum

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

COPY index.html /usr/local/nginx/html/index.html

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

STOPSIGNAL SIGTERM

EXPOSE 80 443
