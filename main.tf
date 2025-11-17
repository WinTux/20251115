terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
locals {
  nombre_workspace = terraform.workspace
  #ruta_private_key = "/home/rusok/Documentos/DevOps/ejemploTerraform/clasesdevops.pem"
  nombre_key = "clasesdevops"
  usuario_ssh = "ubuntu"
}

resource "aws_instance" "mi_app_spring" {
  count = local.nombre_workspace == "prod" ? 2 : 1
  ami           = "ami-0ec4ab14b1c5a10f2" #es Windows, no funciona: "ami-0023593d16b53b3e9"
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security-group.security_group_id]
  associate_public_ip_address = true
  key_name = local.nombre_key
  tags = {
    Name    = format("%s-%s",local.nombre_workspace,count.index)
  }
  provisioner "remote-exec" {
    inline = ["echo 'Esperando conexión SSH de ${self.public_ip}'"]
    connection {
      type = "ssh"
      user = local.usuario_ssh
      private_key = file(var.ruta_private_key)
      host = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${var.ruta_private_key} main.yml"
  }
}

#resource "aws_cloudwatch_log_group" "grupo_log_ec2" {
#  for_each = var.nombres_servicios
#  tags = {
#    Environment = "prueba"
#    Servicio = each.key
#  }
#  lifecycle {
#    create_before_destroy = true
#  }
#}
resource "aws_lb" "spring_alb" {
  name            = "spring-alb"
  load_balancer_type = "application"
  subnets         = module.vpc.public_subnets
  security_groups = [module.security-group.security_group_id]
}
resource "aws_lb_target_group" "blue" {
  name     = "spring-blue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path = "/actuator/health"
  }
}
resource "aws_lb_target_group" "green" {
  name     = "spring-green"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path = "/actuator/health"
  }
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.spring_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}
resource "aws_lb_target_group_attachment" "attach" {
  for_each = {
    for idx, instance in aws_instance.mi_app_spring :
    idx => instance.id
  }
  target_group_arn = var.active_color == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
  target_id = each.value
  port      = 8080
}
