output "domains" {
  value = module.bp-hrms-es.*.es_url
}