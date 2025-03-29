import'package:bibliotheque/model/Auteur.dart';

class Livre{
  late int? _idLivre;
  late String _nomLivre;
  late Auteur _auteur;
  late String? _jacketPath;

  //constructeur
  Livre({int? idLivre, required String nomLivre, required Auteur auteur, String? jacketPath})
    : _idLivre = idLivre,
      _nomLivre = nomLivre,
      _auteur = auteur,
      _jacketPath = jacketPath;


  //getters
  int? get idLivre => _idLivre;
  String get nomLivre => _nomLivre;
  Auteur get auteur => _auteur; //retourne l'obj Auteur complet
  String get nomAuteur => _auteur.nomAuteur; //retourne le nom de l'auteur
  int? get idAuteur => _auteur.idAuteur; //retourne l'id de l'auteur
  String? get jacketPath => _jacketPath; //retourne le chemin de la jacket

  //setters
  set nomLivre(String value){
    if (value.isEmpty){
      throw ArgumentError('Le nom du livre ne peut pas être vide');
    }
    _nomLivre = value;
  }

  set jacketPath(String? value){
    _jacketPath = value;
  }

  //methode pour convertir un Auteur en Map (pour la bdd)
  //methode pour l'inscrire
  Map<String, dynamic> toMap(){
    return {
      'idLivre': _idLivre,
      'nomLivre': _nomLivre,
      'idAuteur': _auteur.idAuteur,
      'jacket': _jacketPath, // stocke le chemin de la jacket
    };
  }

  //methode pour créer un Auteur a partir d'un map (depuis la bdd)
  //methode pour le lire
  factory Livre.fromMap(Map<String, dynamic> map, Auteur auteur){
    return Livre(
      idLivre: map['idLivre'],
      nomLivre: map['nomLivre'],
      auteur: auteur,
      jacketPath: map['jacket'], // récupère le chemin de la jacket
    );
  }

}