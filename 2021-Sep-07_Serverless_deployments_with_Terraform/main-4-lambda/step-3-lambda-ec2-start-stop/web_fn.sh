
BASE_URL=$( terraform output -raw r53_url )

curl -L ${BASE_URL}/ec2_describe
curl -L ${BASE_URL}/ec2_describe/


