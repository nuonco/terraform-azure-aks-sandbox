module "aks" {
  source  = "Azure/aks/azurerm//v4"
  version = "~> 10.1.0"

  location                  = var.location
  prefix                    = var.nuon_id
  resource_group_name       = data.azurerm_resource_group.rg.name
  kubernetes_version        = var.cluster_version
  automatic_channel_upgrade = "patch"
  # agents_availability_zones = length(local.azs) > 0 ? local.azs : null
  agents_count     = null
  agents_max_count = 2
  agents_max_pods  = 100
  agents_min_count = 1
  agents_pool_name = "agents"
  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [
        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]
  agents_type            = "VirtualMachineScaleSets"
  azure_policy_enabled   = true
  enable_auto_scaling    = true
  enable_host_encryption = false

  # green_field_application_gateway_for_ingress = {
  #   name        = "ingress"
  #   subnet_cidr = local.appgw_cidr
  # }
  # create_role_assignments_for_application_gateway = true
  local_account_disabled          = false
  log_analytics_workspace_enabled = false
  net_profile_dns_service_ip      = local.dns_service_ip
  net_profile_service_cidr        = local.service_cidr
  network_plugin                  = "azure"
  network_policy                  = "azure"
  os_disk_size_gb                 = 60
  private_cluster_enabled         = false
  # rbac_aad                                        = true
  # rbac_aad_managed                                = true
  # role_based_access_control_enabled = true
  sku_tier    = "Standard"
  vnet_subnet = { id = data.azurerm_subnet.existing.id }
  # attached_acr_id_map = {
  #   "${azurerm_container_registry.acr.name}" = azurerm_container_registry.acr.id
  # }

  node_pools = {
    "default" = {
      name                        = "default"
      vm_size                     = var.vm_size
      node_count                  = var.node_count
      vnet_subnet_id              = data.azurerm_subnet.existing.id
      create_before_destroy       = true
      temporary_name_for_rotation = "${substr(var.nuon_id, 1, 7)}temp"
    }
  }
}
