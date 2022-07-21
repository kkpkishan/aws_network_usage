######### RDS ################
-- 
./rds_network_usage.sh ap-south-1 NetworkTransmitThroughput 2022-07-01T00:00:00.000Z 2022-07-31T23:59:59.000Z
./rds_network_usage.sh ap-south-1 NetworkReceiveThroughput  2022-07-01T00:00:00.000Z 2022-07-31T23:59:59.000Z

########## EC2 ################
--
./ec2_network_usage.sh ap-south-1 NetworkOut 2022-03-01T00:00:00.000Z 2022-03-31T23:59:59.000Z
./ec2_network_usage.sh ap-south-1 NetworkIn 2022-03-01T00:00:00.000Z 2022-03-31T23:59:59.000Z
