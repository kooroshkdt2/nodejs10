FROM centos/nodejs-10-centos7
USER root

RUN  yum -y install centos-release-scl.noarch epel-release 
RUN  yum -y install httpd24-libcurl nginx wget 
RUN  wget -O installer.sh  https://rpm.nodesource.com/setup_10.x && \
       bash installer.sh
RUN wget -O /etc/yum.repos.d/yarn.repo   https://dl.yarnpkg.com/rpm/yarn.repo && \
    rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg 
RUN yum install yarn -y  && \
    yum clean all  && \
    rm -rf /var/cache/yum
RUN chmod a+rwx   /etc/nginx && \
    ln -s  /dev/stdout //var/log/nginx/access.log && \
    ln -s  /dev/stdout /var/log/nginx/error.log && \
    chown 1001:0 -R /var/log/nginx/ && \
    chmod 777  -R /var/log/nginx/ && \
    sed -i 's/80/8082/g' /etc/nginx/nginx.conf && \
    sed -i 's/"user nginx;"//g' /etc/nginx/nginx.conf && \
    chmod -R a+rwx /var/run && \
    chown -R 1001:0 /var/run && \
    chown -R 1001:0 /etc/nginx/conf.d/ && \
    mkdir -p /var/lib/nginx/tmp/ && \
    chown -R 1001:0 /var/lib/nginx && \
    chmod -R 777 /var/lib/nginx && \
    echo ' /usr/sbin/nginx -g "daemon off;" '   > /usr/libexec/s2i/run  && \
    rpm-file-permissions
RUN echo ' /usr/sbin/nginx -g "daemon off;" '   > /usr/libexec/s2i/run  
USER 1001
