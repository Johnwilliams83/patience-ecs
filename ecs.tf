#creating ecs_cluster for project
resource "aws_ecs_cluster" "my-pro-ecs" {
  name = "my-pro-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


#creating ecs_service for a project
resource "aws_ecs_service" "my-ecs-service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.my-pro-ecs.id
  task_definition = aws_ecs_task_definition.my-ecs_task_def.arn
  desired_count   = 1
  iam_role        = aws_iam_role.my-iam_role.arn

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}

# Network_load_balancer for ecs projects

resource "aws_lb" "ecs_nlb" {
  name                       = "test-lb-tf"
  internal                   = false
  load_balancer_type         = "network"
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


#Aws_lb_listerner

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_nlb.id

  default_action {
    target_group_arn = aws_lb_target_group.my-lb-tg.id
    type             = "forward"
  }
}
