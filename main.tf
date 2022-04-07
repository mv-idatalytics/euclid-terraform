terrafrom{
  required_providers {  
    azurerm = {  
      source = "hashicorp/azurerm"  
    }  
  }  
}  
provider "azurerm" {  
  features {}  
}  
resource "azurerm_resource_group" "{ResourceGroup}" {  
  name = "{ResourceGroup}"  
  location = "eastus"  
} 
resource "azurerm_virtual_network" "{VirtualNetwork}" {
  name                = "{VirtualNetwork}"
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.{ResourceGroup}.location
  resource_group_name = azurerm_resource_group.{ResourceGroup}.name
}

resource "azurerm_subnet" "{Subnet}" {
  name                 = "{Subnet}"
  resource_group_name  = azurerm_resource_group.{ResourceGroup}.name
  virtual_network_name = azurerm_virtual_network.{VirtualNewtwork}.name
  address_prefixes     = ["10.1.0.0/26"]
}

resource "azurerm_network_interface" "{NIC}" {
  name                = "{NIC}"
  location            = azurerm_resource_group.{ResourceGroup}.location
  resource_group_name = azurerm_resource_group.{ResourceGroup}.name

  ip_configuration {
    name                          = "{IP}"
    subnet_id                     = azurerm_subnet.{Subnet}.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "{VirtualMachine}" {
  name                = "{VirtualMachine}"
  resource_group_name = azurerm_resource_group.{ResourceGroup}.name
  location            = azurerm_resource_group.{ResourceGroup}.location
  size                = "Standard_F2"
  admin_username      = "Provide username"
  admin_password      = "Provide Password"
  network_interface_ids = [
    azurerm_network_interface.{NIC}.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}











