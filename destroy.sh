#!/bin/bash

# Initialize Terraform (if not already initialized)
echo "Initializing Terraform..."
terraform init

# Generate the plan for destroying resources
echo "Generating destroy plan..."
terraform plan -destroy -out=tfdestroyplan

# Apply the destroy plan to remove resources from AWS
echo "Applying destroy plan..."
terraform apply tfdestroyplan

echo "Resources have been destroyed."
