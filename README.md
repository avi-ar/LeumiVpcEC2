# AWS Web Application Terraform Configuration

This Terraform configuration sets up a complete web application infrastructure on AWS, including networking components and a basic web server.

## Resources Created

- VPC with public and private subnets
- Internet Gateway
- Security Group
- EC2 instance with Apache web server
- Elastic IP associated with the EC2 instance
- Network Load Balancer (NLB)
- Target Group for the NLB
- Route Tables for public and private subnets

## Prerequisites

Before you can use this Terraform configuration, ensure you have:

1. [Terraform](https://www.terraform.io/downloads.html) installed
2. AWS CLI configured with appropriate credentials

## Usage

1. Clone this repository or copy the Terraform configuration files to your local machine.



3. Initialize Terraform:

   ```
   terraform init
   ```

4. Review the planned changes:

   ```
   terraform plan
   ```

5. Apply the configuration:

   ```
   terraform apply
   ```

6. When prompted, type `yes` to confirm and create the resources.

## Network Configuration

- VPC CIDR: 15.0.0.0/16
- Public Subnets: Defined by `var.public_subnet_cidrs`
- Private Subnets: Defined by `var.private_subnet_cidrs`
- Internet Gateway: Attached to the VPC
- Route Tables: Separate tables for public and private subnets

## Security Group

- Inbound: Allows HTTP traffic (port 80) from anywhere
- Outbound: Allows all traffic to 91.231.246.50/32

## Accessing the Web Server

After the resources are created, you can access the web server using the DNS name of the Network Load Balancer. You can find this in the AWS Console or by running:

```
terraform output nlb_dns_name
```

## Cleaning Up

To remove all resources created by this configuration:

```
terraform destroy
```

Type `yes` when prompted to confirm the deletion of resources.

## Note

This configuration sets up basic infrastructure and should be further secured and customized for production use. Always follow AWS best practices for security and cost management.

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements or find any bugs.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
