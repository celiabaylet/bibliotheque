class Auteur{
  int? _idAuteur=0;
  String _nomAuteur='';

  //constructeur
  Auteur({int? idAuteur, required String nomAuteur}){
    _idAuteur = idAuteur;
    _nomAuteur = nomAuteur;
  }

  //getters
  int? get idAuteur => _idAuteur;
  String get nomAuteur => _nomAuteur;

  //setters
  //pas de setter de l'id car clé primaire gérer ds la bdd donc ca serez dangereux
  set nomAuteur(String? nomAuteur){
    _nomAuteur = nomAuteur!;
  }

  //methode pour convertir un Auteur en Map (pour la bdd)
  Map<String, dynamic> toMap(){
    return {
      'idAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
    };
  }

  //methode pour créer un Auteur a partir d'un map (depuis la bdd)
  factory Auteur.fromMap(Map<String, dynamic> map){
    return Auteur
      (idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
    );
  }


}