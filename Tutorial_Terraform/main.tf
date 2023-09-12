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
  keep_locally = false
}

resource "docker_container" "nginx" { #docker_container.nginx est l'ID de la ressource
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = 8080
  }
}
