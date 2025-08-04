# Terraform EC2 Instance Setup

This repository contains Terraform configuration files to create an AWS EC2 instance.

## How to Use

1. Make sure you have [Terraform](https://www.terraform.io/downloads.html) installed.
2. Update the variables (like AMI ID, key pair, security group) in the main Terraform file.
3. Run `terraform init` to initialize.
4. Run `terraform plan` to preview changes.
5. Run `terraform apply` to create the infrastructure.

## Notes

- Make sure your AWS credentials are properly configured.
- The key pair `.pem` file should be accessible for SSH access.

## Author

Ahmmed Towfique
