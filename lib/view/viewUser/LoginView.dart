import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodel/viewModelUser/UserViewModel.dart';
import'../../HomeScreen.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade400,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Tentative de connexion
                String? errorMessage = await userViewModel.login(
                  _loginController.text.trim(),
                  _passwordController.text.trim(),
                );

                // Gestion des erreurs de connexion
                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Récupération des informations utilisateur
                  final String userName = userViewModel.userName;
                  final String userRole = userViewModel.userRole;

                  // Navigation vers HomeScreen avec les informations utilisateur
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        userName: userName,
                        userRole: userRole,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
