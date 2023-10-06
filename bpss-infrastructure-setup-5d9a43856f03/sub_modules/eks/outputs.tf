output "cluster_name" {
  value = module.eks.cluster_name
}

output "kube_api_server" {
  value = module.eks.kube_api_server
}

output "cluster_openid_url" {
  value = module.eks.cluster_openid_url
}

output "cluster_openid_arn" {
  value = module.eks_openid.oidc_arn
}