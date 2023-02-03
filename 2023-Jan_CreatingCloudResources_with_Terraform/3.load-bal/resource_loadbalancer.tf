
# Derived from: https://www.haproxy.com/blog/how-to-run-haproxy-with-docker/
# 
# sudo docker run -d --name haproxy --net mynetwork \
#   -v $(pwd):/usr/local/etc/haproxy:ro -p 80:80 -p 8404:8404
#   haproxytech/haproxy-alpine:2.4

# Run haproxy as a Docker Container
resource "docker_container" "loadbalancer" {
  image   = "haproxytech/haproxy-alpine:2.4"
  name    = "lb-haproxy"
  restart = "unless-stopped"

  #network_mode = "host"

  ports {
    internal = 80
    external = 8000
  }

  ports {
    internal = 8404
    external = 8404
  }

  # Examples here: https://github.com/kreuzwerker/terraform-provider-docker/issues/179
  volumes {
    read_only      = true
    host_path      = abspath( "${path.module}/config" )
    container_path = "/usr/local/etc/haproxy"
  }
}

