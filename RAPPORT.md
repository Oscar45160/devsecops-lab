# Rapport de Sécurité DevSecOps

Ce rapport détaille l'état de la sécurité logicielle avant et après l'intégration de la pipeline DevSecOps sur le projet `devsecops-lab`.

---

## 1. Vulnérabilités Trouvées (État Initial)

Lors du premier sprint, une application JavaScript `server.js` vulnérable a été poussée avec un `Dockerfile` et un `package.json` obsolètes.
Le pipeline GitHub Actions a correctement détecté de multiples vulnérabilités lors du premier run :

### A. Secret Exposé (Gitleaks)
- **Vulnérabilité :** Un secret métier (une fausse `apiKey` de pattern type API Key AWS/Stripe) a été directement poussée en clair dans le code source de l'application `server.js`.
- **Détection :** Le job `secrets` avec `Gitleaks` a échoué (Exit code 1).

### B. Vulnérabilités de dépendances SCA (npm audit)
- **Vulnérabilité :** L'application a été initialisée avec une version spécifiquement obsolète : `express@4.17.1`.
- **Détection :** `npm audit` a remonté plusieurs vulnérabilités connues (CVE) associées à cette ancienne version de la bibliothèque (faille de déni de service (DoS), open redirect, etc.).

### C. Vulnérabilités de Conteneur (Trivy)
- **Vulnérabilité :** Le conteneur initial utilisait l'image de base `node:14`. Cette image est en End-of-Life (EOL), basée sur une ancienne Debian contenant des centaines de paquets OS vulnérables non patchés. De plus, elle s'exécutait en `root`.
- **Détection :** Le job `container-scan` avec `Trivy` a remonté des centaines de CVE de sévérité `CRITICAL` et `HIGH`.

---

## 2. Corrections Appliquées (État Final)

Pour chacune des vulnérabilités identifiées, les pratiques de sécurité ont été implémentées pour obtenir un pipeline totalement vert.

### A. Correction des Secrets
- L'API Key en dur a été supprimée de `server.js`.
- L'application récupère maintenant le secret via variable d'environnement dynamique : `process.env.API_KEY`.
- Un fichier d'exemple `.env.example` a été ajouté au repo, et `.env` a été inclus dans `.gitignore`.
- Les secrets doivent s'injecter via **GitHub Secrets**.

### B. Correction SCA
- Mise à jour du `package.json` de `express` vers la version sécurisée recommandée (`^4.21.1`).
- Mise à jour de toutes les arborescences avec package-lock.

### C. **Renforcement du Conteneur (Container Security) :**
    *   Utilisation d'une image de base Node.js plus récente et allégée (`node:20-alpine`).
    *   Mise en place d'un build **multi-stage** Docker pour ne copier que les fichiers nécessaires et **supprimer complètement npm** de l'image de production finale, éliminant ainsi les vulnérabilités résiduelles liées aux outils de build globaux (ex: minimatch dans npm).
    *   Application du principe de moindre privilège en exécutant l'application en tant qu'utilisateur non-root (`USER node`).
    *   Ajout du flag `--only=production` à l'installation NPM pour amoindrir la surface d'attaque et la taille de l'image.

---

## 3. Métriques de Sécurité

**Avant (Premier run vulnérable) :**
- **SCA (npm) :** ~14 vulns dont au moins 2 `HIGH`/`CRITICAL` (reliques d'express 4.17).
- **Secrets :** 1 `CRITICAL` (clé exposée).
- **Système (Trivy sur node:14) :** ~250+ vulnérabilités `HIGH`/`CRITICAL` (Debian vulnérable) + vulnérabilités du runtime Node.

**Après (Version Durcie actuelle) :**
- **SCA (npm) :** 0 vulnérabilité.
- **Secrets :** 0 vulnérabilité.
- **Système (Trivy sur node:20-alpine à jour) :** 0 vulnérabilité `CRITICAL`/`HIGH`.

---

## 4. Leçons Apprises

L'intégration de la sécurité *dès les premiers commits* (Shift-Left) offre d'immenses avantages :
1. **Feedback rapide** : Le développeur est alerté directement s'il a introduit un secret dans son PR, évitant de l'exposer en production.
2. **Standardisation :** L'usage strict d'un *Security Gate* automatisé empêche un conteneur non-conforme aux exigences de sécurité organisationnelles d'être déployé.
3. **Mise à jour en continu :** L'analyse SCA et les scans d'images de bases motivent l'utilisation d'environnements d'exécution sains avec une réduction significative de la surface d'attaque.
