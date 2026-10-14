# Gestion des personnes

Etape 1/10 : 13/10/2026 de 17:00 à 17:40

CRUD : React (Vite) + Spring Boot (Java 17, Maven) + PostgreSQL.

## Lancer
1. Base de données : `docker compose up -d`
2. Backend : `cd backend && mvn spring-boot:run`  (http://localhost:8080)
3. Frontend : `cd frontend && npm install && npm run dev`  (http://localhost:5173)

## API
| Méthode | URL | Description |
|---|---|---|
| GET | /api/personnes | Liste |
| GET | /api/personnes/{code} | Détail |
| POST | /api/personnes | Création |
| PUT | /api/personnes/{code} | Modification (name, cin) |
| DELETE | /api/personnes/{code} | Suppression |

Table `personne` (code PK, name, cin unique), créée automatiquement au démarrage.





Structure du projet:
gestion-personnes/
├── docker-compose.yml        # PostgreSQL 17
├── backend/                  # Spring Boot 3.5, Java 25
│   └── src/main/java/com/example/personnes/
│       ├── Personne.java            # entité (code, name, cin)
│       ├── PersonneRequest.java     # DTO avec validation
│       ├── PersonneRepository.java
│       ├── PersonneService.java     # règles métier
│       ├── PersonneController.java  # API REST
│       ├── ApiExceptionHandler.java # erreurs JSON propres
│       └── CorsConfig.java
└── frontend/                 # React 18 + Vite
    └── src/ (App.jsx, PersonForm.jsx, api.js, styles.css)
    
Lancement:

#sed -i 's/"credsStore"/"credsStore_old"/' ~/.docker/config.json

##. Développement local

démarre PostgreSQL:
docker-compose up -d db            # PostgreSQL sur le port 5436

cd backend && mvn spring-boot:run 
démarre l’API sur http://localhost:8080.

cd frontend && npm install && npm run dev 
ouvre l’interface sur http://localhost:5173.

Etape 2/10 : 13/10/2026  de 18:15 à 19:15

https://github.com/bassembenabbes/FullStackDevOpsProject

git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/bassembenabbes/FullStackDevOpsProject.git
git push -u origin main
Username for 'https://github.com': bassembenabbes
Password for 'https://bassembenabbes@github.com': votre Token


Etape 3/10 : 13/10/2026  de 21:25 à 23:25

Dockeriser tout le projet : 
un Dockerfile pour le backend (build Maven puis image JRE) 
et un Dockerfile pour le frontend (build Vite servi par Nginx), 
le tout dans le même docker-compose.yml.
Un seul docker-compose up lancerait alors l’ensemble.

## 1. Tout lancer avec Docker Compose
docker-compose down
    docker-compose up --build
Application : http://localhost:3000 (API : http://localhost:8080/api/personnes)
Java 17 : dans `docker-compose.yml`, mettre `JAVA_VERSION: 17` (et `mvn -Djava.version=17` en local).

curl -i -X POST localhost:3000/api/personnes \
  -H 'Content-Type: application/json' -H 'Origin: http://localhost:3000' \
  -d '{"code":"P0003","name":"Ali","cin":"92345678"}'
#!!!Invalid CORS reques!!! :Dans frontend/nginx.conf, ajoutez une ligne dans le bloc location /api/ :
  location /api/ {
    proxy_pass http://backend:8080;
    proxy_set_header Host $host;
    proxy_set_header Origin "";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
    

Qualité : tests unitaires et d’intégration du backend (Testcontainers pour PostgreSQL)

## 2. Tests (Docker requis pour Testcontainers)
    cd backend && mvn verify

Kubernetes : le dossiers  FullStackDevOpsProject.
Il faudrait des manifestes (Deployment, Service, Secret pour les identifiants de la base, PersistentVolumeClaim pour PostgreSQL, Ingress).
## 3. Kubernetes (minikube / kind)
minikube start
minikube status
kubectl get nodes
eval $(minikube docker-env)
docker context use default
docker context show 

# 1. Construire les images dans Minikube
docker build -t personnes-backend:latest ./backend
docker build -t personnes-frontend:latest ./frontend

# 2. Vérifier qu'elles y sont
minikube image ls | grep personnes
docker.io/library/personnes-frontend:latest
docker.io/library/personnes-backend:latest


# 3. Voir votre structure k8s
ls -la k8s/    # ou l'emplacement de vos manifests


    docker build -t personnes-backend:latest backend
    docker build --no-cache -t personnes-backend:latest backend
    docker build -t personnes-frontend:latest frontend
    minikube image load personnes-backend:latest personnes-frontend:latest   # kind : kind load docker-image ...
    
    minikube addons enable ingress
# 4. Déployer
    kubectl apply -k k8s
    kubectl -n personnes get pods -w
Accès : ajouter `<ip> personnes.local` à /etc/hosts (`minikube ip`), ou sans Ingress :
    kubectl -n personnes port-forward svc/frontend 3000:80
    
minikube ip
192.168.49.2
echo "$(minikube ip) personnes.local" | sudo tee -a /etc/hosts
cat /etc/hosts | grep personnes

# 5. Vérifier
kubectl -n personnes get pods
kubectl -n personnes get svc
kubectl -n personnes get ingress

Pipeline CI/CD : build, tests et push des images, avec GitHub Actions.
## 4. CI/CD (GitHub Actions)
`.github/workflows/ci.yml` : tests backend, build frontend, puis build/push des images
`ghcr.io/<compte>/personnes-backend` et `personnes-frontend` (push uniquement sur main et tags `v*`).

docker pull ghcr.io/bassembenabbes/personnes-backend:sha-5983d68
docker pull ghcr.io/bassembenabbes/personnes-frontend:sha-5983d68



kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=bassembenabbes \
  --docker-password=<VOTRE_PAT>  \
  --docker-email=bassem.benabbes@gmail.com \
  -n personnes
  
  Remplacez <VOTRE_PAT> par le token copié
  
  
  imagePullSecrets:
        - name: ghcr-secret        # ← AJOUTER
      containers:
        - name: backend
          image: ghcr.io/bassembenabbes/personnes-backend:latest  # ← CHANGER
          imagePullPolicy: Always   # ← CHANGER (car l'image distante peut être mise à jour)
         
         
         
kubectl apply -k k8s
kubectl -n personnes get pods -w

Vos pods devraient maintenant télécharger les images depuis GHCR. : GitHub Container Registry 

Etape 4/10 : 14/10/2026 de 08:00-->11:30

Iac avec AWS : https://577211136035.signin.aws.amazon.com/console

Étape  					Dans le projet
Réseau (VPC, Subnets)			network.tf : VPC, 2 sous-réseaux publics (ALB et tâches), 2 sous-réseaux privés (base de données)
Sécurité (Security Groups)		security.tf : Internet → ALB → tâches ECS → RDS, chaque maillon n’accepte que le précédent
Compute					ecs.tf : ECS Fargate, avec les images dans ECR (ecr.tf)
Base de données				rds.tf : PostgreSQL 17 géré par AWS, mot de passe généré et stocké dans Secrets Manager
Entrée publique				alb.tf : load balancer HTTP vers le frontend Nginx

J’ai choisi ECS plutôt qu’EC2 ou EKS : c’est le plus simple.

Initialisation, planification, création
cd terraform
aws configure                      # clés d'un utilisateur IAM
terraform init
terraform validate
terraform plan -out tfplan
terraform apply tfplan


Le premier apply crée tout avec 0 tâche : les images n’existent pas encore dans ECR. 
Ensuite :

## . Pousser les images dans ECR
Depuis le dossier terraform/ :

REGION=$(echo $BACK | cut -d. -f4)        # us-east-1 chez vous

    REGION=us-east-1
    BACK=$(terraform output -raw ecr_backend_url)
    FRONT=$(terraform output -raw ecr_frontend_url)
    
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${BACK%%/*}
    
    docker build -t $BACK:latest  ../backend  && docker push $BACK:latest
    docker build -t $FRONT:latest ../frontend && docker push $FRONT:latest
    
    
## . Demarrer l'application
    terraform apply -var desired_count=1
    terraform output app_url        # ouvrir cette URL publique de l'application
    
    http://personnes-alb-1488586856.us-east-1.elb.amazonaws.com
    
correction Frontend: 
cd terraform
FRONT=$(terraform output -raw ecr_frontend_url)
docker build -t $FRONT:latest ../frontend && docker push $FRONT:latest
aws ecs update-service --cluster personnes --service frontend --force-new-deployment --region us-east-1


La base se trouve dans les sous-réseaux personnes-private-0 et personnes-private-1. 
Ils sont rattachés à la table de routage principale, qui ne contient que la route locale du VPC, sans passerelle Internet. 
Les sous-réseaux publics passent par personnes-public-rt et personnes-igw. 
Résultat : la base est invisible depuis Internet, et seul le Security Group des tâches ECS peut la contacter sur le port 5432.

Interroger la base directement
La base étant privée, DBeaver ou psql depuis votre PC ne peuvent pas s’y connecter. 
Les solutions possibles :
- Passer par l’application : c’est ce que vous faites déjà, et c’est suffisant pour ce cours.
- ECS Exec ou un hôte temporaire (bastion) dans le VPC : possible, mais cela demande une configuration supplémentaire.
- RDS Query Editor : non disponible pour RDS PostgreSQL classique.


cd terraform
terraform destroy -var desired_count=0

Cela supprime tout, y compris la base et ses données. Vous pourrez tout recréer en quelques minutes avec terraform apply.


Choix à connaître
Pas de NAT Gateway : cela économise environ 32 $/mois.
Les tâches ont une IP publique, mais leur Security Group n’accepte que le load balancer.
La base reste privée.
Service Connect : le frontend joint le backend sous le nom backend:8080, comme dans Docker Compose et Kubernetes. Le nginx.conf ne change donc pas.
Région : eu-west-3 (Paris), modifiable dans variables.tf.
Coûts : l’ALB et RDS sont facturés à l’heure. Faites terraform destroy -var desired_count=0 quand vous avez fini de vous entraîner.
Mot de passe : il apparaît dans le fichier d’état terraform.tfstate, qui ne doit pas être commité (le .gitignore fourni l’exclut).

## Etape 5/10 : 14/10/2026 de 11:30---> 12:45
chart Helm :
Le chart reprend les manifestes de k8s/ sous forme de templates : le Secret PostgreSQL, le PVC, les Deployments et Services de PostgreSQL, du backend et du frontend, puis l’Ingress. 
Tout se règle dans values.yaml.

---------------------------------------------------------------------------------------------------------------------

Installation
# 1. Vérifier le chart
helm lint helm/personnes
helm template personnes helm/personnes -n personnes | less

# 2. Si vous aviez déployé k8s/ avec kubectl, le retirer d'abord
kubectl delete -k k8s

# 3. Installer (images locales déjà chargées dans minikube/kind)
helm upgrade --install personnes ./helm/personnes \
  -n personnes --create-namespace \
  --set postgres.auth.password='bassem!!!2026'

kubectl -n personnes get pods -w

L’application est ensuite sur http://personnes.local
avec <minikube ip> personnes.local ajouté à /etc/hosts. 
Sans Ingress, utilisez kubectl -n personnes port-forward svc/frontend 3000:80.

Avec les images publiées par la CI (GHCR):

helm upgrade --install personnes ./helm/personnes -n personnes --create-namespace \
  --set backend.image.repository=ghcr.io/bassembenabbes/personnes-backend \
  --set backend.image.tag=latest \
  --set frontend.image.repository=ghcr.io/bassembenabbes/personnes-frontend \
  --set frontend.image.tag=latest \
  --set postgres.auth.password='bassem!!!2026'

---------------------------------------------------------------------------------------------------------------------
Si les images sont privées, créez un secret ghcr-pull et ajoutez --set 'imagePullSecrets[0].name=ghcr-pull'.

Ce qui change par rapport à k8s/
Mot de passe : il se passe en paramètre (--set) ou via un secret existant (postgres.auth.existingSecret). Il n’est plus écrit en dur dans un fichier commité.
Redéploiement automatique : un changement de secret redémarre le backend et PostgreSQL, grâce à une annotation checksum.
Base externe : avec postgres.enabled=false et externalDatabase.url=jdbc:..., le chart n’installe plus PostgreSQL.
Ingress : le TLS, l’hôte et les annotations sont réglables.

Limite à connaître

Les services s’appellent toujours backend, frontend et postgres, car nginx.conf relaie /api vers http://backend:8080.
Il faut donc une seule release par namespace. 
Pour plusieurs environnements (dev, prod), utilisez un namespace par environnement.


## Etape 6/10 : 14/10/2026 de 13:00 -->
Suite du plan
Il reste deux parties :

A- CI/CD vers AWS : GitHub Actions construit les images, les pousse (build et push des images) dans ECR, puis déploiement sur ECS avec GitHub Actions (met à jour les services ECS).
 Plus besoin de docker build, docker push et aws ecs update-service à la main.
 ------------------------------------
 terraform/oidc.tf donne à GitHub le droit de déployer sur AWS.
.github/workflows/ci.yml remplace votre ancien ci.yml

# Fonctionnement
Sur un push vers main, le pipeline enchaîne :
1- Tests : les tests backend (unitaires et Testcontainers), le build du frontend et le lint Helm, en parallèle.
2- Images : build du backend et du frontend, puis push dans ECR avec deux tags : latest et le hash du commit (github.sha), pour savoir quelle version tourne.
3- Déploiement : mise à jour des services ECS, attente qu’ils soient stables, puis affichage de l’URL dans le résumé du job.
Sur une pull request, seuls les tests et le build s’exécutent : ni push ni déploiement.

# Sécurité : OIDC, pas de clés AWS
Aucune clé AWS n’est stockée dans GitHub. 
Le workflow demande à AWS un accès temporaire, et le rôle IAM personnes-github-deploy n’accepte que la branche main de votre dépôt. 
Ses droits se limitent à pousser dans vos 2 dépôts ECR et à redéployer vos 2 services ECS.

# Mise en place
# 1. Terraform. Créez ou complétez terraform/terraform.tfvars (déjà exclu de Git) :
cd terraform
nano terraform.tfvars
:
region        = "us-east-1"
desired_count = 1
github_repo = "bassembenabbes/FullStackDevOpsProject"

cd terraform

terraform init
terraform plan
terraform apply
terraform output github_role_arn

terraform output app_url  

Mettez bien desired_count = 1 dans ce fichier : sans lui, un terraform apply remet les services à 0 tâche et coupe l’application. 
Si Terraform répond EntityAlreadyExists pour le fournisseur OIDC, ajoutez create_github_oidc_provider = false dans le fichier.

Erreur possible

EntityAlreadyExists sur aws_iam_openid_connect_provider signifie qu’un fournisseur GitHub existe déjà dans votre compte AWS. Ajoutez dans terraform.tfvars :
create_github_oidc_provider = false


# 2. Secret GitHub. 
Dans le dépôt, allez dans Settings → Secrets and variables → Actions → New repository secret. 
Créez AWS_ROLE_ARN avec la valeur de github_role_arn.

# 3. Premier déploiement.
git add .github terraform/oidc.tf
git commit -m "ci: build, push ECR et déploiement ECS"
git push origin main

# 4. Test. 
Modifiez un texte de l’interface (par exemple le titre « Personnes » dans App.jsx), 
poussez, puis rechargez l’URL de l’ALB après la fin du pipeline.

terraform destroy

# À savoir
- Région et noms : le workflow suppose us-east-1 (celle de votre console), le cluster personnes et le load balancer personnes-alb. Modifiez le bloc env: en haut du fichier si besoin.
- Tag latest : les task definitions restent gérées par Terraform et pointent vers :latest, et la CI force un redéploiement. Cela évite que Terraform et la CI se contredisent. Pour de la production, on utiliserait des tags immuables avec une nouvelle révision de task definition à chaque déploiement.
- GHCR : l’ancien job qui poussait vers GHCR a disparu. Les images vont maintenant uniquement dans ECR, ce qui est ce dont ECS a besoin.
- Échec : si un déploiement ne devient jamais sain, le job échoue après environ 10 minutes. Consultez alors les logs CloudWatch /ecs/personnes-backend et /ecs/personnes-frontend.

 ------------------------------------

B- Validation locale avec Minikube : un job CI qui installe votre chart Helm sur un Minikube temporaire et vérifie que l’application répond avant tout déploiement cloud.

C- EKS (option avancée) : il réutiliserait votre chart Helm.




Logs : CloudWatch, groupes `/ecs/personnes-backend` et `/ecs/personnes-frontend`.


