import 'package:bibliotheque/view/viewUser/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/viewAuteur/AuteurListView.dart';
import 'view/viewLivre/LivreListView.dart';
import 'view/viewUser/UserListView.dart';
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'viewmodel/viewModelLivre/LivreViewModel.dart';
import 'viewmodel/viewModelUser/UserViewModel.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'package:sqflite_common_ffi_web/sqlite_ffi._web.dart';

void main() {
  // if (kIsWeb) {
  //   databaseFactory = createDatabaseFactoryFfiWeb();
  // }
  // else if (Plateform.isWindows || Plateform.isLinux || Plateform.isMacOS) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuteurViewModel()),
        ChangeNotifierProvider(create: (context) => LivreViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel(userName: '', userRole: '')),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibliothèque Numérique',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoginView(), // page d'accueil HomeScreen
    );
  }
}
