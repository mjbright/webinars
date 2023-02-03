
output website {
  value = var.website_name
}

output url     {
  value = var.website_url
}

locals {
  human = "${ var.website_name }: '${ var.website_url }'"

  functional_human = format("%s: %s\n", var.website_name, var.website_url)

  the_answer_to_life = "The answer to life, the universe and everything is ${ local.the_answer }"

  colors = [ "#ffaaaa",   "#aaffaa",          "#aaaaff"          ]
  titles = [ "Terraform",   "Vault",          "Consul"          ]
  images = [ "tf.logo.png", "vault.logo.png", "consul.logo.png" ]

  content = [ for idx, img in local.images :
      templatefile("${path.module}/site/index.html.tpl", {
          color = local.colors[ idx ],
          image = img,
          title = local.titles[ idx ]
    }) ]

  haproxy_cfg = templatefile("${path.module}/config/haproxy.cfg.tpl", {
          # ?? ips   = docker_container.pseudo_vm_web.*.networks_advanced.ipv4_address,
          # ports = var.web_ports

          # Hack:
          ips   = [ "172.17.0.2", "172.17.0.3", "172.17.0.4" ]
          ports = [ 80, 80, 80 ]
    })
}

resource "local_file" "index_file" {
    count    = length( local.images )

    filename = "site/index.${ count.index }.html"
    content = local.content[ count.index ]
}

resource "local_file" "haproxy_cfg" {
    filename = "config/haproxy.cfg"
    content = local.haproxy_cfg
}

output content {
    value = local.content
}

output ssh_base_cmd {
    value = [ for idx, ssh_port in var.ssh_ports : 
          format("ssh -i %s -p %d %s@127.0.0.1", 
            local_file.pseudo-vm-sshkey-file.filename,
            ssh_port,
            var.ssh_user 
          )
    ]
}

output curl_cmd {
    value = [ for web_port in var.web_ports : 
          format("curl -L 127.0.0.1:%s", web_port)
    ]
}

