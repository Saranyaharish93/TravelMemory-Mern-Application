# TravelMemory MERN Deployment using Terraform and Ansible

## Project Overview

This project deploys the **TravelMemory MERN application** on AWS using:

- **Terraform** for infrastructure provisioning
- **Ansible** for server configuration and deployment
- **Nginx** for serving the React frontend and reverse proxying API requests
- **Node.js and Express** for the backend
- **MongoDB** on a private EC2 instance

## Architecture

text
Internet
   |
   v
Internet Gateway
   |
   v
Public Subnet: 10.0.1.0/24
   |
   v
Web EC2: 3.111.213.118
- Nginx
- React frontend
- Node.js / Express backend
   |
   | TCP 27017
   v
Private Subnet: 10.0.2.0/24
   |
   v
MongoDB EC2: 10.0.2.143
   |
   v
NAT Gateway for outbound package installation


## AWS Infrastructure

Terraform creates the following resources:

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24`
- Private subnet: `10.0.2.0/24`
- Internet Gateway
- NAT Gateway
- Elastic IP for the NAT Gateway
- Public and private route tables
- Web and database security groups
- IAM role and EC2 instance profile
- Public web EC2 instance
- Private MongoDB EC2 instance

## Security Configuration

- SSH access to the web server is restricted to the administrator IP.
- The database EC2 instance has no public IP.
- MongoDB port `27017` is allowed only from the web server security group.
- Root SSH login is disabled.
- UFW is enabled.
- MongoDB authentication is enabled.
- EBS root volumes are encrypted.
- EC2 metadata requires IMDSv2.
- Secrets, `.pem` files, Terraform state, and environment files are excluded from Git.

## Project Structure

text
TravelMemory-Mern-Application/
├── backend/
├── frontend/
├── infrastructure/
│   ├── terraform/
│   │   ├── versions.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── network.tf
│   │   ├── security.tf
│   │   ├── iam.tf
│   │   ├── ec2.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   └── ansible/
│       ├── ansible.cfg
│       ├── inventory.ini.example
│       ├── site.yml
│       ├── group_vars/
│       ├── roles/
│       │   ├── common/
│       │   ├── mongodb/
│       │   └── web/
│       └── templates/
├── screenshots/
├── report/
├── .gitignore
└── README.md


## Application Configuration

### Backend

The backend starts with:

bash
npm start


The backend uses:

env
PORT=3001
MONGO_URI=mongodb://<username>:<password>@10.0.2.143:27017/travelmemory?authSource=travelmemory


### Frontend

The frontend API base URL is configured as:

javascript
export const baseUrl =
  process.env.REACT_APP_BACKEND_URL || "/api";


Nginx forwards:

text
/api/trip


to:

text
http://127.0.0.1:3001/trip


## Prerequisites

Install the following tools:

- AWS CLI
- Terraform
- WSL Ubuntu
- Ansible
- Git
- SSH client

Configure AWS CLI:

bash
aws configure
aws sts get-caller-identity


## Terraform Deployment

Go to the Terraform directory:

bash
cd infrastructure/terraform


Initialize Terraform:

bash
terraform init


Validate:

bash
terraform validate


Create a plan:

bash
terraform plan -out=tfplan


Apply:

bash
terraform apply tfplan


View outputs:

bash
terraform output


## Ansible Deployment

Run Ansible from WSL Ubuntu.

Go to the Ansible control directory:

bash
cd ~/travelmemory-infrastructure/ansible


Test connectivity:

bash
ansible all -m ping


Validate the playbook:

bash
ansible-playbook site.yml --syntax-check


Configure MongoDB:

bash
ansible-playbook site.yml --limit database


Deploy the web application:

bash
ansible-playbook site.yml --limit web


Run the complete playbook:

bash
ansible-playbook site.yml


## Verification

Check services:

bash
ansible web -b -m shell -a "systemctl is-active travelmemory"
ansible web -b -m shell -a "systemctl is-active nginx"
ansible database -b -m shell -a "systemctl is-active mongod"


Test the backend directly:

bash
ansible web -m shell -a "curl -i http://127.0.0.1:3001/trip/"


Test through Nginx:

bash
curl -i http://3.111.213.118/api/trip/


Open the application:

text

http://3.111.213.118
## Author

Saranya
