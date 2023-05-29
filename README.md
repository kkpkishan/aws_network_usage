# AWS Network Usage Calculator

This repository contains shell scripts to calculate network usage for different AWS services, such as RDS, EC2, ALB, and NLB. The scripts can be used to fetch network metrics data from AWS CloudWatch and calculate the network usage within a specified time range.

## Prerequisites

Before running the scripts, make sure you have the following prerequisites:

- AWS CLI: Install and configure the AWS CLI on your local machine. For more information, refer to the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

## Usage

Follow the examples below to run the respective shell scripts:

### RDS

To calculate network usage for RDS instances:

```shell
./rds_network_usage.sh <region> <metric> <start-time> <end-time>
```

Example:

```shell
./rds_network_usage.sh ap-south-1 NetworkTransmitThroughput 2022-07-01T00:00:00.000Z 2022-07-31T23:59:59.000Z
./rds_network_usage.sh ap-south-1 NetworkReceiveThroughput 2022-07-01T00:00:00.000Z 2022-07-31T23:59:59.000Z
```

Replace `<region>` with the AWS region where your RDS instances are located. Choose the appropriate `<metric>` (e.g., NetworkTransmitThroughput, NetworkReceiveThroughput) and specify the `<start-time>` and `<end-time>` for the time range you want to calculate network usage.

### EC2

To calculate network usage for EC2 instances:

```shell
./network_usage.sh <region> <metric> <start-time> <end-time>
```

Example:

```shell
./network_usage.sh ap-south-1 NetworkOut 2022-03-01T00:00:00.000Z 2022-03-31T23:59:59.000Z
./network_usage.sh ap-south-1 NetworkIn 2022-03-01T00:00:00.000Z 2022-03-31T23:59:59.000Z
```

Replace `<region>` with the AWS region where your EC2 instances are located. Choose the appropriate `<metric>` (e.g., NetworkOut, NetworkIn) and specify the `<start-time>` and `<end-time>` for the time range you want to calculate network usage.

### ALB, NLB

To calculate network usage for ALB (Application Load Balancer) and NLB (Network Load Balancer):

```shell
./alb_network_usage.sh <region> <start-time> <end-time>
./nlb_network_usage.sh <region> <start-time> <end-time>
```

Example:

```shell
./alb_network_usage.sh ap-south-1 2023-05-01T00:00:00.000Z 2023-05-31T23:59:59.000Z
./nlb_network_usage.sh ap-south-1 2023-05-01T00:00:00.000Z 2023-05-31T23:59:59.000Z
```

Replace `<region>` with the AWS region where your ALB/NLB instances are located. Specify the `<start-time>` and `<end-time>` for the time range you want to calculate network usage.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and use it according to your needs.

## Disclaimer

The scripts provided in this repository are intended for informational purposes only
