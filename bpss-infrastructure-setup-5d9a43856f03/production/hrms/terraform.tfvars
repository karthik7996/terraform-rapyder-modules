name           = "bp"
env            = "prod"
location       = "eu-central-1"
short_location = "de"
project        = "betterplace"
product        = "hrms"

eks_inbound_ports         = [80, 443]
image_id                  = "ami-040236e9010f11804"
enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler", "authenticator"]
instance_types            = ["t3a.medium"]
db_product                = ["ezedox-app", "ezedox-hire", "hrms-hire-app", "hrms-hire-process", "process-ezedox"]
ec_product = ["ezedox-redis-cache-prod","prod-hire-prod","prod-hrms-attend-redis","prod-hrms-dlq-redis","prod-hrms-payroll-redis","prod-hrms-redis","prod-hrms-redis-common-engine","prod-hrms-verify-onboard-redis"]
additional_node_group_policies = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess","arn:aws:iam::aws:policy/AWSWAFFullAccess"]


#redis
