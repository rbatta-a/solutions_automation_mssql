terraform {
  required_providers {

    vsphere = {
      source  = "hashicorp/vsphere"
      #version = "2.1.1"
    }
    infoblox = {
    source = "infobloxopen/infoblox"
    version = "2.3.0"
    }
  }
}



## Configure the vSphere Provider

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  allow_unverified_ssl = true
}

provider "infoblox" {
username = "svc_fb_infoblox_auto"
password = var.infoblox_pass
server = "prod-ipam.puretec.purestorage.com"
}