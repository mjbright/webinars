#!/usr/bin/env bash

# LINE: {"id":"AKIAYIUDT6EGGMX4CPXO","secret":"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","user":"student-0"}

#jq -c '.resources[0].instances[].attributes | { id, secret, user } '  terraform.tfstate  | grep student-0 | sed -e 's/{"id":/export AWS_ACCESS_KEY_ID=/' -e 's/","secret":"/\nexport AWS_SECRET_ACCESS_KEY=/' -e 's/","user.*//' > student0.rc
for LINE in $( jq -c '.resources[0].instances[].attributes | { id, secret, user }' terraform.tfstate ); do
    #echo "LINE: '$LINE'"

    USER="${LINE#*user\":\"}"
    USER="${USER%%\"*}"


    RC_FILE=${USER}.rc
    TF_VARS_FILE=${USER}-aws-credentials.tfvars
    cp /dev/null $RC_FILE
    cp /dev/null $TF_VARS_FILE

    ID="${LINE//{\"id\":\"}"
    ID="${ID%%\"*}"
    echo "export AWS_ACCESS_KEY_ID='$ID'" >> $RC_FILE
    echo "export TF_VAR_AWS_ACCESS_KEY_ID='$ID'" >> $TF_VARS_FILE
  
    SECRET="${LINE#*secret\":\"}"
    SECRET="${SECRET%%\"*}"
    echo "export AWS_SECRET_ACCESS_KEY='$SECRET'" >> $RC_FILE
    echo "export TF_VAR_AWS_SECRET_ACCESS_KEY='$SECRET'" >> $TF_VARS_FILE

    ls -altr $RC_FILE $TF_VARS_FILE
done


