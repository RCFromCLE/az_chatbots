output "bot_app_id" {
  value       = azurerm_bot_channels_registration.bot.microsoft_app_id
  description = "The Microsoft App ID of the Bot"
}

output "bot_endpoint" {
  value       = azurerm_bot_channels_registration.bot.endpoint
  description = "The endpoint URL of the Bot"
}