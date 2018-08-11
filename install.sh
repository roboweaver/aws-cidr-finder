#!/bin/bash

# Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
# 
# http://aws.amazon.com/apache2.0/
# 
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

set -e

STACK=cidr-findr
# Directory to find the Lambda in
bucket=$1

# Profile to use
profile=$2

# Region
region=us-east-1

if [ -z $bucket ]; then
    read -p "S3 bucket to store template assets (e.g. mybucket): " bucket
fi

if [ -z $profile ]; then
    read -p "Profile to use for account: " profile
fi

# Create the stack
zip -9 -r cidr-findr.zip cidr_findr
aws cloudformation package --profile ${profile} --region ${region} --template-file template.yaml --s3-bucket $bucket --output-template-file template.out.yaml >/dev/null
aws cloudformation deploy --profile ${profile} --region ${region} --template-file template.out.yaml --stack-name $STACK --capabilities CAPABILITY_IAM

# Clean up
rm template.out.yaml
rm cidr-findr.zip
