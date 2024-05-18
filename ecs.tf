resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::533267391125:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "devmusawir/my-nodejs-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "test-group"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "ecs"

        }
      }
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [
      aws_subnet.my_subnet_a.id,
      aws_subnet.my_subnet_b.id,
      aws_subnet.my_subnet_c.id
    ]
    security_groups = [aws_security_group.my_security_group.id]
    assign_public_ip = true
  }
}
