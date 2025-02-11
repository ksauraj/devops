# AWS Infrastructure as Code with Terraform

This repository contains Terraform configurations for setting up a comprehensive AWS infrastructure. The infrastructure includes networking components, compute resources, security configurations, and more.

## Infrastructure Components

- **Networking Layer**
  - Application VPC with custom networking (`01-app-network.tf`)
  - Bastion Host VPC (`02-bastion-network.tf`)
  - Transit Gateway for VPC connectivity (`03-transit-gateway.tf`)
  - NAT Gateway for private subnets (`04-nat-gateway.tf`)

- **Security Layer**
  - Security Groups (`05-security-groups.tf`)
  - IAM Roles and Policies (`06-iam-roles.tf`)
  - SSH Key Pairs (`07-ssh-keys.tf`)

- **Compute Layer**
  - Base AMI configuration (`08-base-ami.tf`)
  - EC2 Instances (`09-compute.tf`)

- **Services Layer**
  - Network Load Balancer (`10-load-balancer.tf`)
  - S3 Storage (`11-storage.tf`)

## Prerequisites

- Terraform ~> 1.0
- AWS CLI configured with appropriate credentials
- AWS Provider version ~> 5.0
- AWS Region: us-east-1

## File Structure

```
.
├── 00-provider.tf          # AWS provider configuration
├── 01-app-network.tf       # Application VPC and networking
├── 02-bastion-network.tf   # Bastion host VPC
├── 03-transit-gateway.tf   # Transit gateway configuration
├── 04-nat-gateway.tf       # NAT gateway setup
├── 05-security-groups.tf   # Security group rules
├── 06-iam-roles.tf        # IAM roles and policies
├── 07-ssh-keys.tf         # SSH key pair configuration
├── 08-base-ami.tf         # Base AMI configurations
├── 09-compute.tf          # EC2 instance configurations
├── 10-load-balancer.tf    # Network load balancer setup
├── 11-storage.tf          # S3 bucket configurations
└── 99-outputs.tf          # Output variables
```

## Usage

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the infrastructure plan:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

5. To destroy the infrastructure:
```bash
terraform destroy
```

## Important Notes

- This infrastructure is designed to be deployed in the `us-east-1` region
- The configuration includes a bastion host setup for secure access to private instances
- Network architecture follows AWS best practices with public and private subnets
- Security groups and IAM roles are configured following the principle of least privilege
- Make sure to review and update the CIDR blocks and other network configurations as per your requirements

## Best Practices Implemented

- Structured file organization with numbered prefixes for clear deployment order
- Separation of concerns with modular configuration files
- Transit Gateway for efficient network connectivity
- Bastion host for secure access to private resources
- Network Load Balancer for high availability

## Cost Considerations

Please be aware that deploying this infrastructure will incur costs in your AWS account. Key components that contribute to costs:
- EC2 instances
- NAT Gateway
- Network Load Balancer
- Transit Gateway
- S3 Storage

## Security

- All sensitive resources are placed in private subnets
- Access is controlled through security groups and IAM roles
- Bastion host is the only entry point to private instances
- Network traffic is routed through Transit Gateway for better control

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
