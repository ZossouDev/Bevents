# Bevent

Une plateforme de gestion d'événements et de billetterie développée comme projet de démonstration.

## Présentation

Bevent permet de consulter des événements et des espaces, puis de proposer des interfaces de gestion pour les organisateurs et les administrateurs.

## Fonctionnalités

- Consultation d'événements et d'espaces.
- Inscription et connexion d'organisateurs et d'administrateurs.
- Tableaux de bord organisateur et administrateur.
- Gestion d'événements, d'espaces et de profils.
- Téléversement d'images côté API.
- Structures prévues pour les commentaires, artistes, managers, tickets et paiements.

Certaines fonctionnalités sont partielles ou encore en développement.

## Architecture

- `frontend/` : application Flutter.
- `backend/` : API PHP utilisant MySQL/MariaDB via PDO.

## Technologies

- Flutter et Dart
- PHP
- PDO
- MySQL / MariaDB
- HTTP / API REST

## Installation

1. Installez Flutter et les dépendances requises par votre plateforme.
2. Dans `frontend/`, exécutez `flutter pub get`, puis `flutter run`.
3. Configurez un serveur PHP avec MySQL/MariaDB pour servir le dossier `backend/`.
4. Copiez `backend/include/config.example.php` vers `backend/include/config.php`, puis renseignez vos paramètres locaux.

La base de données de démonstration n'est pas fournie dans le dépôt public. Créez une base compatible avec les entités utilisées par l'API avant d'exécuter les fonctionnalités dépendantes du backend.

## Configuration API

Par défaut, le frontend utilise :

- `BEVENT_API_HOST=localhost`
- `BEVENT_API_ROOT=api_test`

Vous pouvez fournir une autre configuration au lancement :

```bash
flutter run --dart-define=BEVENT_API_HOST=api.example.com --dart-define=BEVENT_API_ROOT=bevent
```

## Structure

```text
bevent/
├── frontend/
├── backend/
├── .gitignore
└── README.md
```

## État du projet

Ce projet est présenté comme démonstration. Certaines parties, notamment les paiements et certaines intégrations, peuvent être incomplètes.

## Auteur

Fulgence ZOSSOU
