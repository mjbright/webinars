
website_name = "My professional website"

website_url = "https://www.mjbright.net"

start_web_server =<<EOF
    sudo apk add apache2
    sudo apk add openrc --no-cache
    sudo rc-status status default
    sudo rc-update add apache2 default
    sudo mkdir /run/openrc
    sudo touch /run/openrc/softlevel
    sudo rc-service apache2 restart
    #curl 127.0.0.1
    #ps -fade | grep http
    ps -fade | grep apache
   #sudo rc-service apache2 stop
   #sudo rc-service apache2 start
   curl 127.0.0.1
   ls -al /var/www/localhost/
   ls -al /var/www/localhost/htdocs
   ls -al /var/www/localhost/htdocs/index.html
   sudo cp -a site/* /var/www/localhost/htdocs/
EOF

