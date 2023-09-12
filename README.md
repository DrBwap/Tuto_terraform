# Tuto_terraform
tutorial terraform via m2i

Hello! Dear myself, let's write stuff about Terraform
https://developer.hashicorp.com/terraform/tutorials/docker-get-started is the tutorial, yay!

So what about Terraform you say? Or don't whatever.
Terraform est un outil permettant d'automatiser la gestion de l'infrastructure informatique, ce qui permet d'améliorer la reproductibilité, la sécurité et l'efficacité des opérations informatiques. Il utilise l'IaC, Infrastructure as Code.
________________________________________________
Installation:

Pour l'installer: https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli
Note: pour plus de simplicité, on a installé un truc au chocolat, comme quoi c'est vraiment trop bon.

Le langage utilisé est JSON ou HCL (HashiCorp Configuration Language)

________________________________________________
Initialisation:

Basiquement, il y aura un main file, main.tf, qui va avoir toutes les configurations nécessaires pour la création des infrastructures. On l'initialise ensuite avec la commande:

    terraform init

Puis on applique la configuration avec:

    terraform apply

    Note: quand on demande de dire yes, on dit yes et on sourit.

Pour stopper l'utilisation d'une infrastructure:

    terraform destroy

Dans le tutoriel, on a créé un conteneur nginx via docker, qu'on stoppe ensuite avec terraform destroy.
    Note: pour reproduire l'exemple, il faut avoir lancé docker desktop

________________________________________________
Concernant l'anatomie du main.tf: (needs tons of updates)

Voici un main.tf avec en commentaire les fonctions de chaque partie: 

# Configuration Terraform qui spécifie les fournisseurs requis et leurs versions.
terraform {
  required_providers {
    # Utilise le fournisseur Docker en spécifiant sa  source et sa version.
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

#### Définit le fournisseur Docker avec l'adresse du moteur Docker.
provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

#### Défini une ressource pour l'image Docker NGINX à utiliser.
resource "docker_image" "nginx" {
  #### Spécifie le nom de l'image Docker à utiliser.
  name         = "nginx"
  #### Indique si l'image doit être conservée localement ou non.
  keep_locally = false
}

### Définit une ressource pour le conteneur Docker NGINX.
resource "docker_container" "nginx" {
  #### Spécifie l'ID de l'image Docker à utiliser pour le conteneur.
  image = docker_image.nginx.image_id
  #### Utilise une variable pour spécifier le nom du conteneur.
  name  = var.container_name

  #### Configure les ports du conteneur Docker.
  ports {
    #### Port interne du conteneur (dans le conteneur lui-même).
    internal = 80
    # Port externe sur la machine hôte (sur lequel le conteneur sera accessible).
    external = 8080
  }
}


terraform show:

permet de d'afficher le statut de l'objet créé.
Le résultat est également contenu dans le fichier créé lors de terraform apply : terraform.tfstate

terraform state:
la commande terraform state permet d'inspecter et gérer les ressources et les données stockées dans le fichier d'état terraform (le terraform.tfstate donc).
________________________________________________
Update & Destroy

Lors d'updates, terraform va déterminer s'il est préférable de tout détruire pour repartir sur des bases saines lors de la modification du main.
On update avec:

    terraform apply

________________________________________________
Inputs & Outputs beaches!

Si on veut ajouter des variables, des inputs, outputs, on peut créer des fichiers .tf, ou l'ajouter au main (j'imagine que c'est relativement déconseillé par soucis de clareté)

Exemple: Utilisation d'une variable pour un input

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}

Il faut cependant mettre à jour le main.tf pour utiliser la variable:

    - name = "tutorial"             #nom par défaut
    + name = var.container_name     #nom de la variable

Ensuite on peut modifier cette variable grace à la commande:

    terraform apply -var "container_name=UnAutreNom"

Exemples: Afficher un output:

output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}

Après avoir apply cette partie, il va renvoyer:

Outputs:
container_id = ....
image_id = ....

Et grace à la commande:

    terraform output

On obtient le même affichage.