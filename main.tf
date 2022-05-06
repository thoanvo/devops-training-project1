provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project1" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    dept = "Engineering",
    task = "Project1"
  }
}

resource "azurerm_virtual_network" "project1" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_virtual_network"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.project1.name
  virtual_network_name = azurerm_virtual_network.project1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "project1" {
  name                = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.project1.name
  location            = azurerm_resource_group.project1.location
  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_network_security_group"
  }

  security_rule {
    name                       = "AllowVMsAccessOnSubnet"
    description                = "Allow access to other VMs on the subnet"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = "2000"
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "DenyDirectAcessFromInternet"
    description                = "Deny direct access from the internet"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Deny"
    priority                   = "1000"
    direction                  = "Inbound"
  }
}

resource "azurerm_network_interface" "project1" {
  count               = "${var.vm_count}"
  name                = "${var.prefix}-nic-${var.server_name[count.index]}"
  resource_group_name = azurerm_resource_group.project1.name
  location            = azurerm_resource_group.project1.location


  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_network_interface"
  }
}

resource "azurerm_public_ip" "project1" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.project1.name
  location            = azurerm_resource_group.project1.location
  allocation_method   = "Static"

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_public_ip"
  }
}

resource "azurerm_lb" "project1" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.project1.location
  resource_group_name = azurerm_resource_group.project1.name

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_lb"
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend-ipconfig-name"
    public_ip_address_id = azurerm_public_ip.project1.id
  }
}

resource "azurerm_lb_backend_address_pool" "project1" {
  loadbalancer_id = azurerm_lb.project1.id
  name            = "${var.prefix}-backend-address-pool-name"
}

resource "azurerm_network_interface_backend_address_pool_association" "project1" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.project1[count.index].id
  ip_configuration_name   = "${var.prefix}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.project1.id
}


resource "azurerm_availability_set" "project1" {
  name                         = "${var.prefix}-aset"
  location                     = azurerm_resource_group.project1.location
  resource_group_name          = azurerm_resource_group.project1.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_availability_set"
  }
}

resource "azurerm_linux_virtual_machine" "project1" {
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.project1.name
  location                        = azurerm_resource_group.project1.location
  size                            = "Standard_B1s"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  count                           = "${var.vm_count}"
  availability_set_id             = azurerm_availability_set.project1.id

  network_interface_ids = [
    element(azurerm_network_interface.project1.*.id, count.index)
  ]

  source_image_id = "${var.packer_image}"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_linux_virtual_machine"
  }
}

resource "azurerm_managed_disk" "project1" {
  name                 = "${var.prefix}-md"
  location             = azurerm_resource_group.project1.location
  resource_group_name  = azurerm_resource_group.project1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    dept = "Engineering",
    task = "Project1",
    type = "azurerm_managed_disk"
  }
}

