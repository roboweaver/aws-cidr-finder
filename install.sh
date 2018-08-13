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

# Profile to use
profile=$1

# Region
region=${2:-us-west-2}

if [ -z $profile ]; then
    read -p "Profile to use for account: " profile
fi

bucket=${profile}-artifacts-${region}

if aws s3 ls ${bucket} --profile ${profile} 2>&1 | grep -q 'NoSuchBucket'
then
	if aws s3api create-bucket --bucket ${bucket} --region ${region} --create-bucket-configuration LocationConstraint=${region} --profile ${profile}
	then
		aws s3api put-bucket-versioning --bucket ${bucket} --versioning-configuration Status=Enabled --profile ${profile} --region ${region}
		echo "[CREATED] ${bucket}"			
	else
                returnCode=$?
		echo "[FAILED TO CREATE] ${bucket}"
                exit ${returnCode}
	fi
fi

# Create the stack
zip -9 -r cidr-findr.zip cidr_findr
aws cloudformation package --profile ${profile} --region ${region} --template-file template.yaml --s3-bucket $bucket --output-template-file template.out.yaml >/dev/null
aws cloudformation deploy --profile ${profile} --region ${region} --template-file template.out.yaml --stack-name $STACK --capabilities CAPABILITY_IAM

# Clean up
rm template.out.yaml
rm cidr-findr.zip
