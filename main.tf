terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
  backend "azurerm" {

  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}

# Service Plan
resource "azurerm_service_plan" "app-plan" {
  name                = "plan-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# App Service
resource "azurerm_linux_web_app" "webapp" {
  name                = "web-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.app-plan.id

  site_config {
    application_stack {
      node_version = "16-lts"
    }
  }

  app_settings = {

    PORT                      = "3000"
    DB_HOST                   = "postgres-db"
    DB_USERNAME               = data.azurerm_key_vault_secret.db-username.value
    DB_PASSWORD               = data.azurerm_key_vault_secret.db-password.value
    DB_DATABASE               = "postgres-db"
    DB_DAILECT                = "postgres"
    DB_PORT                   = "5432"
    ACCESS_TOKEN_SECRET       = "accesstoken"
    REFRESH_TOKEN_SECRET      = "refreshtoken"
    ACCESS_TOKEN_EXPIRY       = "15m"
    REFRESH_TOKEN_EXPIRY      = "7d"
    REFRESH_TOKEN_COOKIE_NAME = "jid"
  }
}

# Database postgresql
resource "azurerm_postgresql_server" "srv-pgsql" {
  name                = "pgsql-${var.project_name}${var.environment_suffix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # a mettre en key vault
  administrator_login          = data.azurerm_key_vault_secret.db-username.value
  administrator_login_password = data.azurerm_key_vault_secret.db-password.value

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
}

# PGAdmin à ajouter
