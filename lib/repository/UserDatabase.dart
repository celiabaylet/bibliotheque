import 'package:bcrypt/bcrypt.dart';
import '../model/User.dart';
import 'Database.dart';

class UserDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  //recuperer ts les utilisateurs
  Future<List<User>> obtenirTousLesUtilisateurs() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query('USERS');

    return result
        .map((userMap) => User(
              idUser: userMap['idUser'],
              nomUser: userMap['nomUser'],
              prenomUser: userMap['prenomUser'],
              loginUser: userMap['loginUser'],
              mdpUser: userMap['mdpUser'],
              roleUser: userMap['roleUser'],
            ))
        .toList();
  }

  //ajouter un utilisateur
  Future<int> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser, //mdp en clair à hasher
    required String roleUser,
  }) async {
    final db = await _dbClient.database;

    // hashage du mdp
    String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());

    return await db.insert('USERS', {
        'nomUser': nomUser,
        'prenomUser': prenomUser,
        'loginUser': loginUser,
        'mdpUser': hashedPassword,
        'roleUser': roleUser,
      });
  }
  //mettre à jour un utilisateur
  Future<int> mettreAJourUser(int idUser, String nomUser, String prenomUser, String loginUser, String mdpUser, String roleUser) async {
    final db = await _dbClient.database;

    //creer un map des valeurs à mettre à jour
    Map<String, dynamic> values = {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': mdpUser,
      'roleUser': roleUser,
    };

    //ne mettez a jour le mdp que si une nouvelle valeur est fournie
    if (mdpUser.isNotEmpty) {
      String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
      values['mdpUser'] = hashedPassword;
    }

    //maj de l'utilisateur dans la bdd
    return await db.update(
      'USERS',
      values,
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }

  //supprimer un utilisateur par ID
  Future<int> supprimerUtilisateur(int idUser) async {
    final db = await _dbClient.database;

    return await db.delete(
      'USERS',
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }

  //Verifier les identifiants d'un utilisateur (login et mdp)
  Future<User?> verifierLogin(String login, String password) async {
    final db = await _dbClient.database;

    final List<Map<String, dynamic>> result = await db.query(
      'USERS',
      where: 'loginUser = ?',
      whereArgs: [login],
    );

    if (result.isNotEmpty) {
      final userMap = result.first;
      //verifier le mdp
      if (BCrypt.checkpw(password, userMap['mdpUser'])) {
        return User(
          idUser: userMap['idUser'],
          nomUser: userMap['nomUser'],
          prenomUser: userMap['prenomUser'],
          loginUser: userMap['loginUser'],
          mdpUser: userMap['mdpUser'],
          roleUser: userMap['roleUser'],
        );
      }
    }
    //retourne null si l'utilisateur n'est pas trouvé ou si le mdp est incorrect
    return null;
}
}
