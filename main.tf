resource "azurerm_resource_group" "rg-lovazu-kuber" {
  name     = "lovazu-kuber"
  location = "West Europe"
}


resource "azurerm_virtual_network" "vn-lovazu-kuber" {
  name                = "example-network"
  location            = azurerm_resource_group.rg-lovazu-kuber.location
  resource_group_name = azurerm_resource_group.rg-lovazu-kuber.name
  address_space       = ["10.0.0.0/16"]


 

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
   
  }

  depends_on = [ azurerm_resource_group.rg-lovazu-kuber ]
}
resource "azurerm_network_interface" "nic-master" {
  name                = "nic-master"
  location            = azurerm_resource_group.rg-lovazu-kuber.location
  resource_group_name = azurerm_resource_group.rg-lovazu-kuber.name

  ip_configuration {
    name                          = "internal"
   
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "pip-master" {
  name                = "pip-master"
  resource_group_name = azurerm_resource_group.rg-lovazu-kuber.name
  location            = azurerm_resource_group.rg-lovazu-kuber.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.lovazu-kuber ]
}


resource "tls_private_key" "lovazu-linux-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file"  "linuxpemkey"{
  filename="lovazu-linux-key.pem"
  content=tls_private_key.lovazu-linux-key.private_key_pem
  depends_on = [ tls_private_key.lovazu-linux-key ]
}

resource "azurerm_linux_virtual_machine" "vm-master" {
  name                = "vm-master"
  resource_group_name = azurerm_resource_group.rg-lovazu-kuber.name
  location            = azurerm_resource_group.rg-lovazu-kuber.location
  size                = "Standard_F2"
  admin_username      = "myakala123"
  network_interface_ids = [
    azurerm_network_interface.nic-master.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.lovazu-linux-key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  depends_on = [ azurerm_network_interface.nic-master,
  azurerm_resource_group.rg-lovazu-kuber,
  tls_private_key.lovazu-linux-key
   ]
}
