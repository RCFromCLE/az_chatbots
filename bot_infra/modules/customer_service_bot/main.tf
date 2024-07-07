data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "bot_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "bot_sp" {
  name                = "${var.bot_name}-sp"
  location            = azurerm_resource_group.bot_rg.location
  resource_group_name = azurerm_resource_group.bot_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azuread_application" "bot_app" {
  display_name = "${var.bot_name}-app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "bot_password" {
  application_id = azuread_application.bot_app.id
  end_date_relative = "8760h"  # 1 year from now
}
resource "azurerm_bot_channels_registration" "bot" {
  name                = var.bot_name
  location            = "global"
  resource_group_name = azurerm_resource_group.bot_rg.name
  sku                 = "F0"
  microsoft_app_id    = azuread_application.bot_app.application_id

  endpoint = "https://${azurerm_app_service.bot_app.default_site_hostname}/api/messages"
}

resource "azurerm_app_service" "bot_app" {
  name                = "${var.bot_name}-app"
  location            = azurerm_resource_group.bot_rg.location
  resource_group_name = azurerm_resource_group.bot_rg.name
  app_service_plan_id = azurerm_app_service_plan.bot_sp.id

  site_config {
    linux_fx_version = "DOTNETCORE|3.1"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "MicrosoftAppId"           = azuread_application.bot_app.application_id
    "MicrosoftAppPassword"     = azuread_application_password.bot_password.value
  }
}