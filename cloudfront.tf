locals {
  api_gateway_domain_name = "${aws_api_gateway_rest_api.api_gateway.id}.execute-api.${var.aws_region}.amazonaws.com"
}

data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "request_policy" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_distribution" "distribution" {
  comment             = null
  default_root_object = null
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  tags                = local.common_tags
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id = data.aws_cloudfront_cache_policy.cache_policy.id
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    default_ttl = 0
    max_ttl     = 0
    min_ttl     = 0

    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.request_policy.id
    # realtime_log_config_arn    = null
    # response_headers_policy_id = null
    # smooth_streaming           = false
    target_origin_id = local.api_gateway_domain_name
    # trusted_key_groups         = []
    # trusted_signers            = []
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    # connection_attempts      = 3
    # connection_timeout       = 10
    domain_name = local.api_gateway_domain_name
    # origin_access_control_id = null
    origin_id   = local.api_gateway_domain_name
    origin_path = "/${aws_api_gateway_deployment.api_gateway_deployment.stage_name}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
