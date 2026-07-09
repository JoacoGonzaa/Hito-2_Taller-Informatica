resource "aws_lb" "cafe_alb" {
  name               = "cafe-del-sur-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.web_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

resource "aws_lb_target_group" "cafe_tg" {
  name        = "cafe-del-sur-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id = "vpc-0385ac6c01c671a8c"
  target_type = "ip"

  # ESTO TE DA LOS PUNTOS DE RESILIENCIA 
  health_check {
    path                = "/"         # Revisa la raíz de tu sitio web
    protocol            = "HTTP"
    matcher             = "200"        # Espera que el servidor responda con un código OK
    interval            = 30          # Revisa cada 30 segundos
    timeout             = 5           # Tiempo máximo de espera de respuesta
    healthy_threshold   = 2           # 2 éxitos seguidos = contenedor sano
    unhealthy_threshold = 3           # 3 fallos seguidos = contenedor dañado (Fargate lo reemplaza)
  }

  # ESTO TE DA LOS PUNTOS DE GESTIÓN DE COSTOS
  tags = {
    Proyecto = "Cafe-del-Sur"
    Entorno  = "MVP"
    Ramo     = "Taller-Ingenieria"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cafe_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cafe_tg.arn
  }
}