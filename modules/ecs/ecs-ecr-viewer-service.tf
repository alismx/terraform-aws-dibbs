################################################################################
#### ECR-VIEWER SERVICE
################################################################################

resource "aws_ecs_task_definition" "ecr_viewer" {
  family                   = "ecr-viewer-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.ecr_viewer_app.rendered
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "ecrviewer" {
  name            = "ecr-viewer"
  cluster         = aws_ecs_cluster.dibbs_app_cluster.id
  task_definition = aws_ecs_task_definition.ecr_viewer.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  scheduling_strategy = "REPLICA"

  # 50 percent must be healthy during deploys
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups  = ["${aws_security_group.service_security_group.id}"]
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ecr_viewer_service.arn
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment, aws_iam_role_policy_attachment.ecs_task_execution_role_policy_secondary_attachment, aws_cloudwatch_log_group.ecs_cloudwatch_logs]

}
