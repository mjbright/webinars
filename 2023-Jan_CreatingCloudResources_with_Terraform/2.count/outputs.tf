
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
          color = local.colors[ idx ]
          image = img
          title = local.titles[ idx ]
    }) ]
}

resource "local_file" "index_file" {
    count    = length( local.images )

    filename = "site/index.${ count.index }.html"
    content = local.content[ count.index ]
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

