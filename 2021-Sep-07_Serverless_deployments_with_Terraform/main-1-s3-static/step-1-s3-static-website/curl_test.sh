#!/bin/bash

XML_PRETTY() {
    #python3 -c 'import sys; import xml.dom.minidom; s=sys.stdin.read(); print xml.dom.minidom.parseString(s).toprettyxml()'
    python3 -c 'import sys,xml.dom.minidom;s=sys.stdin.read();print(xml.dom.minidom.parseString(s).toprettyxml())'
}

BUCKET=mjbrightc-web
SITE=www.${BUCKET}.s3-website.us-west-1.amazonaws.com
REST_URL=www.${BUCKET}.s3.us-west-1.amazonaws.com

echo "Website request: to $SITE/"
curl -L $SITE/

mkdir -p ~/tmp
echo; echo "S3 API GET: list of contents (from $REST_URL/)"
curl -sL $REST_URL/ | tee ~/tmp/op.xml | XML_PRETTY

