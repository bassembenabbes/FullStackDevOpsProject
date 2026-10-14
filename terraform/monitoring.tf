# ---------- Monitoring stack : Prometheus + Grafana sur ECS Fargate ----------
resource "aws_security_group" "monitoring" {
  name        = "${var.project}-monitoring"
  description = "Prometheus + Grafana accessibles depuis l'exterieur"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/${var.project}-prometheus"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/${var.project}-grafana"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "prometheus" {
  family                   = "${var.project}-prometheus"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.execution.arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "prom/prometheus:v2.54.1"
      essential = true
      portMappings = [{
        name          = "http"
        containerPort = 9090
        hostPort      = 9090
        protocol      = "tcp"
      }]
      entryPoint = ["sh", "-c"]
      command = [<<-EOT
        cat <<'CFG' > /etc/prometheus/prometheus.yml
        global:
          scrape_interval: 15s
          evaluation_interval: 15s

        scrape_configs:
          - job_name: 'spring-boot-backend'
            metrics_path: /actuator/prometheus
            static_configs:
              - targets: ['backend:8080']
                labels:
                  application: 'personnes'
        CFG

        /bin/prometheus \
          --config.file=/etc/prometheus/prometheus.yml \
          --storage.tsdb.path=/prometheus \
          --web.enable-lifecycle
      EOT
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.prometheus.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "prometheus"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "grafana" {
  family                   = "${var.project}-grafana"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.execution.arn

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = "grafana/grafana:11.2.0"
      essential = true
      portMappings = [{
        name          = "http"
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }]
      environment = [
        { name = "GF_SECURITY_ADMIN_USER", value = "admin" },
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "admin" },
        { name = "GF_USERS_ALLOW_SIGN_UP", value = "false" }
      ]
      entryPoint = ["sh", "-c"]
      command = [<<-EOT
        mkdir -p /etc/grafana/provisioning/datasources /etc/grafana/provisioning/dashboards

        cat <<'DATASOURCE' > /etc/grafana/provisioning/datasources/datasource.yml
        apiVersion: 1

        datasources:
          - name: Prometheus
            type: prometheus
            access: proxy
            url: http://prometheus:9090
            isDefault: true
            editable: false
        DATASOURCE

        cat <<'DASHBOARD_CFG' > /etc/grafana/provisioning/dashboards/dashboard.yml
        apiVersion: 1

        providers:
          - name: 'Personnes dashboards'
            orgId: 1
            folder: ''
            type: file
            disableDeletion: false
            editable: true
            options:
              path: /etc/grafana/provisioning/dashboards
        DASHBOARD_CFG

        cat <<'JSON' > /etc/grafana/provisioning/dashboards/backend-overview.json
        {
          "annotations": { "list": [] },
          "editable": true,
          "fiscalYearStartMonth": 0,
          "graphTooltip": 0,
          "id": null,
          "links": [],
          "panels": [
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "Utilisation CPU du backend",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "thresholds" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null }, { "color": "yellow", "value": 50 }, { "color": "red", "value": 80 } ] },
                  "unit": "percentunit"
                },
                "overrides": []
              },
              "gridPos": { "h": 7, "w": 6, "x": 0, "y": 0 },
              "id": 1,
              "options": {
                "colorMode": "background",
                "graphMode": "area",
                "justifyMode": "center",
                "orientation": "auto",
                "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
                "showPercentChange": false,
                "textMode": "value_and_name"
              },
              "targets": [
                { "expr": "100 * process_cpu_usage{application=\"personnes\"}", "legendFormat": "CPU", "refId": "A" }
              ],
              "title": "CPU usage",
              "type": "stat"
            },
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "Mémoire heap utilisée par le backend",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "thresholds" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null }, { "color": "yellow", "value": 250 }, { "color": "red", "value": 500 } ] },
                  "unit": "decmbytes"
                },
                "overrides": []
              },
              "gridPos": { "h": 7, "w": 6, "x": 6, "y": 0 },
              "id": 2,
              "options": {
                "colorMode": "background",
                "graphMode": "area",
                "justifyMode": "center",
                "orientation": "auto",
                "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
                "showPercentChange": false,
                "textMode": "value_and_name"
              },
              "targets": [
                { "expr": "sum(jvm_memory_used_bytes{application=\"personnes\",area=\"heap\"}) / 1024 / 1024", "legendFormat": "RAM", "refId": "A" }
              ],
              "title": "Memory usage",
              "type": "stat"
            },
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "Requêtes HTTP entrantes par seconde",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "palette-classic" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null } ] },
                  "unit": "reqps"
                },
                "overrides": []
              },
              "gridPos": { "h": 7, "w": 6, "x": 12, "y": 0 },
              "id": 3,
              "options": {
                "colorMode": "background",
                "graphMode": "area",
                "justifyMode": "center",
                "orientation": "auto",
                "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
                "showPercentChange": false,
                "textMode": "value_and_name"
              },
              "targets": [
                { "expr": "sum(rate(http_server_requests_seconds_count{application=\"personnes\"}[1m]))", "legendFormat": "req/s", "refId": "A" }
              ],
              "title": "Request rate",
              "type": "stat"
            },
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "Latence moyenne du backend",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "thresholds" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null }, { "color": "yellow", "value": 0.5 }, { "color": "red", "value": 1 } ] },
                  "unit": "s"
                },
                "overrides": []
              },
              "gridPos": { "h": 7, "w": 6, "x": 18, "y": 0 },
              "id": 4,
              "options": {
                "colorMode": "background",
                "graphMode": "area",
                "justifyMode": "center",
                "orientation": "auto",
                "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
                "showPercentChange": false,
                "textMode": "value_and_name"
              },
              "targets": [
                { "expr": "sum(rate(http_server_requests_seconds_sum{application=\"personnes\"}[5m])) / sum(rate(http_server_requests_seconds_count{application=\"personnes\"}[5m]))", "legendFormat": "avg latency", "refId": "A" }
              ],
              "title": "Avg latency",
              "type": "stat"
            },
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "Temps de fonctionnement du backend",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "palette-classic" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "green", "value": null } ] },
                  "unit": "h"
                },
                "overrides": []
              },
              "gridPos": { "h": 8, "w": 12, "x": 0, "y": 7 },
              "id": 5,
              "options": {
                "legend": { "displayMode": "list", "placement": "bottom" },
                "tooltip": { "mode": "single", "sort": "none" }
              },
              "targets": [
                { "expr": "process_uptime_seconds{application=\"personnes\"} / 3600", "legendFormat": "uptime (h)", "refId": "A" }
              ],
              "title": "Service uptime",
              "type": "timeseries"
            },
            {
              "datasource": { "type": "prometheus", "uid": "PBFA97CFB590B2093" },
              "description": "État du backend et vérifications de santé",
              "fieldConfig": {
                "defaults": {
                  "color": { "mode": "thresholds" },
                  "mappings": [],
                  "thresholds": { "mode": "absolute", "steps": [ { "color": "red", "value": 0 }, { "color": "green", "value": 1 } ] },
                  "unit": "short"
                },
                "overrides": []
              },
              "gridPos": { "h": 8, "w": 12, "x": 12, "y": 7 },
              "id": 6,
              "options": {
                "legend": { "displayMode": "list", "placement": "bottom" },
                "tooltip": { "mode": "single", "sort": "none" }
              },
              "targets": [
                { "expr": "up{job=\"spring-boot-backend\"}", "legendFormat": "backend up", "refId": "A" },
                { "expr": "sum(rate(http_server_requests_seconds_count{application=\"personnes\",uri=\"/actuator/health/**\",status=~\"2..\"}[5m]))", "legendFormat": "health checks / min", "refId": "B" }
              ],
              "title": "Health status",
              "type": "timeseries"
            }
          ],
          "refresh": "10s",
          "schemaVersion": 39,
          "style": "dark",
          "tags": ["spring-boot", "aws", "personnes"],
          "templating": { "list": [] },
          "time": { "from": "now-15m", "to": "now" },
          "timepicker": {},
          "timezone": "browser",
          "title": "Personnes backend overview",
          "uid": "personnes-backend-overview",
          "version": 1,
          "weekStart": ""
        }
        JSON

        /run.sh
      EOT
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.grafana.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "grafana"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.monitoring.id]
    assign_public_ip = true
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.main.arn
    service {
      port_name      = "http"
      discovery_name = "prometheus"
      client_alias {
        port     = 9090
        dns_name = "prometheus"
      }
    }
  }

  depends_on = [aws_ecs_service.backend]
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.monitoring.id]
    assign_public_ip = true
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.main.arn
    service {
      port_name      = "http"
      discovery_name = "grafana"
      client_alias {
        port     = 3000
        dns_name = "grafana"
      }
    }
  }

  depends_on = [aws_ecs_service.prometheus]
}
