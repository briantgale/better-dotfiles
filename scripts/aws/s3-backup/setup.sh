#!/bin/bash
# Run these commands in order
# Replace BUCKET_NAME with your chosen bucket name before running

BUCKET_NAME="galenas-restic-backup"
REGION="us-west-2"
IAM_USER="restic-backup"

# 1. Create the bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION

# 2. Block all public access
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# 3. Apply lifecycle rules
aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET_NAME \
  --lifecycle-configuration file://lifecycle.json

# 4. Create IAM user
aws iam create-user --user-name $IAM_USER

# 5. Attach scoped policy to user
aws iam put-user-policy \
  --user-name $IAM_USER \
  --policy-name restic-s3-policy \
  --policy-document file://iam-policy.json

# 6. Create access keys (save the output - you only see the secret once)
aws iam create-access-key --user-name $IAM_USER
