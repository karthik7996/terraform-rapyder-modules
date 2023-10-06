output "vpc_id" {
  value = data.terraform_remote_state.common.outputs.vpc_id
}

#output "instance_id" {
#  value = module.bp-ezedox-ec2.hireapp.instance_id
#}