# VPC Endpoint for ssm

resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-southeast-2.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ssm.id]
  subnet_ids         = [aws_subnet.subnet_3.id]

  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-southeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ssm.id]
  subnet_ids         = [aws_subnet.subnet_3.id]

  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ec2_messages_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-southeast-2.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ssm.id]
  subnet_ids         = [aws_subnet.subnet_3.id]

  private_dns_enabled = true

}