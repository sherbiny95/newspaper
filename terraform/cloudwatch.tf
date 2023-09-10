resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "lambda-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              "news"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "Lambda Invocations"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApiGateway",
              "Count",
              "ApiName",
              "newspaper",
              "Stage",
              "${var.stage_name}",
              "Resource",
              "/news"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "GET Requests to /news"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApiGateway",
              "Count",
              "ApiName",
              "newspaper",
              "Stage",
              "${var.stage_name}",
              "Resource",
              "/newsitem"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "POST Requests to /newsitem"
        }
      }
    ]
  })
}