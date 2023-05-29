#!/bin/bash

region="$1"
start_time="$2"
end_time="$3"

# Step 1: Find all ALBs in the specified region
alb_list=$(aws elbv2 describe-load-balancers --region "$region" --query "LoadBalancers[?Type=='application'].LoadBalancerArn" --output text)

echo "Application Load Balancers:"
echo "-----------------------------"

# Step 2: Find CloudWatch metrics for each ALB
for alb_arn in $alb_list; do
  echo "ALB ARN: $alb_arn"

  # Extract ALB name from ARN
  alb_name=$(echo "$alb_arn" | sed 's#arn:aws:elasticloadbalancing:[^:]\+:[^:]\+:[^/]\+/##')

  # Total number of requests
  total_requests=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/ApplicationELB \
    --metric-name RequestCount \
    --dimensions Name=LoadBalancer,Value="$alb_name" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 86400 \
    --statistics Sum \
    --query "Datapoints[0].Sum")

  if [ "$total_requests" == "null" ]; then
    total_requests=0
  fi

  echo "Total number of requests: $total_requests"

  # Total number of new requests per second
  new_requests=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/ApplicationELB \
    --metric-name NewConnectionCount \
    --dimensions Name=LoadBalancer,Value="$alb_name" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 86400 \
    --statistics SampleCount \
    --query "Datapoints[0].SampleCount")

  if [ "$new_requests" == "null" ]; then
    new_requests=0
  fi

  echo "Total number of new requests: $new_requests"

  # Total processed bytes in GB
  processed_bytes=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/ApplicationELB \
    --metric-name ProcessedBytes \
    --dimensions Name=LoadBalancer,Value="$alb_name" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 86400 \
    --statistics Sum \
    --query "Datapoints[0].Sum")

  if [ "$processed_bytes" == "null" ]; then
    processed_bytes=0
  fi

  processed_bytes_gb=$(echo "scale=2; $processed_bytes / 1073741824" | bc)
  echo "Total processed bytes in GB: $processed_bytes_gb"

  # Total number of error requests
  error_requests=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/ApplicationELB \
    --metric-name HTTPCode_ELB_5XX_Count \
    --dimensions Name=LoadBalancer,Value="$alb_name" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 86400 \
    --statistics Sum \
    --query "Datapoints[0].Sum")

  if [ "$error_requests" == "null" ]; then
    error_requests=0
  fi

  echo "Total number of error requests: $error_requests"

  echo "-----------------------------"
done
