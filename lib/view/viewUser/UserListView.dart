import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import'../widget/ConfirmDeleteDialog.dart';
import'../widget/CustumCard.dart';
import 'AjouterUserView.dart';
import 'ModifierUserView.dart';
import '../../HomeScreen.dart';

class UserListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const UserListView({super.key, required this.userName, required this.userRole});


  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    Future.microtask(() => userViewModel.chargerUtilisateurs());

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Utilisateurs', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blueGrey,
            iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen(userName: userName, userRole: userRole)),
              );
            },
        ),
        actions: userRole == 'admin'
            ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterUserView()),
              );
            },
          ),
        ]
          : [],
        ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.utilisateurs.isEmpty) {
            return const Center(
                child: Text('Aucun utilisateur disponible.'));
          }
          return ListView.builder(
            itemCount: userViewModel.utilisateurs.length,
            itemBuilder: (context, index) {
              final user = userViewModel.utilisateurs[index];

              return CustomCard(
                  title: '${user.nomUser} ${user.prenomUser}', //nom prenom de l'utilisateur
                  subtitle: user.loginUser, // login de l'utilisateur
                  userRole: userRole, //role de l'utilisateur actuel (admin ou non)
                  displayJacket: false, //pas de jacket pour les utilisateurs
                  jacketPath: '', //pas de jacket pour les utilisateurs//A REVOIR
                  onTap: () {
                    if (userRole == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModifierUserView(user: user)),
                      );
                    }
                  },
                  onDelete: () {
                    if (userRole == 'admin') {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDeleteDialog(
                          title: 'Confirmer la suppression',
                          content: 'Etes-vous sûr de vouloir supprimer cet utilisateur?',
                          onConfirm: () {
                            Provider.of<UserViewModel>(context, listen: false).supprimerUser(user.idUser);
                          },
                        ),
                      );
                    }
                  },
              );
            },
          );
        },
      ),
    );
  }
}

