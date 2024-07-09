terraform {
  backend "s3" {
    bucket         = "maumv-terraform-state-bucket"
    key            = "key"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}

module "aws_infrastructure" {
  source             = "./aws-module"
  s3_bucket_name     = "mau-mv-module-bucket"
  ec2_instance_type  = "t2.micro"
  rds_instance_type  = "db.t3.micro"
  region             = "us-east-1"
  primary_subnet_id  = aws_subnet.main.id
  secondary_subnet_id= aws_subnet.secondary.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Environment = "dev"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Environment = "dev"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Environment = "dev"
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = module.aws_infrastructure.s3_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:*"
        Effect = "Allow"
        Resource = "arn:aws:s3:::${module.aws_infrastructure.s3_bucket_name}/*"
        Principal = "*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = module.aws_infrastructure.ec2_instance_public_ip
          }
        }
      }
    ]
  })
}
 
# AZURE INFRA ------------------------------------------------------------------

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "azure_infrastructure" {
  source               = "./azure-module"
  resource_group_name  = "assignment-rg"
  location             = "West US"
  vm_size              = "Standard_B1s"
  storage_account_sku  = "LRS"
}

# Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = module.azure_infrastructure.location
  resource_group_name = module.azure_infrastructure.resource_group_name

  security_rule {
    name                       = "AllowSQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "${module.azure_infrastructure.vm_public_ip}/32"
    destination_address_prefix = "*"
    destination_port_range     = "1433"
    source_port_range          = "*"
  }

  tags = {
    Environment = "dev"
  }
}

# Associate NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = module.azure_infrastructure.subnet_id
  network_security_group_id = azurerm_network_security_group.example.id
}
