#!/bin/ash
set -e

if [ ! -d "/root/.aws" ]; then

mkdir /root/.aws

echo "Using Acces Key       : ${ACCESS_KEY_ID}"
echo "and role-arn          : ${ROLE_ARN}"
echo "to access EKS cluster : ${EKS_CLUSTER_NAME}"

cat <<EOF > /root/.aws/credentials
[default]
aws_access_key_id = ${ACCESS_KEY_ID}
aws_secret_access_key = ${SECRET_ACCESS_KEY}
EOF

if ! [ -z "$ROLE_ARN" ]; then
  echo "Setting AWS Profile"
cat <<EOF > /root/.aws/config
[profile default]
source_profile = default
role_arn = ${ROLE_ARN}
region = eu-west-1
EOF
fi

if ! [ -z "$EKS_CLUSTER_NAME" ]; then
  echo "Updating kubeconfig"
  aws eks update-kubeconfig --name $EKS_CLUSTER_NAME
fi

fi

exec "$@"
