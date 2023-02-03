
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

  content = join("\n", [
        "<html><body>",
           "<title>",
               local.functional_human,
           "</title>",
           local.the_answer_to_life,
        "</body></html>"
    ])
}

output content {
    value = local.content
}

output ssh_base_cmd {
    value = format("ssh -i %s -p %d %s@127.0.0.1", 
          local_file.pseudo-vm-sshkey-file.filename,
          var.ssh_port,
          var.ssh_user 
    )
}

