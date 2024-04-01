# locals {
#   ingress_rules = [
#     {
#       port        = 2484
#       description = "Inbound from my workspace"
#     },
#     {
#       port        = 1521
#       description = "Inbound from my workspaces"
#     }
#   ]
# }



# resource "aws_security_group" "joes-oracle-db-sg" {
#   name        = "${local.workspace["environment"]}-joes-oracle-db-sg"
#   description = "Allow inbound traffic"
#   vpc_id      = aws_vpc.vpc.id
#   dynamic "ingress" {
#     for_each = local.ingress_rules
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = "tcp"
#       cidr_blocks = [aws_vpc.vpc.cidr_block]
#     }
#   }

#   ingress {
#     description     = "Inbound from lambda"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     security_groups = [aws_security_group.lambda_sg.id]
#   }

#   ingress {
#     description = "self rule"
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     self        = true
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }


# resource "aws_security_group" "ec2_instance_sg" {
#   name   = "${local.workspace["environment"]}-test-windows-instance-sg"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     description = "Inbound from Vpc"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

#   ingress {
#     description = "Inbound from Vpc"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

#   ingress {
#     description = "Inbound from Vpc"
#     from_port   = 3389
#     to_port     = 3389
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   tags = {
#     Name = "test-windows-instance-sg"
#   }


# }

# resource "aws_security_group" "ssm" {
#   name        = "${local.workspace["environment"]}-ssm-security-group"
#   description = "Allow inbound traffic from ssm"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description = "Inbound from VPC"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [for _, user_info in var.workspace_ip : "${user_info.ip}/16"]
#   }

#   ingress {
#     description = "Inbound from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

#   ingress {
#     description = "Inbound from VPC"
#     from_port   = 3389
#     to_port     = 3389
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }
# }

# # dynamic "ingress" {
# #   for_each = var.workspace_ip
# #   content {
# #     description = "Inbound from VPC"
# #     from_port   = 80
# #     to_port     = 80
# #     protocol    = "tcp"
# #     cidr_blocks = ["${ingress.value.ip}/16"]
# #   }   
# # }



# #for lambda
resource "aws_security_group" "lambda_sg" {
  name        = "${local.workspace["environment"]}-lambda-sg"
  description = "Security Group attached to lambda"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${local.workspace["environment"]}-lambda-sg"
  }
}

resource "aws_security_group_rule" "lambda_sg_rule1" {
  description       = "Outbound to everywere"
  type              = "egress"
  security_group_id = aws_security_group.lambda_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lambda_sg_rule2" {
  description       = "Outbound to everywere"
  type              = "egress"
  security_group_id = aws_security_group.lambda_sg.id
  from_port         = 1521
  to_port           = 1521
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# # For EFS
# resource "aws_security_group" "efs_mount_target_sg" {
#   name        = "${local.workspace["environment"]}-efs-mount-target-sg"
#   description = "Security Group attached to EFS Mount Target"
#   vpc_id      = aws_vpc.vpc.id
#   tags = {
#     Name = "${local.workspace["environment"]}-efs-mount-target-sg"
#   }
# }

# resource "aws_security_group_rule" "efs_mount_target_sg_rule1" {
#   description              = "Inbound Traffic from EC2"
#   type                     = "ingress"
#   security_group_id        = aws_security_group.efs_mount_target_sg.id
#   from_port                = 2049
#   to_port                  = 2049
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.ec2_instance_sg.id
# }

# resource "aws_security_group_rule" "efs_mount_target_sg_rule2" {
#   description              = "Inbound Traffic from RDS"
#   type                     = "ingress"
#   security_group_id        = aws_security_group.efs_mount_target_sg.id
#   from_port                = 2049
#   to_port                  = 2049
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.joes-oracle-db-sg.id
# }

# resource "aws_security_group_rule" "efs_mount_target_sg_rule4" {
#   description              = "Inbound Traffic from Datasync"
#   type                     = "ingress"
#   security_group_id        = aws_security_group.efs_mount_target_sg.id
#   from_port                = 2049
#   to_port                  = 2049
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.datasync_service_sg.id
# }

# resource "aws_security_group_rule" "efs_mount_target_sg_rule3" {
#   description       = "Outbound to everywere"
#   type              = "egress"
#   security_group_id = aws_security_group.efs_mount_target_sg.id
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }


# #Datasync SG

# resource "aws_security_group" "datasync_service_sg" {
#   name        = "${local.workspace["environment"]}-datasync-service-sg"
#   description = "Security Group attached to Datasync"
#   vpc_id      = aws_vpc.vpc.id
#   tags = {
#     Name = "${local.workspace["environment"]}-datasync-service-sg"
#   }
# }

# resource "aws_security_group_rule" "datasync_service_sg_rule1" {
#   description       = "Inbound Https Traffic from VPC"
#   type              = "ingress"
#   security_group_id = aws_security_group.datasync_service_sg.id
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.vpc.cidr_block]
# }

# resource "aws_security_group_rule" "datasync_service_sg_rule2" {
#   description       = "Inbound Http Traffic from VPC"
#   type              = "ingress"
#   security_group_id = aws_security_group.datasync_service_sg.id
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.vpc.cidr_block]
# }

# resource "aws_security_group_rule" "datasync_service_sg_rule3" {
#   description       = "Inbound NFS Traffic from VPC"
#   type              = "ingress"
#   security_group_id = aws_security_group.datasync_service_sg.id
#   from_port         = 2049
#   to_port           = 2049
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.vpc.cidr_block]
# }

# resource "aws_security_group_rule" "datasync_service_sg_rule4" {
#   description       = "Inbound NFS Traffic from VPC"
#   type              = "ingress"
#   security_group_id = aws_security_group.datasync_service_sg.id
#   from_port         = 1024
#   to_port           = 1064
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.vpc.cidr_block]
# }

# resource "aws_security_group_rule" "datasync_service_sg_rule5" {
#   description              = "Outbound to everywere"
#   type                     = "egress"
#   security_group_id        = aws_security_group.datasync_service_sg.id
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = aws_security_group.efs_mount_target_sg.id
# }

