import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import'AjouterAuteurView.dart';
import'ModifierAuteurView.dart';
import'../widget/ConfirmDeleteDialog.dart'; //importer confirmedeletedialog.dart

class AuteurListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const AuteurListView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    //Charger la liste des auteurs lorsque la vue est construite
    Provider.of<AuteurViewModel>(context, listen: false).chargerAuteurs();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Liste des Auteurs', style: TextStyle(color: Colors.white)
          ),
          actions: [
            if (userRole == 'admin')
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white), // Couleur de l'icône en blanc
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AjouterAuteurView()),
                  );
                },
              ),
          ],
        ),
        body: Consumer<AuteurViewModel>(
        builder: (context, auteurViewModel, child) {
          if(auteurViewModel.auteurs.isEmpty){
          return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
          itemCount: auteurViewModel.auteurs.length,
          itemBuilder: (context, index) {
        final auteur = auteurViewModel.auteurs[index];
        return ListTile(
          title: Text(auteur.nomAuteur),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userRole == 'admin')
                IconButton(
                  icon : Icon(Icons.edit),
                  onPressed: () {
                    //Ouvrir l'ecran pour modifier l'auteur
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModifierAuteurView(auteur: auteur),
                      ),
                    );
                  },
                ),
                if (userRole == 'admin')
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDeleteDialog(
                          title: 'Confirmer la suppression',
                          content: 'Etes vous sur de vouloir supprimer cet auteur?',
                              onConfirm: () {
                                Provider.of<AuteurViewModel>(context, listen: false)
                                  .supprimerAuteur(auteur.idAuteur!);
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}








