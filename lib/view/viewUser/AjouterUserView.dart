import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'../../viewmodel/viewModelUser/UserViewModel.dart';


class AjouterUserView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _mdpUserController = TextEditingController();

  //liste des roles avec seulement 'Administrateur' et 'Utilisateur'
  final List<String> _roles = ['admin', 'user'];

  String? _selectedRole;

  AjouterUserView({super.key}); //champ qui stocke le role selectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Utilisateur',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        //permet le defilement du contenu si necessaire
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomUserController,
                    decoration:
                    const InputDecoration(labelText: 'Nom de l\'utilisateur'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _prenomUserController,
                    decoration: const InputDecoration(labelText: 'Prénom de l\'utilisateur'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un prénom d\'utilisateur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _loginUserController,
                    decoration: const InputDecoration(labelText: 'Login'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un login';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mdpUserController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                  ),
                  //menu deroulant pour le role
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Rôle'),
                    value: _selectedRole, // Le rôle sélectionné actuellement
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role, // Utiliser le rôle comme valeur
                        child: Text(role), // Afficher le rôle
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _selectedRole = newValue; // Mettre à jour le rôle sélectionné
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un rôle';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Ajouter un utilisateur via le viewmodel
                        Provider.of<UserViewModel>(context, listen: false)
                            .ajouterUser(
                          nomUser: _nomUserController.text,
                          prenomUser: _prenomUserController.text,
                          loginUser: _loginUserController.text,
                          mdpUser: _mdpUserController.text,
                          roleUser:
                          _selectedRole  ?? '', //utiliser le role selectionner
                        );
                        Navigator.pop(
                            context); //revenir a la liste des utilisateurs
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Ajouter l\'utilisateur',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
