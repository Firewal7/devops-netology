variable "token" {
  type        = string
  description = "Your Yandex.Cloud API token"
}

variable "cloud_id" {
  type        = string
  description = "Your Yandex.Cloud Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Your Yandex.Cloud Folder ID"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default zone for resources"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###yandex_compute_image vars
variable "public_image" {
  type        = string
  default     = "fd8pqclrbi85ektgehlf"
  description = "Yandex.Compute image ID"
}
###name VM vars
variable "public_name" {
  type        = string
  default     = "public"
  description = "VM1 name"
}

###public_resources var

variable "public_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
 }
}

### Vm nat

###yandex_compute_image vars
variable "nat_image" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Yandex.Compute image ID"
}
###name VM vars
variable "nat_name" {
  type        = string
  default     = "nat"
  description = "VM2 name"
}

###nat_resources var

variable "nat_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
 }
}

### Private

variable "default_cidr_private" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
}

###yandex_compute_image vars
variable "private_image" {
  type        = string
  default     = "fd8pqclrbi85ektgehlf"
  description = "Yandex.Compute image ID"
}
###name VM vars
variable "private_name" {
  type        = string
  default     = "private"
  description = "VM3 name"
}

###nat_resources var

variable "private_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
 }
}