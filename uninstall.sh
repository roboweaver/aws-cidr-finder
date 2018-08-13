#!/bin/bash

# Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
# 
# http://aws.amazon.com/apache2.0/
# 
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# Profile to use
profile=$1


if [ -z $profile ]; then
    read -p "Profile to use for account: " profile
fi

# Region
region=${2:-us-west-2}

set -e

STACK=cidr-findr

# Create the stack
aws cloudformation delete-stack --stack-name $STACK --profile ${profile} --region ${region} 
