variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity-lab-thoanvtt-project-1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "australiaeast"
}

variable "username" {
  default = "adminlab01"
}

variable "password" {
  default = "r=$adminQy82022"
}

variable "packer_image" {
  default = "/subscriptions/f11cc760-de99-4c5d-8c73-861ec8a92622/resourceGroups/udacity-thoanvtt-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
}

variable "vm_count" {
  default = "2"
}

variable "server_name" {
  type = list
  default = ["server1", "server2"]
}