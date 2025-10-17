##
# ECS Cluster for running app on Fargate
##
resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${local.prefix}-task-exec-role-policy"
  path        = "/"
  description = "Allow ECS to retrieve images and add to logs."
  policy      = file("./templates/ecs/task-execution-role-policy.json")
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.prefix}-task-execution-role"
  assume_role_policy = file("./templates/ecs/task-assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

resource "aws_iam_role" "app_task" {
  name               = "${local.prefix}-app-task"
  assume_role_policy = file("./templates/ecs/task-assume-role-policy.json")
}

resource "aws_iam_policy" "task_ssm_policy" {
  name        = "${local.prefix}-task-ssm-role-policy"
  path        = "/"
  description = "Policy to allow System Manager access from ECS tasks"
  policy      = file("./templates/ecs/task-ssm-policy.json")
}

resource "aws_iam_role_policy_attachment" "task_ssm_policy" {
  role       = aws_iam_role.app_task.name
  policy_arn = aws_iam_policy.task_ssm_policy.arn
}

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${local.prefix}-api"
}

# This creates the ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"
}


resource "aws_ecs_task_defination" "api" {
  # Task definition details would go here
  family = "${local.prefix}-api"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu    = 256
  memory = 512
  execution_role_arn = aws_iam_role.task_execution_role.arn
  task_role_arn      = aws_iam_role.app_task.arn

  container_definations = jsonencode([])

  volume {
    name = "static"
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}