#output "eip" {
#  value = module.bp-general-ec2.instance_id
#}

output "acm_arn" {
  value = module.bp-common-acm.acm_arn
}