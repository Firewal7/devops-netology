 variable "token" {
  type        = string
  description = "AQAAAAAvafbJAATuwdLAPg798Un2j3iJLzGhuuY"
}

variable "cloud_id" {
  type        = string
  description = "b1g19chq3o5d0u2d4se6"
}

variable "folder_id" {
  type        = string
  description = "b1giheq958o43g020idm"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "e9bfl31n6cfsdq6stini"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}
###ssh vars
#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-rsa 
#  description = "ssh-keygen -t ed25519"
#}

###ssh map vers
variable "vms_ssh_root_key" {
  type = map(any)
  default = {
   serial-port-enable   = 1
   ssh-keys             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCED/bj9qwN7AB3O7KUmgH2EadKCFpsQwAive7qtSYMEX4TeGILoCbDftmOI0vcNKy0SmJSVEL7t+hip6YwA67vDrvhkmsdUuGH0LbYoF0BX+VFBEbrS2z2wLrS+kzYACxt8BzADPZ+IFXGWXOmwk2aLQzteDMq9R83k+P2lgzQve5qNQzxbehDA5ouTtFsrR+v99AuFv15XQFsA1SjSUupSqfx2XbRZXp8t/JLDyBvqlxZitibrJvMrnIOfTLyFLNQOJNO8Sxb9kLtBgfFymauCdeOG9ngfbWV8rayaJPjIAEdW6qxATpq56qHcg3FNjWT9yRvaUFK5nTpNUvvGG2qb+GVM7u3zMHitHmFJqkKyhdIthXewLAOv6pp2tCVOLPg3oPYMt+ex2of0lMqVzJMXCV0Nx9pi5nJRlY3r5BzN9bdVBtQ4IUXmhLWQ4TtDtIarTy3wqELyQVYTTEhzBYfqlehEsT+i/533K6BiBV6OvPvAU+tfklj48C94zy7a0= root@kali"
  }
}
###yandex_compute_image vars
variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu release name"
}
###name VM vars
variable "vm_web_web" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM1 name"
}

variable "vm_web_db" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM2 name"
}

###yandex_compute_instance vars
#variable "vm_web_cores" {
#  type        = number
#  default     = 2
#  description = "cores"
#}

#variable "vm_web_mem" {
#  type        = number
#  default     = 1
#  description = "memory"
#}

#variable "vm_web_frac" {
#  type        = number
#  default     = 5
#  description = "fraction"
#}

###vm_web_resources var

variable "vm_web_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
 }
}

variable "vm_db_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 20
  }
}
