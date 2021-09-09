#!/bin/bash

# See https://aws.amazon.com/premiumsupport/knowledge-center/s3-returns-objects/

BUCKET="mjbrightc-web"

SITE="www.${BUCKET}.s3-website.us-west-1.amazonaws.com/"
REST_URL="www.${BUCKET}.s3.us-west-1.amazonaws.com/"

mkdir -p ~/tmp

XML_PRETTY() {
    #python3 -c 'import sys; import xml.dom.minidom; s=sys.stdin.read(); print xml.dom.minidom.parseString(s).toprettyxml()'
    python3 -c 'import sys,xml.dom.minidom;s=sys.stdin.read();print(xml.dom.minidom.parseString(s).toprettyxml())'
}

BASE_TEST() {
    echo; echo "---- Checking base S3 site & bucket"
    echo "Website request:"
    echo "-- curl -sL $SITE"
    curl -sL $SITE

    echo; echo "S3 API GET: list of contents (from $REST_URL)"
    echo "-- curl -sL $REST_URL"
    curl -sL $REST_URL | tee ~/tmp/op.xml | XML_PRETTY
}

ALIAS_TEST() {
    echo; echo "---- Checking Route53/CloudFront sites"
    for SITE in \
      http://mjbright.click https://mjbright.click \
      http://www.mjbright.click https://www.mjbright.click \
      http://website.mjbright.click https://website.mjbright.click \
      ; do
        #echo "Website request to : $SITE"
        echo; echo "-- curl -L $SITE"
        curl -L $SITE
        CURL_CKSUM=$( curl -sL $SITE | cksum )
        FILE_CKSUM=$(cksum < content/1.simple/index.html)
        [ "$CURL_CKSUM" != "$FILE_CKSUM" ] &&
             echo "curl request failed - cksum error: '$CURL_CKSUM' != '$FILE_CKSUM'"
    done
}

BASE_TEST
ALIAS_TEST

