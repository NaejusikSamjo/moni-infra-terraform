resource "aws_lb" "this" {
  name               = "my-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

# api-gateway 타겟그룹 (:8080)
resource "aws_lb_target_group" "api" {
  name     = "api-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# admin-service 타겟그룹 (:19097)
resource "aws_lb_target_group" "admin" {
  name     = "admin-target-group"
  port     = 19097
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP:80 → HTTPS:443 리다이렉트
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS:443 리스너 (기본: api-gateway로 forward)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

# swagger 경로 차단 (api.moni.my 한정)
resource "aws_lb_listener_rule" "block_swagger" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 5

  condition {
    host_header {
      values = ["api.moni.my"]
    }
  }

  condition {
    path_pattern {
      values = ["/swagger-ui*", "/webjars*", "/v3/api-docs*"]
    }
  }

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = "{\"status\":404,\"error\":\"Not Found\"}"
      status_code  = "404"
    }
  }
}

# 호스트 기반 룰: api.moni.my → api-gateway
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  condition {
    host_header {
      values = ["api.moni.my"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

# 호스트 기반 룰: admin.moni.my → admin-service
resource "aws_lb_listener_rule" "admin" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  condition {
    host_header {
      values = ["admin.moni.my"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin.arn
  }
}

# 서비스 EC2 → api-gateway 연결
resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = var.target_instance_id
  port             = 8080
}

# 서비스 EC2 → admin-service 연결
resource "aws_lb_target_group_attachment" "admin" {
  target_group_arn = aws_lb_target_group.admin.arn
  target_id        = var.target_instance_id
  port             = 19097
}

# grafana 타겟그룹 (:3000)
resource "aws_lb_target_group" "grafana" {
  name     = "grafana-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# 호스트 기반 룰: grafana.moni.my → grafana
resource "aws_lb_listener_rule" "grafana" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30

  condition {
    host_header {
      values = ["grafana.moni.my"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }
}

# 모니터링 EC2 → grafana 연결
resource "aws_lb_target_group_attachment" "grafana" {
  target_group_arn = aws_lb_target_group.grafana.arn
  target_id        = var.monitor_instance_id
  port             = 3000
}
