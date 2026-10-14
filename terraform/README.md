# Infrastructure AWS (Terraform) : ECS Fargate + RDS PostgreSQL

Internet -> ALB -> ECS (frontend Nginx -> backend Spring Boot) -> RDS PostgreSQL

| Etape du cours | Commande |
|---|---|
| Initialisation | `terraform init` |
| Planification | `terraform plan` |
| Creation | `terraform apply` |

## 0. Prerequis
`aws configure` (utilisateur IAM avec droits sur VPC, ECS, ECR, RDS, ELB, IAM, Secrets Manager), Terraform >= 1.6.

## 1. Creer l'infrastructure (taches a 0 : les images n'existent pas encore)
    cd terraform
    terraform init
    terraform validate
    terraform plan -out tfplan
    terraform apply tfplan

## 2. Pousser les images dans ECR
    REGION=eu-west-3
    BACK=$(terraform output -raw ecr_backend_url); FRONT=$(terraform output -raw ecr_frontend_url)
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${BACK%%/*}
    docker build -t $BACK:latest  ../backend  && docker push $BACK:latest
    docker build -t $FRONT:latest ../frontend && docker push $FRONT:latest

## 3. Demarrer l'application
    terraform apply -var desired_count=1
    terraform output app_url        # ouvrir cette URL

Logs : CloudWatch, groupes `/ecs/personnes-backend` et `/ecs/personnes-frontend`.

## 4. Supprimer (important : l'ALB et RDS sont factures a l'heure)
    terraform destroy -var desired_count=0

## Notes
- Pas de NAT Gateway : les taches ont une IP publique mais leur Security Group n'accepte que l'ALB. RDS est en sous-reseaux prives, joignable seulement par les taches.
- Le mot de passe RDS est genere par Terraform, stocke dans Secrets Manager et injecte dans le backend. Il figure aussi dans le fichier d'etat : ne le commitez pas (`.gitignore` fourni).
- HTTP seulement (port 80). Pour HTTPS : certificat ACM + listener 443.
