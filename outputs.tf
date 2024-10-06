output "cloudfront_url_endpoint" {
  value = "https://${aws_cloudfront_distribution.distribution.domain_name}"
}

output "base_url" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}
