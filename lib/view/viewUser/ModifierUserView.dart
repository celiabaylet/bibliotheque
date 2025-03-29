import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'../../viewmodel/viewModelUser/UserViewModel.dart';
import'../../model/User.dart';

class ModifierUserView extends StatelessWidget {
  final User user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomUserController = TextEditingController();
  final TextEditingController _prenomUserController = TextEditingController();
  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _roleUserController = TextEditingController();

  ModifierUserView({super.key, required this.user}){
    //initialisation des controleurs avec les valeurs de l'utilisateur
    _nomUserController.text = user.nomUser;
    _prenomUserController.text = user.prenomUser;
    _loginUserController.text = user.loginUser; //utilisé pour le login
    _roleUserController.text = user.roleUser; //initialise le role
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'utilisateur', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller : _nomUserController,
                decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller : _prenomUserController,
                decoration: const InputDecoration(labelText: 'Prénom d\'utilisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom d\'utilisateur';
                  }
                  return null;
                },
              ),

              const SizedBox(height:16),
              TextFormField(
                controller : _loginUserController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un login';
                  }
                  return null;
                },
              ),
              const SizedBox(height:16),
              //menu deroulant pour le role
              DropdownButtonFormField<String>(
                value: user.roleUser,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const[
                  DropdownMenuItem(value:'admin', child: Text('Admin')),
                  DropdownMenuItem(value:'user', child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _roleUserController.text = value; //mettre a jour le role
                  }
                  return null;
                },
              ),
              const SizedBox(height:20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //mettre a jour le l'utilisateur via le viewmodel
                    Provider.of<UserViewModel>(context, listen: false)
                        .mettreAJourUser(
                        idUser: user.idUser,
                        nomUser: _nomUserController.text,
                        prenomUser: _prenomUserController.text,
                        loginUser: _loginUserController.text,
                        mdpUser: '', //ne pas passer de mot de passe
                        roleUser: _roleUserController.text,
                    );
                    Navigator.pop(context); //revenir a la liste des utilisateurs
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Mettre à jour', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
