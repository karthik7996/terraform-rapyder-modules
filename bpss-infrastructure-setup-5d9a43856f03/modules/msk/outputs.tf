output "msk_arn" {
  value = aws_msk_cluster.msk.arn
}

output "bootstrap_brokers" {
  value = aws_msk_cluster.msk.bootstrap_brokers
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.msk.zookeeper_connect_string
}