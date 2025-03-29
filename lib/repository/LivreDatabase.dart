import 'Database.dart';
import'package:bibliotheque/model/Auteur.dart';


class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  //Ajouter un livre
  Future<int> ajouterLivre(String nomLivre, int idAuteur, String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'jacket': jacketPath, //ajoute le chemin de la jacket ici
    });
  }

  //Récuperer tous les livres
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  //Mettre à jour un livre
  Future<int> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur, String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.update(
      'LIVRE',
      {
        'nomLivre': nomLivre,
        'idAuteur': idAuteur,
        'jacket': jacketPath
      },
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
  }

  //Supprimer un livre
  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete(
        'LIVRE',
        where: 'idLivre = ?',
        whereArgs: [idLivre]);
  }

  // Méthode pour récupérer un auteur par son ID
  Future<Auteur?> obtenirAuteurParId(int idAuteur) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AUTEUR', // Nom de la table
      where: 'idAuteur = ?', // Clause WHERE
      whereArgs: [idAuteur], // Argument (ID de l'auteur)
      limit: 1, // On ne veut qu'un seul résultat
    );

    if (maps.isNotEmpty) {
      // Si on trouve un auteur, on retourne un objet Auteur
      return Auteur.fromMap(maps.first);
    } else {
      // Si aucun auteur n'est trouvé, on retourne null
      return null;
    }
  }

}