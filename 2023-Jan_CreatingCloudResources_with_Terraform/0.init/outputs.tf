
output website {
    value = var.website_name
}

output url     {
    value = var.website_url
}

output human   {
    value = "${ var.website_name }: '${ var.website_url }'"
}

output functional_human   {
    value = format("%s: %s\n", var.website_name, var.website_url)
}

