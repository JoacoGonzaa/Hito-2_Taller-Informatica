resource "aws_ecs_cluster" "cafe_cluster" {
  name = "cafe-del-sur-cluster"
  tags = {
    Proyecto = "Cafe-del-Sur"
    Entorno  = "MVP"
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRoleTerraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "cafe_task" {
  family                   = "cafe-del-sur-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "cafe-del-sur"
      image     = "${aws_ecr_repository.cafe_del_sur.repository_url}:2.0"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "cafe_service" {
  name            = "cafe-del-sur-service"
  cluster         = aws_ecs_cluster.cafe_cluster.id
  task_definition = aws_ecs_task_definition.cafe_task.arn
  desired_count   = 2 # Alta disponibilidad: corre 2 copias de tu backend
  launch_type     = "FARGATE"

  # AQUÍ CONECTAMOS LA RED QUE ESTABA SUELTA:
  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    security_groups = [
      aws_security_group.web_sg.id
    ]
    assign_public_ip = true
  }

  # AQUÍ CONECTAMOS EL ECS CON EL ALB:
  load_balancer {
    target_group_arn = aws_lb_target_group.cafe_tg.arn
    container_name   = "cafe-del-sur" # Debe coincidir con el 'name' dentro de tu task_definition
    container_port   = 80
  }

  # Le dice a ECS que espere a que el Listener esté creado antes de intentar unirse
  depends_on = [
    aws_lb_listener.http
  ]
  
  tags = {
    Proyecto = "Cafe-del-Sur"
    Entorno  = "MVP"
  }
}