terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Networking Module Section

module "Networking" {
  source       = "./Networking"
  public_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Instances Module Section

module "Instances" {
  source             = "./Instances"
  public_instance_sg = module.Networking.public_instance_sg
  public_subnets     = module.Networking.public_subnet
  instance_ip = module.Instances.instance_ip
  public_cidrs       = ["10.0.1.0/24", "10.0.2.0.24", "10.0.3.0/24"]
  key_name           = "terraform"
}

# Loadbalancer Module Section

module "Loadbalancer" {
  source        = "./Load-Balancers"
  public_subnet = module.Networking.public_subnet
  vpc_id        = module.Networking.vpc_id
  webserver_sg  = module.Networking.webserver_sg
  public_server = module.Instances.public_server
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0.24", "10.0.3.0/24"]
}