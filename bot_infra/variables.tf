variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region to deploy the resources"
}

variable "bot_name" {
  type        = string
  description = "Name of the customer service bot"
}