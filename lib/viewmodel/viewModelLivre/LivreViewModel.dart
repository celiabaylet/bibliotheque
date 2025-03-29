import 'package:flutter/material.dart';
import '../../model/Livre.dart';
import '../../repository/LivreDatabase.dart';
import'../../model/User.dart';



class LivreViewModel with ChangeNotifier {
 //seulement l'admin peut ajouter, modifier ou supprimer un livre


  final LivreDatabase _livreDb = LivreDatabase();
  List<Livre> _livres = [];

  List<Livre> get livres => _livres;


  Future<void> chargerLivres() async {
    print("Récupération des livres...");

    final livresMap = await _livreDb.obtenirTousLesLivres();
    print("Livres récupérés: $livresMap");

    // Utiliser Future.wait pour récupérer les livres et les auteurs
    final List<Livre?> livres = await Future.wait(
        livresMap.map((livreMap) async {
          final auteur = await _livreDb.obtenirAuteurParId(
              livreMap['idAuteur']);

          // Vérifiez si l'auteur a été trouvé
          if (auteur == null) {
            print("Auteur non trouvé pour l'ID: ${livreMap['idAuteur']}");
            return null; // Retournez null si l'auteur n'est pas trouvé
          } else {
            print("Auteur trouvé: ${auteur.nomAuteur}");
            return Livre.fromMap(
                livreMap, auteur); // Créer le livre avec l'auteur trouvé
          }
        })
    );
    _livres = livres.where((livre) => livre != null).cast<Livre>().toList();
    notifyListeners();
  }

    //Ajouter un nouveau livre
    void ajouterLivre(String nomLivre, int idAuteur, String jacketPath) async {
      await _livreDb.ajouterLivre(nomLivre, idAuteur, jacketPath);
      await chargerLivres(); //Recharger les livres après ajout
    }

    //Mettre à jour un livre existant
    void mettreAJourLivre(int idLivre, String nomAuteur, int idAuteur, String jacketPath) async {
      await _livreDb.mettreAJourLivre(idLivre, nomAuteur, idAuteur, jacketPath);
      await chargerLivres(); //Recharger les livres après modification
    }

    //Supprimer un livre
    void supprimerLivre(int idLivre) async {
      await _livreDb.supprimerLivre(idLivre);
      await chargerLivres(); //Recharger les livres après suppression
    }
  }