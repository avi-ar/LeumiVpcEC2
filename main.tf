data "aws_region" "current" {}


resource "aws_instance" "test" {
  ami = "ami-0fed63ea358539e44"
    vpc_security_group_ids = [ "${aws_security_group.sg.id}" ]
    subnet_id = aws_subnet.Default.id
    security_groups = ["${aws_security_group.sg.id}"]
    instance_type = "t2.micro"
  tags = {
    Name = "test"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF
}


resource "aws_eip" "eip" {
  instance = aws_instance.test.id
}

resource "aws_lb" "nlb" {
  name               = "test-nlb"
  internal           = false
  load_balancer_type = "network"
  enable_deletion_protection = false
  security_groups    = [aws_security_group.sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_lb_target_group" "target_group" {
  name     = "test-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.test.id
  port             = 80
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
