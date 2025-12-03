output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "cluster_endpoint" {
  description = "Endpoint for the AKS cluster API server"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
}

output "kube_config" {
  description = "Kubernetes configuration for connecting to the cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.aks_rg.name
}

output "location" {
  description = "Location of the AKS cluster"
  value       = azurerm_resource_group.aks_rg.location
}

output "node_resource_group" {
  description = "Name of the auto-generated resource group for AKS nodes"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "principal_id" {
  description = "Principal ID of the system-assigned managed identity"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
