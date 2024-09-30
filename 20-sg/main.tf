module "mysql_sg" {
    source = "../../terraform-aws-security-group" 
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    vpc_id = local.vpc_id 
    common_tags = var.common_tags
    sg_tags = var.mysql_sg_tags 

} 

module "backend_sg" {
    source = "../../terraform-aws-security-group" 
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    vpc_id = local.vpc_id 
    common_tags = var.common_tags
    sg_tags = var.backend_sg_tags 
} 

module "frontend_sg" {
    source = "../../terraform-aws-security-group" 
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"  
    vpc_id = local.vpc_id 
    common_tags = var.common_tags
    sg_tags = var.frontend_sg_tags  
} 

module "bastion_sg" {
    source = "../../terraform-aws-security-group" 
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"  
    vpc_id = local.vpc_id 
    common_tags = var.common_tags
    sg_tags = var.bastion_sg_tags   
} 

module "ansible_sg" {
    source = "../../terraform-aws-security-group" 
    project_name = var.project_name
    environment = var.environment
    sg_name = "ansible"  
    vpc_id = local.vpc_id 
    common_tags = var.common_tags
    sg_tags = var.ansible_sg_tags   
} 

#mysql allowing connection on 3306 from the instances attached to backend sg 
resource "aws_security_group_rule" "mysql-backend" { 
  type              = "ingress"
  from_port         = 3306 #this is the port of mysql
  to_port           = 3306 
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.id
  security_group_id = module.mysql_sg.id 
}

resource "aws_security_group_rule" "backend-frontend" { 
  type              = "ingress"
  from_port         = 8080 #this is the port of mysql
  to_port           = 8080 
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id = module.backend_sg.id 
}

resource "aws_security_group_rule" "frontend_public" { 
  type              = "ingress"
  from_port         = 80 #this is the port of mysql
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = module.frontend_sg.id  
}

resource "aws_security_group_rule" "mysql_bastion" {   #mysql accepting connections from bastion
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.mysql_sg.id 
} 

resource "aws_security_group_rule" "backend-bastion" { 
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.backend_sg.id 
}

resource "aws_security_group_rule" "frontend-bastion" { 
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.frontend_sg.id  
}

resource "aws_security_group_rule" "mysql-ansible" { 
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.mysql_sg.id  
}

resource "aws_security_group_rule" "backend-ansible" { 
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.backend_sg.id   
}

resource "aws_security_group_rule" "frontend-ansible" {  
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.frontend_sg.id  
}

resource "aws_security_group_rule" "ansible_public" {  
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id  
}

resource "aws_security_group_rule" "bastion_public" {  
  type              = "ingress"
  from_port         = 22 #this is the port of mysql
  to_port           = 22 
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id   
}


