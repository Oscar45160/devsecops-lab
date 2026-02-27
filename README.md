# Projet Final : Pipeline DevSecOps automatisée
![Security](https://github.com/Oscar45160/devsecops-lab/actions/workflows/devsecops.yml/badge.svg)

Ce dépôt contient le projet final du TP "Pipeline DevSecOps avec GitHub Actions". L'objectif est de sécuriser une application Node.js vulnérable en implémentant une pipeline CI de sécurité, selon le principe du *Shift-Left*.

## Architecture de la Pipeline

La pipeline (`.github/workflows/devsecops.yml`) exécute les vérifications de sécurité suivantes à chaque commit (`push` ou `pull_request`) :

1. **Build** : Installation des dépendances et préparation de l'environnement Node.js.
2. **SAST (Semgrep)** : Analyse statique du code source à la recherche de faiblesses communes en JavaScript.
3. **SCA (npm audit)** : Recherche de vulnérabilités (CVEs) dans les dépendances de l'application (ex: failles dans `express`).
4. **Secret Scanning (Gitleaks)** : Détection de secrets exposés dans l'historique de code (mots de passe, clés API).
5. **Container Scan (Trivy)** : Scan de sécurité de l'image Docker générée (recherche de packages OS vulnérables et erreurs de configuration).
6. **CodeQL** : L'outil d'analyse structurelle avancé de GitHub intégré pour du SAST plus profond.
7. **Security Gate** : Etape finale bloquante qui valide le pipeline uniquement si aucune faille critique n'a été trouvée dans les étapes précédentes.

## Exigences respectées du TP

✅ **Application sécurisée** : Les failles ont été réparées, le secret AWS test supprimé.
✅ **Dépendances à jour** : Les bibliothèques NPM sont sur leurs dernières versions sécurisées.
✅ **Dockerfile durci** : Utilisation d'une image Alpine propre, exécution sous l'utilisateur non-root `node`, et `apk upgrade`.
✅ **Workflow fonctionnel** : Tous les checks de sécurité passent désormais sans erreur.
✅ **Gestion des Secrets** : Le code récupère le secret via `process.env.API_KEY`, avec GitHub Actions configuré correctement.

## Documentation et Livrables

- Le compte-rendu des vulnérabilités initiales, corrections et métriques se trouve dans le fichier **[RAPPORT.md](./RAPPORT.md)**.
- Le fichier `travail_a_rendre1.pdf` a été ignoré via `.gitignore` comme demandé.
