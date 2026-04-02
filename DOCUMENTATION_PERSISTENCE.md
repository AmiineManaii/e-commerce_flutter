# 💾 Documentation de Persistance avec SharedPreferences - GameMart

Ce document explique comment l'application GameMart gère la persistance des données locales pour assurer une expérience utilisateur fluide, notamment pour la gestion de la session.

## 1. Justification du Choix de SharedPreferences

Plusieurs alternatives existent pour le stockage local en Flutter :

- **SQLite** : Trop complexe pour stocker uniquement des données de session simples. Idéal pour de gros volumes de données structurées.
- **Hive** : Excellente performance, mais nécessite la génération de code (TypeAdapters).
- **Flutter Secure Storage** : Idéal pour les secrets (tokens JWT), mais un peu plus lent pour des données non sensibles.
- **SharedPreferences (Choisi)** :
    - **Simplicité** : API clé-valeur extrêmement simple.
    - **Légèreté** : Parfait pour stocker des préférences utilisateur ou des objets JSON sérialisés.
    - **Rapidité** : Chargement quasi instantané au démarrage de l'app.

---

## 2. Cartographie de l'utilisation

L'utilisation de la persistance est centralisée dans le **UserProvider** pour gérer l'état de connexion.

| Clé | Type de donnée | Usage |
| :--- | :--- | :--- |
| `user_data` | `String` (JSON) | Stocke l'objet `User` complet (ID, nom, email, adresse, wishlist). |

### Emplacements clés dans le code
- **Initialisation** : [user_provider.dart](file:///c:/Users/amine/OneDrive/Bureau/developpement%20android/Hybrid/e_commerce/lib/providers/user_provider.dart) (Méthode `_loadUser()`).
- **Écriture (Login/Register)** : Méthodes `login()` et `register()`.
- **Suppression (Logout)** : Méthode `logout()`.

---

## 3. Mécanisme d'Implémentation

### Cycle de Vie des Données
1. **Démarrage** : Le constructeur du `UserProvider` appelle `_loadUser()`.
2. **Lecture** : On vérifie si la clé `user_data` existe. Si oui, on désérialise le JSON vers l'objet `User`.
3. **Synchronisation** : Dès que l'utilisateur modifie ses favoris (Wishlist) ou se connecte, le stockage local est mis à jour pour refléter l'état actuel de l'API.

### Exemple de Code : Sauvegarde de Session
```dart
// Conversion de l'objet User en String JSON pour le stockage
final prefs = await SharedPreferences.getInstance();
prefs.setString('user_data', json.encode(_user!.toJson()));
```

### Exemple de Code : Chargement au Démarrage
```dart
Future<void> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user_data')) {
    final userData = json.decode(prefs.getString('user_data')!);
    _user = User.fromJson(userData); // Restauration de l'état
    notifyListeners();
  }
}
```

---

## 4. Gestion des Erreurs et Sécurité
- **Try/Catch** : Toutes les opérations de lecture/écriture sont sécurisées pour éviter que des données corrompues ne bloquent l'application.
- **Sérialisation JSON** : Nous utilisons le format JSON standard, ce qui facilite les futures migrations si nous passons à une base de données plus complexe.
- **Nettoyage** : Lors de la déconnexion (`logout`), la clé est explicitement supprimée via `prefs.remove('user_data')`.

---

## 5. Bonnes Pratiques
- **Async/Await** : Puisque `SharedPreferences` est asynchrone, toutes les méthodes d'accès sont marquées `async` pour ne pas bloquer le thread principal de l'UI.
- **Single Source of Truth** : Le Provider reste la source unique de vérité pendant que l'app tourne, `SharedPreferences` ne sert que de "miroir" pour le prochain démarrage.
