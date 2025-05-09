## Terraform Project Documentation: Secure and Reusable AWS Infrastructure for Static React App

This project provisions a secure, reusable AWS environment using Terraform to deploy a static React app in Docker on an EC2 instance, with public access via a custom domain.

---

## **Project Structure**

- `main.tf`: Core infrastructure resources (VPC, subnet, route table, IGW, security groups, EC2, EIP, Route53)
- `provider.tf`: AWS provider configuration
- `terraform.tf`: Terraform backend and provider requirements
- `variables.tf`: Input variables for reusability and security
- `terraform.tfvars`: Variable values (never commit secrets)
- `outputs.tf`: Useful outputs (AMI ID, EC2 IP, EIP, domain)

---

## **Infrastructure Overview**

### **1. VPC and Subnet**

- **VPC**: Custom CIDR, tagged for identification.
- **Subnet**: Public, mapped for auto-assigned public IPs, in a specified AZ.

### **2. Networking**

- **Internet Gateway**: Attached to VPC for outbound internet.
- **Route Table**: Routes all traffic (`0.0.0.0/0`) through IGW.
- **Route Table Association**: Links subnet to route table.

### **3. Security Groups**

- **Custom Security Group**:
  - HTTP (port 80) open to all for web access.
  - SSH (port 22) restricted to a specific IP for admin access.
  - Egress open for outbound traffic.
- **Implemented using `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` for fine-grained control.**

### **4. Compute**

- **EC2 Instance**:
  - Latest Ubuntu 24.04 LTS AMI (auto-discovered).
  - Instance type configurable.
  - SSH key managed via Terraform.
  - User data installs Docker, runs static React app container (`amitgujar/static-app`), logs execution.
  - Public IP association for direct access.

### **5. Elastic IP**

- **EIP**: Static public IP for the EC2 instance, ensuring a stable endpoint.

### **6. DNS**

- **Route53**:
  - Fetches hosted zone for the domain.
  - Creates `A` records for root and `www` subdomains pointing to the EIP.

---

## **Security and Reusability Practices**

- **Variables**: All sensitive and environment-specific values are parameterized.
- **SSH Access**: Restricted to a single trusted IP (`ssh_cidr_block`).
- **Key Management**: Public SSH key path is variable-driven.
- **Tags**: All resources are tagged for traceability.
- **User Data**: Uses cloud-init for idempotent provisioning.
- **Outputs**: Exposes only non-sensitive data.

---

## **Example Usage**

1. **Clone the repository:**

   ```bash
   git clone
   cd terraform
   ```

2. **Configure variables in `terraform.tfvars`:**

   - Set `project_name_prefix`, `domain_name`, `aws_region`, etc.

3. **Initialize Terraform:**

   ```bash
   terraform init
   ```

4. **Review plan:**

   ```bash
   terraform plan
   ```

5. **Apply infrastructure:**

   ```bash
   terraform apply
   ```

6. **Access your app:**
   - Visit `http://<your-domain>` or `http://<EIP>`.

---

## **Key Files Explained**

| File               | Purpose                                         |
| ------------------ | ----------------------------------------------- |
| `main.tf`          | Main resource definitions                       |
| `provider.tf`      | AWS provider and region/profile configuration   |
| `variables.tf`     | Input variables for flexibility                 |
| `terraform.tfvars` | Example variable values (do not commit secrets) |
| `outputs.tf`       | Outputs for easy access to key info             |

---

## **Security Notes**

- **Never commit private keys or secrets.**
- Restrict SSH access as tightly as possible.
- Use AWS IAM roles and least privilege for the Terraform user.
- Review security group rules regularly.

---

## **Extending and Reusing**

- Change `terraform.tfvars` for new environments.
- Add more subnets, EC2 instances, or app containers as needed.
- Modularize by splitting resources into separate modules for VPC, EC2, DNS, etc.

---

## **Example Output**

After `terraform apply`, outputs include:

- **AMI ID** used
- **EC2 Public IP**
- **Elastic IP**
- **Domain name** used

---

## **How to Add to GitHub**

1. **Create a `.gitignore`** to exclude:
   - `terraform.tfstate`, `terraform.tfstate.backup`, `.terraform/`, any secrets or sensitive files.
2. **Push your code:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: AWS static React app infra"
   git remote add origin
   git push -u origin main
   ```
3. **Add this documentation as `README.md`.**

---

## **References**

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Best Practices for Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)

---

This setup is secure, reusable, and production-ready for deploying static web apps on AWS using Terraform.
