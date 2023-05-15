terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
 
}

provider "azurerm" {
  # Configuration options
  subscription_id = "01f0d3fe-81ed-4669-ae52-181ef6dd00ed"
  tenant_id = "53c5ad11-8383-4a53-bd9c-90d50d7844ad"
  client_id = "62921a8e-a932-4804-b643-8ceaa0294ced"
  client_secret = "lh-8Q~ktXd.sFGn68VLXQwAZs3gWSnZ~5WECachE"
  features{}
}
