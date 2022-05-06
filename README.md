# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Install the dependencies below

3. Follow the instructions below.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Navigate locally to the repository

2. Authenticate into Azure

	Using the Azure CLI, authenticate into your desired subscription: `az login`

3. Deploy a Policy
    #### Create the Policy Definition
		`az policy definition create --name tagging-policy --display-name "deny-creation-if-untagged-resources" --description "This policy ensures all indexed resources in your subscription have tags and deny deployment if they do not" --rules "udacity-c1-policy.json" --mode All`

    #### Create the Policy Assignment
		`az policy assignment create --name 'tagging-policy' --display-name "deny-creation-if-untagged-resources" --policy tagging-policy`

    #### List the policy assignments to verify
    `az policy assignment list`

4. Create a Server Image with Packer
    #### Get your azure variables
    `az ad sp create-for-rbac --role Contributor --scopes /subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

    Get ouput fill in variables section in the server.json file
   ```
    "variables": {
      "client_id": "",
      "client_secret": "",
      "subscription_id": "" 
  	}
    ```

    #### Create image
    `packer build server.json`

    #### View images
    `az image list`

5. Create the infrastructure with Terraform Template
    Our Terraform template will allow us to reliably create, update, and destroy our infrastructure 
    #### Customize vars.tf
    ```
    Variables from vars.tf are called from mains.tf, for example the variable prefix is called as:

    `${var.prefix}`

    In vars.tf, the description and value is assigned in the following manner:

      variable "prefix" {
        description = "The prefix which should be used for all resources in this example"
        default = "udacity-lab-thoanvtt-project-1"
      }
    ```
    See all variable in vars.tf

6. Deploy infrastructure
    #### Initializing Working Directories
    `terraform init`
    #### Create infrastructure plan
    `terraform plan -out solution.plan`
    #### Deploy the infrastructure plan
    `terraform apply "solution.plan"`
    #### View infrastructure
    `terraform show`

    #### Destroy infrastructure (When done)
    `terraform destroy`
    #### Delete images (When done)
    `az image delete -g udacity-thoanvtt-project-1-rg -n myPackerImage`

### Output
`az policy assignment list`
  ```
  [  
    {
      "description": null,
      "displayName": "deny-creation-if-untagged-resources",
      "enforcementMode": "Default",
      "id": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/providers/Microsoft.Authorization/policyAssignments/tagging-policy",
      "identity": null,
      "location": null,
      "metadata": {
        "createdBy": "21f750fe-9fe5-47ba-b90c-7fa3678c415e",
        "createdOn": "2022-05-03T13:41:27.3724632Z",
        "updatedBy": null,
        "updatedOn": null
      },
        "createdBy": "21f750fe-9fe5-47ba-b90c-7fa3678c415e",
        "createdOn": "2022-05-03T13:41:27.3724632Z",
        "updatedBy": null,
        "updatedOn": null
      },
      "name": "tagging-policy",
      "nonComplianceMessages": null,
      "notScopes": null,
      "parameters": null,
      "policyDefinitionId": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/providers/Microsoft.Authorization/policyDefinitions/tagging-policy",
      "scope": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622",
      "systemData": {
        "createdAt": "2022-05-03T13:41:27.357078+00:00",
        "createdBy": "vothoan2014@gmail.com",
        "createdByType": "User",
        "lastModifiedAt": "2022-05-03T13:41:27.357078+00:00",
        "lastModifiedBy": "vothoan2014@gmail.com",
        "lastModifiedByType": "User"
      },
      "type": "Microsoft.Authorization/policyAssignments"
    }
  ]
```

`az image list`
```
  [
    {
      "extendedLocation": null,
      "hyperVGeneration": "V1",
      "id": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/UDACITY-THOANVTT-PROJECT-1-RG/providers/Microsoft.Compute/images/myPackerImage", 
      "location": "australiaeast",
      "name": "myPackerImage",
      "provisioningState": "Succeeded",
      "resourceGroup": "UDACITY-THOANVTT-PROJECT-1-RG",
      "sourceVirtualMachine": {
        "id": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/pkr-Resource-Group-sh7efjzoeu/providers/Microsoft.Compute/virtualMachines/pkrvmsh7efjzoeu",
        "resourceGroup": "pkr-Resource-Group-sh7efjzoeu"
      },
      "storageProfile": {
        "dataDisks": [],
        "osDisk": {
          "caching": "ReadWrite",
          "diskEncryptionSet": null,
          "diskSizeGb": 30,
          "managedDisk": {
            "id": "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/pkr-Resource-Group-sh7efjzoeu/providers/Microsoft.Compute/disks/pkrossh7efjzoeu",
            "resourceGroup": "pkr-Resource-Group-sh7efjzoeu"
          },
          "osState": "Generalized",
          "osType": "Linux",
          "snapshot": null,
          "storageAccountType": "Standard_LRS"
        },
        "zoneResilient": false
      },
      "tags": {
        "dept": "Engineering",
        "task": "Image deployment"
      },
      "type": "Microsoft.Compute/images"
    }
  ]
```

`terraform plan -out solution.plan`

```
  Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

  Terraform will perform the following actions:

    # azurerm_availability_set.project1 will be created
    + resource "azurerm_availability_set" "project1" {
        + id                           = (known after apply)
        + location                     = "australiaeast"
        + managed                      = true
        + name                         = "udacity-lab-thoanvtt-project-1-aset"
        + platform_fault_domain_count  = 2
        + platform_update_domain_count = 2
        + resource_group_name          = "udacity-lab-thoanvtt-project-1-rg"
        + tags                         = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_availability_set"
          }
      }

    # azurerm_lb.project1 will be created
    + resource "azurerm_lb" "project1" {
        + id                   = (known after apply)
        + location             = "australiaeast"
        + name                 = "udacity-lab-thoanvtt-project-1-lb"
        + private_ip_address   = (known after apply)
        + private_ip_addresses = (known after apply)
        + resource_group_name  = "udacity-lab-thoanvtt-project-1-rg"
        + sku                  = "Basic"
        + sku_tier             = "Regional"
        + tags                 = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_lb"
          }

        + frontend_ip_configuration {
            + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
            + id                                                 = (known after apply)
            + inbound_nat_rules                                  = (known after apply)
            + load_balancer_rules                                = (known after apply)
            + name                                               = "udacity-lab-thoanvtt-project-1-frontend-ipconfig-name"
            + outbound_rules                                     = (known after apply)
            + private_ip_address                                 = (known after apply)
            + private_ip_address_allocation                      = (known after apply)
            + private_ip_address_version                         = (known after apply)
            + public_ip_address_id                               = (known after apply)
            + public_ip_prefix_id                                = (known after apply)
            + subnet_id                                          = (known after apply)
          }
      }

    # azurerm_lb_backend_address_pool.project1 will be created
    + resource "azurerm_lb_backend_address_pool" "project1" {
        + backend_ip_configurations = (known after apply)
        + id                        = (known after apply)
        + load_balancing_rules      = (known after apply)
        + loadbalancer_id           = (known after apply)
        + name                      = "udacity-lab-thoanvtt-project-1-backend-address-pool-name"
        + outbound_rules            = (known after apply)
      }

    # azurerm_linux_virtual_machine.project1[0] will be created
    + resource "azurerm_linux_virtual_machine" "project1" {
        + admin_password                  = (sensitive value)
        + admin_username                  = "adminlab01"
        + allow_extension_operations      = true
        + availability_set_id             = (known after apply)
        + computer_name                   = (known after apply)
        + disable_password_authentication = false
        + extensions_time_budget          = "PT1H30M"
        + id                              = (known after apply)
        + location                        = "australiaeast"
        + max_bid_price                   = -1
        + name                            = "udacity-lab-thoanvtt-project-1-vm-0"
        + network_interface_ids           = (known after apply)
        + patch_mode                      = "ImageDefault"
        + platform_fault_domain           = -1
        + priority                        = "Regular"
        + private_ip_address              = (known after apply)
        + private_ip_addresses            = (known after apply)
        + provision_vm_agent              = true
        + public_ip_address               = (known after apply)
        + public_ip_addresses             = (known after apply)
        + resource_group_name             = "udacity-lab-thoanvtt-project-1-rg"
        + size                            = "Standard_B1s"
        + source_image_id                 = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-thoanvtt-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        + tags                            = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_linux_virtual_machine"
          }
        + virtual_machine_id              = (known after apply)

        + os_disk {
            + caching                   = "ReadWrite"
            + disk_size_gb              = (known after apply)
            + name                      = (known after apply)
            + storage_account_type      = "Standard_LRS"
            + write_accelerator_enabled = false
          }

        + termination_notification {
            + enabled = (known after apply)
            + timeout = (known after apply)
          }
      }

    # azurerm_linux_virtual_machine.project1[1] will be created
    + resource "azurerm_linux_virtual_machine" "project1" {
        + admin_password                  = (sensitive value)
        + admin_username                  = "adminlab01"
        + allow_extension_operations      = true
        + availability_set_id             = (known after apply)
        + computer_name                   = (known after apply)
        + disable_password_authentication = false
        + extensions_time_budget          = "PT1H30M"
        + id                              = (known after apply)
        + location                        = "australiaeast"
        + max_bid_price                   = -1
        + name                            = "udacity-lab-thoanvtt-project-1-vm-1"
        + network_interface_ids           = (known after apply)
        + patch_mode                      = "ImageDefault"
        + platform_fault_domain           = -1
        + priority                        = "Regular"
        + private_ip_address              = (known after apply)
        + private_ip_addresses            = (known after apply)
        + provision_vm_agent              = true
        + public_ip_address               = (known after apply)
        + public_ip_addresses             = (known after apply)
        + resource_group_name             = "udacity-lab-thoanvtt-project-1-rg"
        + size                            = "Standard_B1s"
        + source_image_id                 = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-thoanvtt-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        + tags                            = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_linux_virtual_machine"
          }
        + virtual_machine_id              = (known after apply)

        + os_disk {
            + caching                   = "ReadWrite"
            + disk_size_gb              = (known after apply)
            + name                      = (known after apply)
            + storage_account_type      = "Standard_LRS"
            + write_accelerator_enabled = false
          }

        + termination_notification {
            + enabled = (known after apply)
            + timeout = (known after apply)
          }
      }

    # azurerm_managed_disk.project1 will be created
    + resource "azurerm_managed_disk" "project1" {
        + create_option                 = "Empty"
        + disk_iops_read_only           = (known after apply)
        + disk_iops_read_write          = (known after apply)
        + disk_mbps_read_only           = (known after apply)
        + disk_mbps_read_write          = (known after apply)
        + disk_size_gb                  = 1
        + id                            = (known after apply)
        + location                      = "australiaeast"
        + logical_sector_size           = (known after apply)
        + max_shares                    = (known after apply)
        + name                          = "udacity-lab-thoanvtt-project-1-md"
        + public_network_access_enabled = true
        + resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
        + source_uri                    = (known after apply)
        + storage_account_type          = "Standard_LRS"
        + tags                          = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_managed_disk"
          }
        + tier                          = (known after apply)
      }

    # azurerm_network_interface.project1[0] will be created
    + resource "azurerm_network_interface" "project1" {
        + applied_dns_servers           = (known after apply)
        + dns_servers                   = (known after apply)
        + enable_accelerated_networking = false
        + enable_ip_forwarding          = false
        + id                            = (known after apply)
        + internal_dns_name_label       = (known after apply)
        + internal_domain_name_suffix   = (known after apply)
        + location                      = "australiaeast"
        + mac_address                   = (known after apply)
        + name                          = "udacity-lab-thoanvtt-project-1-nic-server1"
        + private_ip_address            = (known after apply)
        + private_ip_addresses          = (known after apply)
        + resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
        + tags                          = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_network_interface"
          }
        + virtual_machine_id            = (known after apply)

        + ip_configuration {
            + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
            + name                                               = "udacity-lab-thoanvtt-project-1-ipconfig"
            + primary                                            = (known after apply)
            + private_ip_address                                 = (known after apply)
            + private_ip_address_allocation                      = "Dynamic"
            + private_ip_address_version                         = "IPv4"
            + subnet_id                                          = (known after apply)
          }
      }

    # azurerm_network_interface.project1[1] will be created
    + resource "azurerm_network_interface" "project1" {
        + applied_dns_servers           = (known after apply)
        + dns_servers                   = (known after apply)
        + enable_accelerated_networking = false
        + enable_ip_forwarding          = false
        + id                            = (known after apply)
        + internal_dns_name_label       = (known after apply)
        + internal_domain_name_suffix   = (known after apply)
        + location                      = "australiaeast"
        + mac_address                   = (known after apply)
        + name                          = "udacity-lab-thoanvtt-project-1-nic-server2"
        + private_ip_address            = (known after apply)
        + private_ip_addresses          = (known after apply)
        + resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
        + tags                          = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_network_interface"
          }
        + virtual_machine_id            = (known after apply)

        + ip_configuration {
            + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
            + name                                               = "udacity-lab-thoanvtt-project-1-ipconfig"
            + primary                                            = (known after apply)
            + private_ip_address                                 = (known after apply)
            + private_ip_address_allocation                      = "Dynamic"
            + private_ip_address_version                         = "IPv4"
            + subnet_id                                          = (known after apply)
          }
      }

    # azurerm_network_interface_backend_address_pool_association.project1[0] will be created
    + resource "azurerm_network_interface_backend_address_pool_association" "project1" {
        + backend_address_pool_id = (known after apply)
        + id                      = (known after apply)
        + ip_configuration_name   = "udacity-lab-thoanvtt-project-1-ipconfig"
        + network_interface_id    = (known after apply)
      }

    # azurerm_network_interface_backend_address_pool_association.project1[1] will be created
    + resource "azurerm_network_interface_backend_address_pool_association" "project1" {
        + backend_address_pool_id = (known after apply)
        + id                      = (known after apply)
        + ip_configuration_name   = "udacity-lab-thoanvtt-project-1-ipconfig"
        + network_interface_id    = (known after apply)
      }

    # azurerm_network_security_group.project1 will be created
    + resource "azurerm_network_security_group" "project1" {
        + id                  = (known after apply)
        + location            = "australiaeast"
        + name                = "udacity-lab-thoanvtt-project-1-nsg"
        + resource_group_name = "udacity-lab-thoanvtt-project-1-rg"
        + security_rule       = [
            + {
                + access                                     = "Allow"
                + description                                = "Allow access to other VMs on the subnet"
                + destination_address_prefix                 = "VirtualNetwork"
                + destination_address_prefixes               = []
                + destination_application_security_group_ids = []
                + destination_port_range                     = "*"
                + destination_port_ranges                    = []
                + direction                                  = "Inbound"
                + name                                       = "AllowVMsAccessOnSubnet"
                + priority                                   = 2000
                + protocol                                   = "*"
                + source_address_prefix                      = "VirtualNetwork"
                + source_address_prefixes                    = []
                + source_application_security_group_ids      = []
                + source_port_range                          = "*"
                + source_port_ranges                         = []
              },
            + {
                + access                                     = "Deny"
                + description                                = "Deny direct access from the internet"
                + destination_address_prefix                 = "VirtualNetwork"
                + destination_address_prefixes               = []
                + destination_application_security_group_ids = []
                + destination_port_range                     = "*"
                + destination_port_ranges                    = []
                + direction                                  = "Inbound"
                + name                                       = "DenyDirectAcessFromInternet"
                + priority                                   = 1000
                + protocol                                   = "*"
                + source_address_prefix                      = "Internet"
                + source_address_prefixes                    = []
                + source_application_security_group_ids      = []
                + source_port_range                          = "*"
                + source_port_ranges                         = []
              },
          ]
        + tags                = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_network_security_group"
          }
      }

    # azurerm_public_ip.project1 will be created
    + resource "azurerm_public_ip" "project1" {
        + allocation_method       = "Static"
        + fqdn                    = (known after apply)
        + id                      = (known after apply)
        + idle_timeout_in_minutes = 4
        + ip_address              = (known after apply)
        + ip_version              = "IPv4"
        + location                = "australiaeast"
        + name                    = "udacity-lab-thoanvtt-project-1-pip"
        + resource_group_name     = "udacity-lab-thoanvtt-project-1-rg"
        + sku                     = "Basic"
        + sku_tier                = "Regional"
        + tags                    = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_public_ip"
          }
      }

    # azurerm_resource_group.project1 will be created
    + resource "azurerm_resource_group" "project1" {
        + id       = (known after apply)
        + location = "australiaeast"
        + name     = "udacity-lab-thoanvtt-project-1-rg"
        + tags     = {
            + "dept" = "Engineering"
            + "task" = "Project1"
          }
      }

    # azurerm_subnet.internal will be created
    + resource "azurerm_subnet" "internal" {
        + address_prefixes                               = [
            + "10.0.2.0/24",
          ]
        + enforce_private_link_endpoint_network_policies = false
        + enforce_private_link_service_network_policies  = false
        + id                                             = (known after apply)
        + name                                           = "internal"
        + resource_group_name                            = "udacity-lab-thoanvtt-project-1-rg"
        + virtual_network_name                           = "udacity-lab-thoanvtt-project-1-network"
      }

    # azurerm_virtual_network.project1 will be created
    + resource "azurerm_virtual_network" "project1" {
        + address_space       = [
            + "10.0.0.0/22",
          ]
        + dns_servers         = (known after apply)
        + guid                = (known after apply)
        + id                  = (known after apply)
        + location            = "australiaeast"
        + name                = "udacity-lab-thoanvtt-project-1-network"
        + resource_group_name = "udacity-lab-thoanvtt-project-1-rg"
        + subnet              = (known after apply)
        + tags                = {
            + "dept" = "Engineering"
            + "task" = "Project1"
            + "type" = "azurerm_virtual_network"
          }
      }

  Plan: 15 to add, 0 to change, 0 to destroy.

  ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

  Saved the plan to: solution.plan

  To perform exactly these actions, run the following command to apply:
      terraform apply "solution.plan"
```

`terraform apply "solution.plan" `
```
  azurerm_resource_group.project1: Creating```
  azurerm_resource_group.project1: Creation complete after 4s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg]
  azurerm_virtual_network.project1: Creating```
  azurerm_availability_set.project1: Creating```
  azurerm_public_ip.project1: Creating```
  azurerm_managed_disk.project1: Creating```
  azurerm_network_security_group.project1: Creating```
  azurerm_availability_set.project1: Creation complete after 6s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/availabilitySets/udacity-lab-thoanvtt-project-1-aset]
  azurerm_public_ip.project1: Creation complete after 7s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/publicIPAddresses/udacity-lab-thoanvtt-project-1-pip]
  azurerm_lb.project1: Creating```
  azurerm_managed_disk.project1: Creation complete after 8s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/disks/udacity-lab-thoanvtt-project-1-md]
  azurerm_network_security_group.project1: Creation complete after 9s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkSecurityGroups/udacity-lab-thoanvtt-project-1-nsg]
  azurerm_virtual_network.project1: Creation complete after 9s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network]
  azurerm_subnet.internal: Creating```
  azurerm_lb.project1: Creation complete after 4s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb]
  azurerm_lb_backend_address_pool.project1: Creating```
  azurerm_subnet.internal: Creation complete after 5s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network/subnets/internal]
  azurerm_network_interface.project1[0]: Creating```
  azurerm_network_interface.project1[1]: Creating```
  azurerm_lb_backend_address_pool.project1: Creation complete after 6s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name]
  azurerm_network_interface.project1[1]: Creation complete after 6s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2]
  azurerm_network_interface.project1[0]: Creation complete after 7s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1]
  azurerm_network_interface_backend_address_pool_association.project1[1]: Creating```
  azurerm_network_interface_backend_address_pool_association.project1[0]: Creating```
  azurerm_linux_virtual_machine.project1[0]: Creating```
  azurerm_linux_virtual_machine.project1[1]: Creating```
  azurerm_network_interface_backend_address_pool_association.project1[0]: Creation complete after 2s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1/ipConfigurations/udacity-lab-thoanvtt-project-1-ipconfig|/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name]
  azurerm_network_interface_backend_address_pool_association.project1[1]: Creation complete after 3s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2/ipConfigurations/udacity-lab-thoanvtt-project-1-ipconfig|/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name]
  azurerm_linux_virtual_machine.project1[0]: Still creating``` [10s elapsed]
  azurerm_linux_virtual_machine.project1[1]: Still creating``` [10s elapsed]
  azurerm_linux_virtual_machine.project1[0]: Still creating``` [20s elapsed]
  azurerm_linux_virtual_machine.project1[1]: Still creating``` [20s elapsed]
  azurerm_linux_virtual_machine.project1[1]: Still creating``` [30s elapsed]
  azurerm_linux_virtual_machine.project1[0]: Still creating``` [30s elapsed]
  azurerm_linux_virtual_machine.project1[0]: Still creating``` [40s elapsed]
  azurerm_linux_virtual_machine.project1[1]: Still creating``` [40s elapsed]
  azurerm_linux_virtual_machine.project1[1]: Still creating``` [50s elapsed]
  azurerm_linux_virtual_machine.project1[0]: Still creating``` [50s elapsed]
  azurerm_linux_virtual_machine.project1[0]: Creation complete after 50s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/virtualMachines/udacity-lab-thoanvtt-project-1-vm-0]
  azurerm_linux_virtual_machine.project1[1]: Creation complete after 50s [id=/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/virtualMachines/udacity-lab-thoanvtt-project-1-vm-1]

  Apply complete! Resources: 15 added, 0 changed, 0 destroyed.
```

 `terraform show`
```
  # azurerm_availability_set.project1:
  resource "azurerm_availability_set" "project1" {
      id                           = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/availabilitySets/udacity-lab-thoanvtt-project-1-aset"
      location                     = "australiaeast"
      managed                      = true
      name                         = "udacity-lab-thoanvtt-project-1-aset"
      platform_fault_domain_count  = 2
      platform_update_domain_count = 2
      resource_group_name          = "udacity-lab-thoanvtt-project-1-rg"
      tags                         = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_availability_set"
      }
  }

  # azurerm_lb.project1:
  resource "azurerm_lb" "project1" {
      id                   = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb"
      location             = "australiaeast"
      name                 = "udacity-lab-thoanvtt-project-1-lb"
      private_ip_addresses = []
      resource_group_name  = "udacity-lab-thoanvtt-project-1-rg"
      sku                  = "Basic"
      sku_tier             = "Regional"
      tags                 = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_lb"
      }

      frontend_ip_configuration {
          id                            = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/frontendIPConfigurations/udacity-lab-thoanvtt-project-1-frontend-ipconfig-name"
          inbound_nat_rules             = []
          load_balancer_rules           = []
          name                          = "udacity-lab-thoanvtt-project-1-frontend-ipconfig-name"
          outbound_rules                = []
          private_ip_address_allocation = "Dynamic"
          public_ip_address_id          = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/publicIPAddresses/udacity-lab-thoanvtt-project-1-pip"
      }
  }

  # azurerm_lb_backend_address_pool.project1:
  resource "azurerm_lb_backend_address_pool" "project1" {
      backend_ip_configurations = []
      id                        = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      load_balancing_rules      = []
      loadbalancer_id           = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb"
      name                      = "udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      outbound_rules            = []
  }

  # azurerm_linux_virtual_machine.project1[0]:
  resource "azurerm_linux_virtual_machine" "project1" {
      admin_password                  = (sensitive value)
      admin_username                  = "adminlab01"
      allow_extension_operations      = true
      availability_set_id             = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/availabilitySets/UDACITY-LAB-THOANVTT-PROJECT-1-ASET"
      computer_name                   = "udacity-lab-thoanvtt-project-1-vm-0"
      disable_password_authentication = false
      encryption_at_host_enabled      = false
      extensions_time_budget          = "PT1H30M"
      id                              = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/virtualMachines/udacity-lab-thoanvtt-project-1-vm-0"
      location                        = "australiaeast"
      max_bid_price                   = -1
      name                            = "udacity-lab-thoanvtt-project-1-vm-0"
      network_interface_ids           = [
          "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1",
      ]
      patch_mode                      = "ImageDefault"
      platform_fault_domain           = -1
      priority                        = "Regular"
      private_ip_address              = "10.0.2.5"
      private_ip_addresses            = [
          "10.0.2.5",
      ]
      provision_vm_agent              = true
      public_ip_addresses             = []
      resource_group_name             = "udacity-lab-thoanvtt-project-1-rg"
      secure_boot_enabled             = false
      size                            = "Standard_B1s"
      source_image_id                 = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-thoanvtt-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
      tags                            = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_linux_virtual_machine"
      }
      virtual_machine_id              = "6d96ba20-b107-4786-b759-c62db304896f"
      vtpm_enabled                    = false

      os_disk {
          caching                   = "ReadWrite"
          disk_size_gb              = 30
          name                      = "udacity-lab-thoanvtt-project-1-vm-0_disk1_2565ecec19354f4c8b7d2b70b93933ec"
          storage_account_type      = "Standard_LRS"
          write_accelerator_enabled = false
      }
  }

  # azurerm_linux_virtual_machine.project1[1]:
  resource "azurerm_linux_virtual_machine" "project1" {
      admin_password                  = (sensitive value)
      admin_username                  = "adminlab01"
      allow_extension_operations      = true
      availability_set_id             = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/availabilitySets/UDACITY-LAB-THOANVTT-PROJECT-1-ASET"
      computer_name                   = "udacity-lab-thoanvtt-project-1-vm-1"
      disable_password_authentication = false
      encryption_at_host_enabled      = false
      extensions_time_budget          = "PT1H30M"
      id                              = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/virtualMachines/udacity-lab-thoanvtt-project-1-vm-1"
      location                        = "australiaeast"
      max_bid_price                   = -1
      name                            = "udacity-lab-thoanvtt-project-1-vm-1"
      network_interface_ids           = [
          "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2",
      ]
      patch_mode                      = "ImageDefault"
      platform_fault_domain           = -1
      priority                        = "Regular"
      private_ip_address              = "10.0.2.4"
      private_ip_addresses            = [
          "10.0.2.4",
      ]
      provision_vm_agent              = true
      public_ip_addresses             = []
      resource_group_name             = "udacity-lab-thoanvtt-project-1-rg"
      secure_boot_enabled             = false
      size                            = "Standard_B1s"
      source_image_id                 = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-thoanvtt-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
      tags                            = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_linux_virtual_machine"
      }
      virtual_machine_id              = "acfab2bf-75b8-487f-b5cd-a8670db50c36"
      vtpm_enabled                    = false

      os_disk {
          caching                   = "ReadWrite"
          disk_size_gb              = 30
          name                      = "udacity-lab-thoanvtt-project-1-vm-1_disk1_7d0d133c26c5416a9f4fa7e6a80470d2"
          storage_account_type      = "Standard_LRS"
          write_accelerator_enabled = false
      }
  }

  # azurerm_managed_disk.project1:
  resource "azurerm_managed_disk" "project1" {
      create_option                 = "Empty"
      disk_iops_read_only           = 0
      disk_iops_read_write          = 500
      disk_mbps_read_only           = 0
      disk_mbps_read_write          = 60
      disk_size_gb                  = 1
      id                            = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Compute/disks/udacity-lab-thoanvtt-project-1-md"
      location                      = "australiaeast"
      max_shares                    = 0
      name                          = "udacity-lab-thoanvtt-project-1-md"
      on_demand_bursting_enabled    = false
      public_network_access_enabled = true
      resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
      storage_account_type          = "Standard_LRS"
      tags                          = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_managed_disk"
      }
      trusted_launch_enabled        = false
  }

  # azurerm_network_interface.project1[1]:
  resource "azurerm_network_interface" "project1" {
      applied_dns_servers           = []
      dns_servers                   = []
      enable_accelerated_networking = false
      enable_ip_forwarding          = false
      id                            = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2"
      internal_domain_name_suffix   = "b0x4nj1bpvqubiu3pwrzbebdoc.px.internal.cloudapp.net"
      location                      = "australiaeast"
      name                          = "udacity-lab-thoanvtt-project-1-nic-server2"
      private_ip_address            = "10.0.2.4"
      private_ip_addresses          = [
          "10.0.2.4",
      ]
      resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
      tags                          = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_network_interface"
      }

      ip_configuration {
          name                          = "udacity-lab-thoanvtt-project-1-ipconfig"
          primary                       = true
          private_ip_address            = "10.0.2.4"
          private_ip_address_allocation = "Dynamic"
          private_ip_address_version    = "IPv4"
          subnet_id                     = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network/subnets/internal"
      }
  }

  # azurerm_network_interface.project1[0]:
  resource "azurerm_network_interface" "project1" {
      applied_dns_servers           = []
      dns_servers                   = []
      enable_accelerated_networking = false
      enable_ip_forwarding          = false
      id                            = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1"
      internal_domain_name_suffix   = "b0x4nj1bpvqubiu3pwrzbebdoc.px.internal.cloudapp.net"
      location                      = "australiaeast"
      name                          = "udacity-lab-thoanvtt-project-1-nic-server1"
      private_ip_address            = "10.0.2.5"
      private_ip_addresses          = [
          "10.0.2.5",
      ]
      resource_group_name           = "udacity-lab-thoanvtt-project-1-rg"
      tags                          = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_network_interface"
      }

      ip_configuration {
          name                          = "udacity-lab-thoanvtt-project-1-ipconfig"
          primary                       = true
          private_ip_address            = "10.0.2.5"
          private_ip_address_allocation = "Dynamic"
          private_ip_address_version    = "IPv4"
          subnet_id                     = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network/subnets/internal"
      }
  }

  # azurerm_network_interface_backend_address_pool_association.project1[1]:
  resource "azurerm_network_interface_backend_address_pool_association" "project1" {
      backend_address_pool_id = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      id                      = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2/ipConfigurations/udacity-lab-thoanvtt-project-1-ipconfig|/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      ip_configuration_name   = "udacity-lab-thoanvtt-project-1-ipconfig"
      network_interface_id    = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server2"
  }

  # azurerm_network_interface_backend_address_pool_association.project1[0]:
  resource "azurerm_network_interface_backend_address_pool_association" "project1" {
      backend_address_pool_id = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      id                      = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1/ipConfigurations/udacity-lab-thoanvtt-project-1-ipconfig|/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/loadBalancers/udacity-lab-thoanvtt-project-1-lb/backendAddressPools/udacity-lab-thoanvtt-project-1-backend-address-pool-name"
      ip_configuration_name   = "udacity-lab-thoanvtt-project-1-ipconfig"
      network_interface_id    = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkInterfaces/udacity-lab-thoanvtt-project-1-nic-server1"
  }

  # azurerm_network_security_group.project1:
  resource "azurerm_network_security_group" "project1" {
      id                  = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/networkSecurityGroups/udacity-lab-thoanvtt-project-1-nsg"
      location            = "australiaeast"
      name                = "udacity-lab-thoanvtt-project-1-nsg"
      resource_group_name = "udacity-lab-thoanvtt-project-1-rg"
      security_rule       = [
          {
              access                                     = "Allow"
              description                                = "Allow access to other VMs on the subnet"
              destination_address_prefix                 = "VirtualNetwork"
              destination_address_prefixes               = []
              destination_application_security_group_ids = []
              destination_port_range                     = "*"
              destination_port_ranges                    = []
              direction                                  = "Inbound"
              name                                       = "AllowVMsAccessOnSubnet"
              priority                                   = 2000
              protocol                                   = "*"
              source_address_prefix                      = "VirtualNetwork"
              source_address_prefixes                    = []
              source_application_security_group_ids      = []
              source_port_range                          = "*"
              source_port_ranges                         = []
          },
          {
              access                                     = "Deny"
              description                                = "Deny direct access from the internet"
              destination_address_prefix                 = "VirtualNetwork"
              destination_address_prefixes               = []
              destination_application_security_group_ids = []
              destination_port_range                     = "*"
              destination_port_ranges                    = []
              direction                                  = "Inbound"
              name                                       = "DenyDirectAcessFromInternet"
              priority                                   = 1000
              protocol                                   = "*"
              source_address_prefix                      = "Internet"
              source_address_prefixes                    = []
              source_application_security_group_ids      = []
              source_port_range                          = "*"
              source_port_ranges                         = []
          },
      ]
      tags                = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_network_security_group"
      }
  }

  # azurerm_public_ip.project1:
  resource "azurerm_public_ip" "project1" {
      allocation_method       = "Static"
      id                      = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/publicIPAddresses/udacity-lab-thoanvtt-project-1-pip"
      idle_timeout_in_minutes = 4
      ip_address              = "13.70.106.229"
      ip_version              = "IPv4"
      location                = "australiaeast"
      name                    = "udacity-lab-thoanvtt-project-1-pip"
      resource_group_name     = "udacity-lab-thoanvtt-project-1-rg"
      sku                     = "Basic"
      sku_tier                = "Regional"
      tags                    = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_public_ip"
      }
  }

  # azurerm_resource_group.project1:
  resource "azurerm_resource_group" "project1" {
      id       = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg"
      location = "australiaeast"
      name     = "udacity-lab-thoanvtt-project-1-rg"
      tags     = {
          "dept" = "Engineering"
          "task" = "Project1"
      }
  }

  # azurerm_subnet.internal:
  resource "azurerm_subnet" "internal" {
      address_prefixes                               = [
          "10.0.2.0/24",
      ]
      enforce_private_link_endpoint_network_policies = false
      enforce_private_link_service_network_policies  = false
      id                                             = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network/subnets/internal"
      name                                           = "internal"
      resource_group_name                            = "udacity-lab-thoanvtt-project-1-rg"
      virtual_network_name                           = "udacity-lab-thoanvtt-project-1-network"
  }

  # azurerm_virtual_network.project1:
  resource "azurerm_virtual_network" "project1" {
          "10.0.0.0/22",
      ]
      dns_servers             = []
      flow_timeout_in_minutes = 0
      guid                    = "a7e6af0e-7d61-4061-a29d-7da390902372"
      id                      = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-lab-thoanvtt-project-1-rg/providers/Microsoft.Network/virtualNetworks/udacity-lab-thoanvtt-project-1-network"
      location                = "australiaeast"
      name                    = "udacity-lab-thoanvtt-project-1-network"
      resource_group_name     = "udacity-lab-thoanvtt-project-1-rg"
      subnet                  = []
      tags                    = {
          "dept" = "Engineering"
          "task" = "Project1"
          "type" = "azurerm_virtual_network"
      }
  }

```

