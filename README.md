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



         
         
  
  
