 1 — Titre

Gestion des Personnes

Application de gestion de données métier avec architecture moderne et DevOps.

Ce projet est une application de gestion des personnes développée avec une architecture moderne et professionnelle. Elle permet de créer, consulter, modifier et supprimer des personnes via une interface web simple et une API REST fiable.

Du côté technique, le projet repose sur React pour le front-end, Spring Boot pour le back-end et PostgreSQL pour la base de données. J’ai également mis en place la conteneurisation avec Docker, le déploiement sur Kubernetes avec Helm et l’infrastructure cloud sur AWS avec Terraform.

Le projet intègre aussi des éléments essentiels de qualité et d’exploitation : tests unitaires et d’intégration, surveillance avec Prometheus et Grafana, ainsi qu’un pipeline CI/CD avec GitHub Actions pour automatiser les builds, les tests et le déploiement.

L’intérêt du projet est qu’il montre un vrai cycle de vie logiciel complet : du développement jusqu’au déploiement, en passant par la sécurité, l’automatisation et la supervision. Il s’agit d’une solution réaliste, professionnelle et facilement extensible pour gérer un annuaire ou des données de référence dans une entreprise.


---

 2 — Problème métier

Les entreprises doivent gérer des informations importantes sur leurs personnes : collaborateurs, clients, partenaires, contacts.

Les problèmes fréquents :
- duplication des données,
- erreurs de saisie,
- données incomplètes,
- difficulté d’accès et de mise à jour.

---

 3 — Solution proposée

Développement d’une application web permettant de :
- ajouter une personne,
- modifier une personne,
- supprimer une personne,
- consulter les informations existantes,
- rechercher rapidement une personne.

---

 4 — Architecture applicative

Frontend : React + Vite
Backend : Java 17 + Spring Boot
Base de données : PostgreSQL

Interaction :
- interface utilisateur,
- API REST,
- stockage relationnel,
- validation des règles métier.

---

 5 — Règles métier

Les données doivent respecter des règles strictes :
- code unique,
- nom obligatoire,
- CIN obligatoire,
- format CIN valide (8 chiffres),
- interdiction des doublons,
- validation avant enregistrement.

Ces règles garantissent la qualité des données.

---

 6 — Stack technique

Technologies utilisées :
- React
- Spring Boot
- PostgreSQL
- Docker
- Kubernetes / Helm
- Terraform
- AWS
- Prometheus / Grafana
- GitHub Actions

---

 7 — Déploiement et automatisation

Le projet est prêt pour plusieurs environnements :
- local avec Docker Compose,
- Kubernetes avec Helm,
- AWS avec Terraform,
- pipeline CI/CD avec GitHub Actions.

Cela montre une vraie logique de livraison continue.

---

 8 — Monitoring et supervision

Le projet intègre une couche de supervision pour suivre l’état du système :
- disponibilité du backend,
- performance des services,
- charge et latence,
- ressources CPU et mémoire,
- visualisation via Grafana.

---

 9 — Valeur métier / business value

Bénéfices attendus :
- gain de temps,
- meilleure qualité des données,
- réduction des erreurs manuelles,
- meilleure organisation des informations,
- meilleure traçabilité et fiabilité.

---

 10 — Conclusion

Ce projet illustre une solution applicative moderne et complète :
- développement logiciel,
- architecture robuste,
- automatisation,
- sécurité,
- déploiement cloud,
- supervision applicative.

Il représente une vraie solution d’entreprise, alignée avec les pratiques DevOps actuelles.

# Version technique détaillée

## 1. Objectif du projet

Le projet a pour objectif de développer une application de gestion des personnes avec une architecture moderne, robuste et facilement déployable. Il couvre la création d’une application complète allant du développement local jusqu’à la mise en production dans des environnements cloud.

## 2. Architecture générale

Le système est structuré selon une architecture 3 tiers :

1. Couche Frontend
   - React + Vite
   - interface utilisateur pour la gestion des personnes
   - appel à l’API backend

2. Couche Backend
   - Spring Boot 3.5
   - Java 17
   - API REST pour les opérations CRUD
   - validation des données et gestion des erreurs métier

3. Couche Persistante
   - PostgreSQL 17
   - stockage et gestion des données relationnelles

### Vue technique

```text
Navigateur
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

## 3. Stack technologique

### Frontend
- React 18
- Vite
- JavaScript / JSX
- NGINX pour les environnements conteneurisés

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
- schéma généré automatiquement au démarrage

### Déploiement et orchestration
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
- OIDC AWS

## 4. Fonctionnalités applicatives

L’application permet de :
- lister les personnes,
- afficher le détail d’une personne,
- créer une personne,
- modifier une personne,
- supprimer une personne,
- filtrer les données par code, nom ou CIN,
- valider les entrées selon des règles strictes.

## 5. Règles métier

Les règles métier sont essentielles à la qualité des données :
- chaque personne a un code unique,
- le nom est obligatoire,
- le CIN est obligatoire,
- le CIN doit contenir exactement 8 chiffres,
- les doublons sont interdits,
- les erreurs de validation sont renvoyées avec des messages explicites,
- les conflits métier sont gérés par des codes HTTP adaptés.

## 6. API REST

### Endpoints principaux

| Méthode | Route | Description |
|---|---|---|
| GET | /api/personnes | Liste toutes les personnes |
| GET | /api/personnes/{code} | Détail d’une personne |
| POST | /api/personnes | Création |
| PUT | /api/personnes/{code} | Modification |
| DELETE | /api/personnes/{code} | Suppression |

### Exemple d’objet JSON

```json
{
  "code": "P0003",
  "name": "Ali",
  "cin": "92345678"
}
```

## 7. Qualité logicielle

Le projet intègre des tests backend pour sécuriser le développement :
- tests unitaires,
- tests d’intégration,
- validation des règles métier,
- vérification du bon comportement avec PostgreSQL via Testcontainers.

Cela permet d’assurer une bonne robustesse avant les déploiements et de limiter les régressions.

## 8. Conteneurisation et exécution locale

Le projet est préparé pour le développement local et la mise en service via Docker Compose.

### Services disponibles
- PostgreSQL
- Backend Spring Boot
- Frontend React
- Prometheus
- Grafana

### Commandes clés

```bash
docker compose up -d db backend frontend prometheus grafana
cd backend && mvn verify
cd frontend && npm install && npm run dev
```

## 9. Monitoring

Le projet intègre une stratégie de supervision avec :
- Prometheus pour collecter les métriques,
- Grafana pour visualiser les données,
- Spring Boot Actuator pour exposer les métriques applicatives.

### Points suivis
- disponibilité du backend,
- taux de requêtes,
- latence,
- usage CPU et mémoire,
- état global de l’application.

## 10. Kubernetes et Helm

Le projet est également prêt pour un déploiement sur Kubernetes via Helm.

### Objectifs
- déployer les services backend, frontend et base de données,
- exposer l’application via un Ingress,
- gérer les configurations en paramètres,
- faciliter la réplication sur plusieurs environnements.

### Commandes utiles

```bash
helm lint helm/personnes
helm upgrade --install personnes ./helm/personnes -n personnes --create-namespace --set postgres.auth.password='bassem!!!2026'
kubectl -n personnes get pods -w
```

## 11. Infrastructure cloud AWS

Le projet utilise Terraform pour provisionner une infrastructure de production sur AWS.

### Composants créés
- VPC
- sous-réseaux publics et privés
- Security Groups
- ALB
- ECS Fargate
- ECR
- RDS PostgreSQL
- IAM / OIDC

### Bénéfices
- infrastructure reproductible,
- déploiement automatisé,
- environnement cloud réaliste,
- meilleure préparation à des scénarios d’entreprise.

## 12. CI/CD

Le projet est pensé pour une automatisation complète via GitHub Actions.

### Pipeline principal
- lancement des tests backend,
- build du frontend,
- construction des images Docker,
- push dans ECR,
- mise à jour des services ECS,
- vérification de la santé des services.

### Sécurité
- OIDC AWS pour éviter les clés AWS stockées dans GitHub,
- permissions limités au strict nécessaire,
- déploiement plus sûr et reproductible.

## 13. Sécurité et bonnes pratiques

Le projet applique plusieurs bonnes pratiques :
- validation des entrées,
- gestion explicite des erreurs métier,
- séparation des responsabilités,
- conteneurisation,
- IaC avec Terraform,
- supervision avec Prometheus/Grafana,
- approches de déploiement sécurisées et automatisées.

## 14. Conclusion technique

Ce projet va au-delà d’une simple application CRUD. Il démontre une capacité à concevoir, développer, tester, sécuriser, surveiller et déployer une application moderne dans des environnements variés.

Il illustre parfaitement les compétences attendues dans un contexte de développement logiciel et DevOps : architecture, automatisation, qualité, observabilité et livraison continue.

# Gestion des personnes

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


