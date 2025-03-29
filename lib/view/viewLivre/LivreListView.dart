import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'../../viewmodel/viewModelLivre/LivreViewModel.dart';
import'AjouterLivreView.dart';
import'ModifierLivreView.dart';
import'../widget/ConfirmDeleteDialog.dart';
import'../widget/CustumCard.dart';


class LivreListView extends StatelessWidget {
  final String userName;
  final String userRole;

  const LivreListView({
    super.key,
    required this.userName,
    required this.userRole,
});

  @override
  Widget build(BuildContext context) {
    //Charger la liste des livres lorsque la vue est construite
    Provider.of<LivreViewModel>(context, listen: false).chargerLivres();

    print("userName: $userName");
    print(userRole);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Liste des Livres', style: TextStyle(color: Colors.white)
        ),
        actions: [
          if (userRole == 'admin')
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              //Ouvrir l'ecran pour ajouter un livre
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterLivreView(userName: userName, userRole: userRole)),
              ).then((_) {
                //Recharger la liste des livres après ajout
                Provider.of<LivreViewModel>(context, listen: false).chargerLivres();
              }
              );
            },
          ),
        ],
      ),
      body: Consumer<LivreViewModel>(
        builder: (context, livreViewModel, child) {
          if (livreViewModel.livres.isEmpty) {
            return Center(
              child: Text('Aucun livre trouvé'));
          }
          return ListView.builder(
            itemCount: livreViewModel.livres.length,
            itemBuilder: (context, index) {
              final livre = livreViewModel.livres[index];
              //afficher les livres dans la console
              return CustomCard(
                title: livre.nomLivre,
                subtitle: livre.auteur.nomAuteur,
                jacketPath: livre.jacketPath,
                displayJacket: true,
                userRole: userRole,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierLivreView(livre: livre),
                    ),
                  ).then((_) {
                    //Recharger la liste des livres après modification
                    Provider.of<LivreViewModel>(context, listen: false).chargerLivres();
                  });
                },
                onDelete: () {
                  showDialog(
                    context: context,
                          builder: (context) => ConfirmDeleteDialog(
                            title: 'Supprimer le livre',
                            content: 'Voulez-vous vraiment supprimer ce livre ?',
                            onConfirm: () {
                              //action pour supprimer le livre
                              Provider.of<LivreViewModel>(context, listen: false).supprimerLivre(livre.idLivre!);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
