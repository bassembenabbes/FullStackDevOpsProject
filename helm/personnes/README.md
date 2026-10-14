# Chart Helm — personnes

## Installer
    helm upgrade --install personnes ./helm/personnes \
      -n personnes --create-namespace \
      --set postgres.auth.password='MotDePasseSolide'

(Si vous avez déjà déployé `k8s/` avec kubectl : `kubectl delete -k k8s` d'abord.)

Images locales (minikube / kind) : construire puis charger les images, comme pour `k8s/`.
Images GHCR : 
    --set backend.image.repository=ghcr.io/COMPTE/personnes-backend --set backend.image.tag=sha-xxxxxxx \
    --set frontend.image.repository=ghcr.io/COMPTE/personnes-frontend --set frontend.image.tag=sha-xxxxxxx

## Vérifier / mettre à jour / supprimer
    helm lint helm/personnes
    helm template personnes helm/personnes -n personnes     # voir le YAML généré
    helm -n personnes list
    helm -n personnes rollback personnes 1
    helm -n personnes uninstall personnes                   # le PVC est supprimé aussi : sauvegardez avant

## Paramètres principaux (values.yaml)
| Clé | Défaut | Rôle |
|---|---|---|
| backend.image.repository / tag | personnes-backend / latest | image du backend |
| frontend.image.repository / tag | personnes-frontend / latest | image du frontend |
| frontend.replicaCount | 2 | réplicas Nginx |
| postgres.enabled | true | false = base externe (`externalDatabase.url`) |
| postgres.auth.password | change-me | mot de passe (ou `existingSecret`) |
| postgres.persistence.size | 1Gi | taille du volume |
| ingress.host / className / tls.enabled | personnes.local / nginx / false | exposition |
