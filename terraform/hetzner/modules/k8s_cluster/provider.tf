# hetzner provider

provider "hcloud" {
    # export HCLOUD_TOKEN=HEROTOKEN
    poll_interval = "15s" // default is 500ms
}

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "~> 1.38.2"
    }
  }
}
