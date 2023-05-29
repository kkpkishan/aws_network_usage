#!/bin/bash

region="$1"
start_time="$2"
end_time="$3"

# Step 1: Find all NLBs in the specified region
nlb_list=$(aws elbv2 describe-load-balancers --region "$region" --query "LoadBalancers[?Type=='network'].LoadBalancerArn" --output text)

echo "Network Load Balancers:"
echo "------------------------"

# Step 2: Find CloudWatch metrics for each NLB
for nlb_arn in $nlb_list; do
  #echo "NLB ARN: $nlb_arn"

  # Extract NLB name from ARN
  nlb_name=$(echo "$nlb_arn" | sed 's#arn:aws:elasticloadbalancing:[^:]\+:[^:]\+:[^/]\+/##')
  echo $nlb_name

  # Total processed bytes in GB
  processed_bytes=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/NetworkELB \
    --metric-name BytesProcessed \
    --dimensions Name=LoadBalancer,Value="$nlb_arn" \
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

  # Total number of new flows per second
  new_flows=$(aws cloudwatch get-metric-statistics \
    --region "$region" \
    --namespace AWS/NetworkELB \
    --metric-name NewFlowCount \
    --dimensions Name=LoadBalancer,Value="$nlb_name" \
    --start-time "$start_time" \
    --end-time "$end_time" \
    --period 86400 \
    --statistics SampleCount \
    --query "Datapoints[0].SampleCount")

  if [ "$new_flows" == "null" ]; then
    new_flows=0
  fi

  echo "Total number of new flows per second: $new_flows"

  echo ""
done
