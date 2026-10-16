# Gestion des personnes

Créer une présentation correspondant à la cretion de projet Full Stack React Sprong Boot JAva & DevOps avec K8s & AWS

## 1. Vue d’ensemble

Cette application est une solution de gestion de catalogue de personnes, conçue comme un projet complet de développement logiciel et d’architecture DevOps. Elle permet de créer, consulter, modifier et supprimer des enregistrements dans une base de données relationnelle, via une interface web moderne et une API REST robuste.

Le projet illustre un cycle de vie complet :
- développement applicatif,
- conteneurisation,
- orchestration Kubernetes,
- déploiement cloud sur AWS,
- surveillance applicative,
- automatisation CI/CD avec GitHub Actions,
- infrastructure as code avec Terraform.

### Valeur métier

Dans un contexte réel, cette application peut servir à :
- gérer un annuaire de clients, employés, partenaires ou contacts,
- centraliser les informations de base dans une source unique,
- réduire les erreurs de saisie grâce à des validations métier,
- offrir un accès simple et fiable à l’information via une interface ergonomique.

### Objectif fonctionnel

L’application permet de gérer des personnes avec les règles métier suivantes :
- chaque personne a un code unique,
- chaque personne a un nom obligatoire,
- le CIN est obligatoire et doit contenir exactement 8 chiffres,
- un code ou un CIN déjà existant est rejeté,
- la recherche permet de filtrer rapidement les personnes par code, nom ou CIN.

---

## 2. Architecture du projet

### Vue logique

L’application repose sur une architecture standard 3-tiers :

1. Couche Frontend
   - React + Vite
   - Interface utilisateur pour gérer les personnes
   - Consommation de l’API backend

2. Couche Backend
   - Spring Boot 3.5
   - Java 17
   - API REST expose les services CRUD
   - Validation des données et gestion des erreurs métier

3. Couche Persistante
   - PostgreSQL 17
   - Stockage des données de l’application

### Vue technique

```text
Client navigateur
       |
       v
Frontend (React + Vite)
       |
       | HTTP /api/personnes
       v
Backend (Spring Boot)
       |
       | JPA / JDBC
       v
PostgreSQL
```

### Composants du projet

- Frontend : interface web pour la gestion des personnes
- Backend : API REST sécurisée et validée
- PostgreSQL : base de données relationnelle
- Prometheus : collecte des métriques applicatives
- Grafana : visualisation des métriques et indicateurs de santé
- Terraform : provisioning de l’infrastructure AWS
- Helm : déploiement sur Kubernetes
- GitHub Actions : automatisation du pipeline CI/CD

---

## 3. Stack technologique

### Frontend
- React 18
- Vite
- JavaScript / JSX
- NGINX pour le service web dans les environnements conteneurisés

### Backend
- Java 17
- Spring Boot 3.5
- Spring Web
- Spring Data JPA
- Spring Validation
- Spring Actuator
- Micrometer + Prometheus

### Base de données
- PostgreSQL 17
- Schéma généré automatiquement au démarrage

### Déploiement & orchestration
- Docker / Docker Compose
- Kubernetes
- Helm
- Terraform
- AWS ECS / ALB / RDS

### Surveillance
- Prometheus
- Grafana

### CI/CD
- GitHub Actions
- OIDC AWS pour accès sécurisé sans secrets stockés

---

## 4. Modèle de données

La table principale est la table `personne`.

### Structure

| Champ | Type | Rôle |
|---|---|---|
| code | String | Identifiant principal unique |
| name | String | Nom de la personne |
| cin | String | Carte d’identité, unique et format 8 chiffres |

### Règles métier

- `code` est obligatoire
- `name` est obligatoire
- `cin` est obligatoire et doit respecter le format `\d{8}`
- le `code` ne peut pas être dupliqué
- le `cin` ne peut pas être dupliqué
- une personne inexistante déclenche une erreur `404`
- un conflit métier déclenche une erreur `409`

---

## 5. API REST

### Base URL

- Local : `http://localhost:8080/api/personnes`
- Via le frontend NGINX : `http://localhost:3000/api/personnes`

### Endpoints

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/personnes` | Liste toutes les personnes |
| GET | `/api/personnes/{code}` | Récupère une personne par son code |
| POST | `/api/personnes` | Crée une personne |
| PUT | `/api/personnes/{code}` | Met à jour une personne |
| DELETE | `/api/personnes/{code}` | Supprime une personne |

### Exemple de payload

```json
{
  "code": "P0003",
  "name": "Ali",
  "cin": "92345678"
}
```

### Gestion des erreurs

Le backend retourne des réponses JSON lisibles pour les erreurs de validation et les conflits métier.

Exemples :

```json
{
  "message": "Données invalides",
  "fields": {
    "cin": "Le CIN doit contenir 8 chiffres"
  }
}
```

```json
{
  "message": "Ce CIN est déjà utilisé",
  "fields": {
    "cin": "Ce CIN est déjà utilisé"
  }
}
```

---

## 6. Fonctionnalités du front

L’interface React permet de :
- afficher la liste des personnes,
- filtrer les données par mot-clé,
- ajouter une personne,
- modifier une personne existante,
- supprimer une personne,
- recevoir des retours visuels via toasts et messages d’erreur,
- gérer les états de chargement et d’erreur.

---

## 7. Structure du dépôt

```text
FullStackDevOpsProject/
├── backend/                         # API Spring Boot
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
│       ├── main/java/com/example/personnes/
│       └── test/java/com/example/personnes/
├── frontend/                        # Application React + Vite
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   └── src/
├── helm/
│   └── personnes/                  # Chart Helm pour Kubernetes
├── k8s/                            # Manifests Kubernetes
├── monitoring/
│   ├── grafana/
│   └── prometheus/
├── terraform/                      # Infrastructure AWS (ECS, ALB, RDS, IAM)
├── docker-compose.yml              # Environnement local complet
├── README.md
├── .github/workflows/              # Pipelines CI/CD
└── ...
```

---

## 8. Démarrage local

### Prérequis

- Docker
- Docker Compose
- Java 17
- Maven
- Node.js 18+
- npm

### 1) Démarrer la base PostgreSQL

```bash
docker compose up -d db
```

### 2) Lancer le backend

```bash
cd backend
mvn spring-boot:run
```

L’API sera disponible sur :
- `http://localhost:8080`

### 3) Lancer le frontend

```bash
cd frontend
npm install
npm run dev
```

L’application web sera accessible sur :
- `http://localhost:5173`

### 4) Démarrer l’environnement complet avec Docker Compose

```bash
docker compose up --build
```

Cela démarre :
- PostgreSQL sur le port `5436`
- Backend sur le port `8080`
- Frontend sur le port `3000`
- Prometheus sur le port `9090`
- Grafana sur le port `3001`

### Vérification rapide

```bash
curl http://localhost:8080/actuator/health
```

---

## 9. Tests

Le backend contient des tests unitaires et d’intégration, notamment avec Testcontainers pour PostgreSQL.

```bash
cd backend
mvn verify
```

### Ce que couvre la validation
- validation des règles métier,
- intégration Spring Data JPA,
- tests du comportement HTTP,
- vérification du bon comportement avec une base PostgreSQL isolée.

---

## 10. Monitoring local

Le projet intègre une stack de monitoring en local pour suivre la santé du backend et la performance des services.

### Services exposés

- Prometheus : `http://localhost:9090`
- Grafana : `http://localhost:3001`
- Spring Boot metrics : `http://localhost:8080/actuator/prometheus`

### Identifiants Grafana

- Utilisateur : `admin`
- Mot de passe : `admin`

### Lancement du monitoring

```bash
docker compose up -d db backend frontend prometheus grafana
```

### Objectif du monitoring

- suivre la disponibilité du backend,
- surveiller le taux de requêtes,
- mesurer les latences,
- observer les ressources CPU et mémoire,
- avoir un aperçu de l’état applicatif en temps réel.

---

## 11. Déploiement Kubernetes avec Helm

Le projet est prêt pour un déploiement sur Kubernetes via Helm.

### Vérification du chart

```bash
helm lint helm/personnes
helm template personnes helm/personnes -n personnes
```

### Installation

```bash
helm upgrade --install personnes ./helm/personnes \
  -n personnes --create-namespace \
  --set postgres.auth.password='bassem!!!2026'
```

### Vérification des pods

```bash
kubectl -n personnes get pods -w
```

### Accès local via Minikube

```bash
minikube start
minikube addons enable ingress
MINIKUBE_IP=$(minikube ip)
echo "$MINIKUBE_IP personnes.local" | sudo tee -a /etc/hosts
```

Ensuite :
- Frontend : `http://personnes.local`
- Monitoring : port-forward vers `svc/prometheus` et `svc/grafana`

### Port-forward utile

```bash
kubectl -n personnes port-forward svc/prometheus 9090:9090
kubectl -n personnes port-forward svc/grafana 3001:3000
```

---

## 12. Déploiement AWS avec Terraform

Le projet est également préparé pour un déploiement sur AWS, avec une infrastructure IaC complète.

### Composants AWS provisionnés

- VPC
- Sous-réseaux publics et privés
- Security Groups
- ALB (Application Load Balancer)
- ECS Fargate
- ECR pour les images backend/frontend
- RDS PostgreSQL
- IAM / OIDC pour GitHub Actions

### Commandes principales

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

### Pousser les images dans ECR

```bash
REGION=us-east-1
BACK=$(terraform output -raw ecr_backend_url)
FRONT=$(terraform output -raw ecr_frontend_url)

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${BACK%%/*}

docker build -t $BACK:latest ../backend && docker push $BACK:latest
docker build -t $FRONT:latest ../frontend && docker push $FRONT:latest
```

### Démarrer l’application

```bash
terraform apply -var desired_count=1
terraform output app_url
```

---

## 13. CI/CD avec GitHub Actions

Le projet est conçu pour un pipeline de livraison automatisé.

### Workflow principal

Sur push vers la branche principale :
1. exécution des tests backend,
2. validation du build frontend,
3. construction des images Docker,
4. push des images vers ECR,
5. mise à jour des services ECS,
6. vérification de la santé des services.

### Sécurité

Le pipeline utilise OIDC AWS plutôt que des clés AWS stockées dans GitHub.
Cela permet :
- d’éviter la gestion de secrets long terme,
- de limiter les permissions au strict nécessaire,
- de sécuriser le déploiement automatisé.

### Exemple de procédure

```bash
cd terraform
terraform output github_role_arn
```

Puis créer un secret GitHub `AWS_ROLE_ARN` dans le dépôt. Le workflow utilise ensuite ce rôle pour se connecter à AWS et déployer les images.

---

## 14. Sécurité et bonnes pratiques

Le projet applique plusieurs bonnes pratiques :
- validation strict des entrées API,
- règles métier sur le code et le CIN,
- gestion des erreurs métier explicites,
- séparation des responsabilités entre frontend, backend et base données,
- utilisation d’images conteneurisées pour les environnements,
- IaC avec Terraform pour la reproductibilité,
- secrets et accès gérés de manière sécurisée,
- monitoring pour la supervision et la detection rapide des incidents.

---

## 15. Analyse métier / valeur de l’application

Cette application représente un exemple concret d’outil de gestion d’informations de référence, typique dans un environnement d’entreprise.

### Cas d’usage métier
- ajouter un contact ou un employé,
- mettre à jour son dossier,
- vérifier l’unicité des identifiants,
- sécuriser la saisie des informations,
- garantir l’intégrité des données,
- simplifier les opérations administratives quotidiennes.

### Bénéfices attendus
- meilleure traçabilité des données,
- gain de temps pour l’équipe opérationnelle,
- réduction des erreurs manuelles,
- meilleure évolutivité,
- alignement sur des pratiques de développement modernes et de production industrialisée.

---

## 16. État actuel du projet

Le projet est fonctionnel en local, avec :
- backend Spring Boot opérationnel,
- frontend React fonctionnel,
- PostgreSQL prêt à l’emploi,
- Docker Compose fonctionnel,
- monitoring local intégré,
- Helm disponible pour Kubernetes,
- Terraform prêt pour la partie cloud AWS,
- GitHub Actions en place pour l’automatisation.

Cette structure permet de présenter le projet comme un exemple complet de solution applicative moderne, allant du développement jusqu’au déploiement opérateur.

---

## 17. Commandes utiles

### Local

```bash
docker compose up -d db backend frontend prometheus grafana
cd backend && mvn verify
cd frontend && npm install && npm run dev
```

### Kubernetes

```bash
helm lint helm/personnes
helm upgrade --install personnes ./helm/personnes -n personnes --create-namespace --set postgres.auth.password='bassem!!!2026'
kubectl -n personnes get pods -w
```

### AWS

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Monitoring

```bash
kubectl -n personnes port-forward svc/prometheus 9090:9090
kubectl -n personnes port-forward svc/grafana 3001:3000
```

---

## 18. Conclusion

Ce projet est bien plus qu’une simple application CRUD : c’est une démonstration complète d’une architecture moderne de développement et d’exploitation applicative. Il montre comment construire une solution solide, fiable et scalable, tout en mettant l’accent sur la qualité logicielle, la sécurité, l’automatisation et la supervision.

Il constitue un excellent support de présentation technique et métier, car il couvre à la fois :
- la logique applicative,
- la conception d’architecture,
- la sécurité,
- le déploiement,
- l’exploitation,
- le parcours de livraison continue.

---

## 19. Référence rapide

### URLs locales
- Frontend : `http://localhost:5173`
- Backend : `http://localhost:8080`
- Prometheus : `http://localhost:9090`
- Grafana : `http://localhost:3001`

### Accès au système
- Backend API : `/api/personnes`
- Health check : `/actuator/health`
- Metrics Prometheus : `/actuator/prometheus`
