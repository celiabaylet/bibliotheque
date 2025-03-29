import 'package:flutter/foundation.dart';
import'package:provider/provider.dart';
import '../../model/Auteur.dart';
import '../../repository/AuteurDatabase.dart';
import'../../repository/LivreDatabase.dart';
import'../../viewmodel/viewModelLivre/LivreViewModel.dart';


class AuteurViewModel with ChangeNotifier {

  final AuteurDatabase _auteurDb = AuteurDatabase();
  List<Auteur> _auteurs = [];
  List<Auteur> get auteurs => _auteurs;
  final LivreDatabase _livreDb = LivreDatabase();

  //Recuperer la liste des auteurs
  Future<void> chargerAuteurs() async {
    final List<Map<String, dynamic>> auteursMap = await _auteurDb.obtenirTousLesAuteurs();
    _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
    notifyListeners(); //Notifie la vue des changements
  }

  //Ajouter un nouvel auteur
  Future<void> ajouterAuteur(String nomAuteur) async {
    await _auteurDb.ajouterAuteur(nomAuteur);
    await chargerAuteurs(); //Recharger les auteurs après ajout
  }

  //Mettre à jour un auteur existant
  Future<void> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    await _auteurDb.mettreAJourAuteur(idAuteur, nomAuteur);
    await chargerAuteurs(); //Recharger les auteurs après modification
  }

  //Supprimer un auteur
  //methode pour supprimer un auteur
  Future<void> supprimerAuteur(int idAuteur) async {
    //supprimer l'auteur ensuite
    await _auteurDb.supprimerAuteur(idAuteur);
    await chargerAuteurs(); //Recharger les auteurs après suppression
  }
}