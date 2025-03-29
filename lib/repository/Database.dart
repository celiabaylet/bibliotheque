import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Database? _database;

  DatabaseClient._internal();

  factory DatabaseClient() {
    return _instance;
  }

  Future<Database> get database async {     //async asyncron
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bibliotheque.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Création de la table Auteur
    await db.execute('''
      CREATE TABLE AUTEUR(
        idAuteur INTEGER PRIMARY KEY AUTOINCREMENT,
        nomAuteur TEXT NOT NULL
      )
    ''');

    // Création de la table Livre
    await db.execute('''
      CREATE TABLE LIVRE(
        idLivre INTEGER PRIMARY KEY AUTOINCREMENT,
        nomLivre TEXT NOT NULL,
        idAuteur INTEGER,
        jacket TEXT,  --ajout du champ jacket pour stocker le chemin de la couverture
        FOREIGN KEY(idAuteur) REFERENCES AUTEUR(idAuteur)
      )
    ''');

    // Création de la table User
    await db.execute('''
      CREATE TABLE IF NOT EXISTS USERS(
        idUser INTEGER PRIMARY KEY AUTOINCREMENT,
        nomUser TEXT NOT NULL,
        prenomUser TEXT NOT NULL,
        loginUser TEXT NOT NULL UNIQUE,
        mdpUser TEXT NOT NULL,
        roleUser TEXT NOT NULL
      )
    ''');

    // hashage des mots de passe
    String hashedAdminPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());
    String hashedUserPassword = BCrypt.hashpw('user123', BCrypt.gensalt());

    // Insertion des utilisateurs par défaut
    await db.insert('USERS', {
      'nomUser': 'Admin',
      'prenomUser': 'Administrateur',
      'loginUser': 'admin',
      'mdpUser': hashedAdminPassword,
      'roleUser': 'admin'
      });
    await db.insert('USERS', {
      'nomUser': 'User',
      'prenomUser': 'Utilisateur',
      'loginUser': 'user',
      'mdpUser': hashedUserPassword,
      'roleUser': 'user'
      });

    //methode pour gerer les maj de schéma
    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE LIVRE ADD COLUMN jacket TEXT;
        ''');
      }
    }
  }
}