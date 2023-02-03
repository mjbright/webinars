global
  stats socket /var/run/api.sock user haproxy group haproxy mode 660 level admin expose-fd listeners
  log stdout format raw local0 info

defaults
  mode http
  timeout client 10s
  timeout connect 5s
  timeout server 10s
  timeout http-request 10s
  log global

frontend stats
  bind *:8404
  stats enable
  stats uri /
  stats refresh 10s

frontend myfrontend
  bind :80
  default_backend webservers

backend webservers
%{ for port_index, port in ports }
server s${ port_index + 1 } ${ ips[ port_index ] }:${ port } check
%{ endfor }

#server s1 web1:8080 check
#server s2 web2:8080 check
#server s3 web3:8080 check




