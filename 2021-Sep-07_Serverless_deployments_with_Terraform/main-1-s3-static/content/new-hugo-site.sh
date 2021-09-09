#!/bin/bash

# https://discourse.gohugo.io/t/creating-static-content-that-uses-partials/265/10

TITLE="Example website"

SITE_DIR="2.hugo-site"

die() { echo "$0: die - $*" >&2; exit 1; }

which hugo ||
  die "hugo not found in path - download from https://github.com/gohugoio/hugo/releases"

cd $(dirname $0)

RECREATE_SITE() {
    [ -d $SITE_DIR ] && {
        echo "Removing ${SITE_DIR} ..."
        rm -rf $SITE_DIR
    }

    echo "Creating site under ${SITE_DIR} ..."
    hugo new site $SITE_DIR
    [ ! -d $SITE_DIR ] && die "Failed to create empty site"

    sed -i.bak -e "s?^baseURL.*?baseURL = '/'?" \
               -e "s?^title.*?title = '$TITLE'?" \
        config.toml

}

INSTALL_THEME() {
    [ ! -d themes/ananke ] && {
        [ ! -f ~/tmp/theme.ananke.zip ] ||
            [ ! -s ~/tmp/theme.ananke.zip ] &&
                wget -O ~/tmp/theme.ananke.zip wget https://github.com/theNewDynamic/gohugo-theme-ananke/archive/master.zip

        unzip -d themes ~/tmp/theme.ananke.zip

        [ -d themes/gohugo-theme-ananke-master/ ] &&
            mv themes/gohugo-theme-ananke-master/ themes/ananke
    }

    [ ! -d themes/ananke ] && die "Failed to install themes/ananke"

    grep ^theme config.toml ||
        echo 'theme = "ananke"' >> config.toml
        #echo 'theme = "themes/ananke"' >> config.toml
}

CREATE_LAYOUTS() {
    mkdir -p layouts/partials

    cat > layouts/partials/header.html <<EOF
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-us">
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">

  <title> $TITLE </title>
</head>

<body>
EOF

    cat > layouts/partials/footer.html <<EOF
     <!--   <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" type="text/javascript"></script> -->

     <hr />
     <img src="/images/logo.jpg" />

    </body>
</html>
EOF

}

ADD_POSTS() {

    POST=4th
    [ ! -f content/posts/${POST}.md ] && hugo new posts/${POST}.md
    date=$( date -Iseconds -d today )
    cat > content/posts/${POST}.md <<EOF
---
title: "Latest Post"
date: $date
draft: false
---

# Kubernetes 1.22 Released

Today Kubernetes 1.22 was released, refer to https://kubernetes.io/blog for more information.

Download from *K-K* at https://github.com/kubernetes/kubernetes/releases

{{ partial "footer.html" }}

EOF

    POST=3rd
    [ ! -f content/posts/${POST}.md ] && hugo new posts/${POST}.md
    date=$( date -Iseconds -d yesterday )
    cat > content/posts/${POST}.md <<EOF
---
title: "Previous Post"
date: $date
draft: false
---

# Kubernetes 1.21 Released

Today Kubernetes 1.21 was released, refer to https://kubernetes.io/blog for more information.

Download from *K-K* at https://github.com/kubernetes/kubernetes/releases

{{ partial "footer.html" }}

EOF

    POST=2nd
    [ ! -f content/posts/${POST}.md ] && hugo new posts/${POST}.md
    date=$( date -Iseconds -d 'last week' )
    cat > content/posts/${POST}.md <<EOF
---
title: "Oldish Post"
date: $date
draft: false
---

# Kubernetes 1.20 Released

Today Kubernetes 1.20 was released, refer to https://kubernetes.io/blog for more information.

Download from *K-K* at https://github.com/kubernetes/kubernetes/releases

{{ partial "footer.html" }}

EOF

    POST=1st
    [ ! -f content/posts/${POST}.md ] && hugo new posts/${POST}.md
    date=$( date -Iseconds -d '2 week ago' )
    cat > content/posts/${POST}.md <<EOF
---
title: "First Post"
date: $date
draft: false
---

# Kubernetes 1.19 Released

Today Kubernetes 1.19 was released, refer to https://kubernetes.io/blog for more information.

Download from *K-K* at https://github.com/kubernetes/kubernetes/releases


{{ partial "footer.html" }}

EOF


    #sed -i -e 's?^baseURL.*?baseURL: "/"?' \
    
}

RECREATE_SITE
[ ! -d $SITE_DIR ] && die "No site under ${SITE_DIR} ..."
cd $SITE_DIR

CREATE_LAYOUTS
ADD_POSTS
INSTALL_THEME

# Generate content: under $SITE_DIR/public
hugo


