# 🎮 GameMart - Roadmap du Projet

Bienvenue dans le projet **GameMart**, une application e-commerce hybride dédiée aux jeux vidéo. Ce document détaille la vision globale du projet, son architecture et les étapes clés du développement.

## 🚀 Vision du Projet
GameMart vise à offrir une expérience d'achat fluide et immersive pour les passionnés de jeux vidéo. L'application permet d'explorer un catalogue varié, de consulter des avis détaillés et de gérer ses commandes en toute simplicité.

## 🏗️ Architecture Technique

### Backend (Déjà implémenté)
- **Outil** : `json-server`
- **Hébergement** : Render (`https://e-commerce-3qt8.onrender.com`)
- **Modèles de données** :
  - `games` : Catalogue des jeux (titre, prix, stock, trailer, etc.)
  - `users` : Profils utilisateurs et authentification
  - `addresses` : Adresses de livraison
  - `orders` : Historique des commandes
  - `cart` : Panier en temps réel
  - `reviews` : Avis et notes des jeux

### Frontend (En cours)
- **Framework** : Flutter (Hybrid)
- **Gestion d'état** : Provider (Simple & Efficace)
- **Navigation** : Flutter Navigator (Routes nommées ou Navigator simple)
- **Client API** : HTTP (Standard et facile à comprendre)

## 🗺️ Étapes de Développement

### Phase 1 : Fondations & API
- [x] Définition du schéma `db.json`.
- [x] Déploiement du serveur sur Render.
- [ ] Configuration de l'environnement Flutter.
- [ ] Création des modèles Dart pour chaque entité API.

### Phase 2 : Authentification & Profil
- [ ] Écran d'inscription (Sign Up).
- [ ] Écran de connexion (Login).
- [ ] Gestion du profil utilisateur (Nom, Prénom, Adresse).
- [ ] Gestion des adresses multiples.

### Phase 3 : Catalogue & Recherche
- [ ] Page d'accueil avec jeux populaires et promotions.
- [ ] Filtrage par genre (RPG, Aventure, etc.) et plateforme (PC, Console).
- [ ] Recherche textuelle.
- [ ] Page de détails d'un jeu (Images, Description, Trailer YouTube).

### Phase 4 : Panier & Commandes
- [ ] Gestion du panier (Ajout, Suppression, Quantité).
- [ ] Processus de commande (Checkout).
- [ ] Historique des commandes.
- [ ] Gestion des favoris (Wishlist).

### Phase 5 : Interaction Sociale
- [ ] Système d'avis et de notes.
- [ ] Affichage des avis vérifiés.

### Phase 6 : Optimisations & Polissage
- [ ] Mode sombre/clair.
- [ ] Notifications push.
- [ ] Animations fluides.
