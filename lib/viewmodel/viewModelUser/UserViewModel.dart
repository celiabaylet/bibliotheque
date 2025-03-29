import '../../model/User.dart';
import '../../repository/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final UserDatabase _userDatabase = UserDatabase();
  List<User> _utilisateurs = [];
  bool _isLoading = false;
  String _userName;
  String _userRole;

  UserViewModel({
    required String userName,
    required String userRole,
  })
      : _userName = userName,
        _userRole = userRole;

  List<User> get utilisateurs => _utilisateurs;

  bool get isLoading => _isLoading;

  String get userName => _userName;

  String get userRole => _userRole;

  //recuperer ts les utilisateurs
  Future<void> chargerUtilisateurs() async {
    _isLoading = true;
    notifyListeners();
    _utilisateurs = await _userDatabase.obtenirTousLesUtilisateurs();
    _isLoading = false;
    notifyListeners();
  }
  //ajouter un utilisateur
Future<void> ajouterUser({
  required String nomUser,
  required String prenomUser,
  required String loginUser,
  required String mdpUser,
  required String roleUser,
}) async {
  await _userDatabase.ajouterUser(
    nomUser: nomUser,
    prenomUser: prenomUser,
    loginUser: loginUser,
    mdpUser: mdpUser,
    roleUser: roleUser,
  );
  await chargerUtilisateurs(); //recharger la liste des utilisateurs apres ajout
}

  // Mettre à jour un utilisateur
  Future<void> mettreAJourUser({
    required int idUser, // Ajouter `required` pour idUser
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDatabase.mettreAJourUser(
      idUser,
      nomUser,
      prenomUser,
      loginUser,
      mdpUser,
      roleUser,
    );
    await chargerUtilisateurs();
  }
  //supprimer un utilisateur
  Future<void> supprimerUser(int idUser) async {
    await _userDatabase.supprimerUtilisateur(idUser);
    await chargerUtilisateurs();
  }

  //verifier le login et mettre a jour les infos de l'utilisateur connecté
  Future<String?> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return 'Veuillez remplir tous les champs';
    }

    var user = await _userDatabase.verifierLogin(login, password);

    if (user != null) {
      _userName = user.nomUser;
      _userRole = user.roleUser;
      notifyListeners();
      return null; //connexion reussie
    } else {
      return 'Login ou mot de passe incorrect';
    }
  }
  //methode de deconnexion
Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userName'); //supprime l'utilisateur de la session
  notifyListeners(); //informe les widgets ecoutant le changement
  }
}