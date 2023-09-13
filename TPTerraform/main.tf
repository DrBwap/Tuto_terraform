terraform {
  required_providers {    #dépendances
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine" #lien pour connecter à docker desktop
}

resource "docker_image" "nginx" { #docker_image.nginx est l'ID de la ressource
  name         = "nginx"
  keep_locally = true
}

resource "docker_container" "controller" { #docker_container.nginx est l'ID de la ressource
  image = docker_image.nginx.image_id
  name  = "docker_controller"

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    volume_name = "shared_volume"
    container_path = "/shared_files"
    host_path = "C:\\Users\\Administrateur\\Tuto_terraform\\TPTerraform\\shared_files"
    }

  networks_advanced {
    name = "my_docker_network"
  }
}

resource "docker_container" "managed_container" { #docker_container.nginx est l'ID de la ressource
  count = var.counter

  image = docker_image.nginx.image_id
  name  = "docker_managed_container_${count.index+1}" #on génère autant de noms différents que de conteneurs

  volumes {
    volume_name = "shared_volume"
    container_path = "/shared_files"
    host_path = "C:\\Users\\Administrateur\\Tuto_terraform\\TPTerraform\\shared_files"
  }

  ports {                             #not really necessary until we want to call it from the web
    internal = 80
    external = 8080 + count.index + 1 #on génère autant de ports différents que de conteneurs
  }

  networks_advanced {
    name = "my_docker_network"
  }
}

resource "docker_volume" "ID_volume" {
  name = "shared_volume"

}

resource "docker_network" "ID_network" {
  name = "my_docker_network"
}


variable "counter" {
  description = "Iterative number used in creating a specific number of containers with their own names and ports"
  type        = number
  default     = 2
}