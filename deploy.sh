#!/bin/bash


echo "Initializing Terraform..."
terraform init

# Validate the configuration
echo "Validating Terraform configuration..."
terraform validate

# Generate the plan (this shows you what will be changed)
echo "Generating Terraform plan..."
terraform plan -out=tfplan

# Apply the plan to create resources on AWS
echo "Applying Terraform plan..."
terraform apply tfplan

echo "Deployment complete."
echo "Generating outputs"
terraform output -json > outputs.json
