# 📊 GameMart - État d'Avancement du Projet

Ce document sert de journal de bord pour le développement de GameMart. Il permet de visualiser rapidement ce qui a été accompli et ce qui reste à faire.

## ✅ Travail Terminé
- [x] **Configuration JSON Server** : Mise en place du fichier `db.json` avec les modèles de données complets.
- [x] **Hébergement API** : Déploiement sur Render (`https://e-commerce-3qt8.onrender.com`).
- [x] **Architecture Flutter** :
  - [x] Installation des dépendances (`provider`, `http`, `cached_network_image`, `youtube_player_flutter`).
  - [x] Création de la structure des dossiers (`models`, `services`, `providers`, `screens`, `widgets`).
  - [x] Implémentation des modèles Dart (`Game`, `User`).
  - [x] Création du service API (`ApiService`).
  - [x] Gestion d'état avec `MultiProvider`.
- [x] **Interfaces Utilisateur** :
  - [x] **Page d'accueil** : Grille de jeux dynamique avec images et prix.
  - [x] **Détails du jeu** : Description, prix, notation et lecteur vidéo YouTube.
  - [x] **Panier** : Gestion des articles, calcul du total et suppression.
  - [x] **Authentification** : Écrans de Login/Register fonctionnels avec l'API.

## 🛠️ Travail à Réaliser (Optimisations)
- [ ] Persistance de la session utilisateur avec `shared_preferences`.
- [ ] Gestion des adresses de livraison dans le profil.
- [ ] Finalisation du processus de commande (Checkout) avec l'API.
- [ ] Amélioration du design (animations, thèmes personnalisés).

## 🕒 Prochaines Étapes Immédiates
1. Configurer les modèles Dart pour les jeux et les utilisateurs.
2. Créer le service de communication avec l'API Render.
3. Designer l'interface de la page d'accueil.
