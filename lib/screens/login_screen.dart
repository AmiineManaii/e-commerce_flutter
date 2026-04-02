import 'package:e_commerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool success = false;

    if (_isLogin) {
      success = await userProvider.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        password: _passwordController.text,
        adresse: _adresseController.text,
      );
      success = await userProvider.register(newUser);
    }

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isLogin ? 'Échec de la connexion' : 'Échec de l\'inscription')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Connexion' : 'Inscription')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isLogin) ...[
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _adresseController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              userProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
                    ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Pas de compte ? S\'inscrire' : 'Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
