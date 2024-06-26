resource "aws_instance" "test-windows-instance" {
  # (resource arguments)
  ami                         = "ami-023eb5c021738c6d0" #"ami-098203567ea2e50b7" #"ami-0af9bde3e71173fe2"
  associate_public_ip_address = false
  instance_type               = "t3.medium"
  key_name                    = "joe-db-key"
  vpc_security_group_ids      = [aws_security_group.ec2_instance_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = aws_subnet.subnet_3.id
  tags = {
    "Name" = "test-linux-instance"
  }
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  user_data = <<-EOF
      #!/bin/bash
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOF
}

resource "aws_instance" "test-instance" {
  # (resource arguments)
  ami                         = "ami-02ed1a17d1bd5f706" #"ami-0af9bde3e71173fe2"
  associate_public_ip_address = false
  instance_type               = "t3.medium"
  key_name                    = "joe-db-key"
  vpc_security_group_ids      = [aws_security_group.ec2_instance_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = aws_subnet.subnet_3.id
  tags = {
    "Name" = "test-windows-instance"
  }
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  user_data = <<-EOF
      #!/bin/bash
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo systemctl enable amazon-ssm-agent
      sudo systemctl start amazon-ssm-agent
      EOF
}
# C:\Users\Administrator\AppData\Local\DBeaver 

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2LinuxInstanceRole"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datasync_instance_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}