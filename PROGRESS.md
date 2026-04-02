# 📊 GameMart - État d'Avancement du Projet

Ce document sert de journal de bord pour le développement de GameMart. Il permet de visualiser rapidement ce qui a été accompli et ce qui reste à faire.

## ✅ Travail Terminé
- [x] **Configuration JSON Server** : Mise en place du fichier `db.json` avec les modèles de données complets.
- [x] **Hébergement API** : Déploiement sur Render (`https://e-commerce-3qt8.onrender.com`).
- [x] **Architecture Flutter** :
  - [x] Installation des dépendances (`provider`, `http`, `cached_network_image`, `youtube_player_flutter`, `shared_preferences`).
  - [x] Création de la structure des dossiers complète.
  - [x] Implémentation des modèles Dart (`Game`, `User`, `Review`).
  - [x] Création du service API (`ApiService`) incluant les commandes et les avis.
  - [x] Gestion d'état avec `MultiProvider`.
  - [x] **Persistance** : Session utilisateur sauvegardée localement.
- [x] **Interfaces Utilisateur** :
  - [x] **Page d'accueil** : Grille de jeux, barre de recherche et filtres par catégorie.
  - [x] **Détails du jeu** : Description, prix, notation, lecteur vidéo YouTube et **avis des joueurs**.
  - [x] **Panier** : Gestion complète des quantités et processus de commande (Checkout).
  - [x] **Authentification** : Connexion et Inscription fonctionnelles.
  - [x] **Profil** : Écran dédié avec informations personnelles et **gestion de la Wishlist**.

## �️ Prochaines Étapes
L'application est maintenant complète selon les spécifications initiales. Pour aller plus loin :
- [ ] Ajouter la possibilité de poster un avis depuis l'application.
- [ ] Implémenter le mode sombre/clair automatique.
- [ ] Ajouter des animations de transition entre les pages.
