import 'package:bibliotheque/view/viewAuteur/AuteurListView.dart';
import 'package:bibliotheque/view/viewLivre/LivreListView.dart';
import 'package:bibliotheque/view/viewUser/LoginView.dart';
import 'package:bibliotheque/view/viewUser/UserListView.dart';
import'package:flutter/material.dart';
import 'package:provider/provider.dart';
import'viewmodel/viewModelLivre/LivreViewModel.dart';
import'viewmodel/viewModelUser/UserViewModel.dart';
import'view/viewLivre/AjouterLivreView.dart';

class HomeScreen extends StatefulWidget {
  final String userName; //champ pour stocker le nom de l'utilisateur
  final String userRole; //champ pour stocker le rôle de l'utilisateur

  const HomeScreen({super.key, required this.userName, required this.userRole}); //passer le nom de l'utilisateur et son rôle

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    //charger les livres au demarrage
    Future.microtask(() {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Bibliotheque Numérique', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // ajuste la hauteur du DrawerHeader
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    'Menu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  ],
                ),
              ),
            ),
            if (widget.userRole == 'admin') //verifier si l'utilisateur est un admin
              ListTile(
                leading: const Icon(Icons.add, color: Colors.deepPurple),
                title: const Text('Gerer les livres'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LivreListView(
                          userName: widget.userName,
                          userRole: widget.userRole)
                    ),
                  );
                },
              ),
              //les admins gerent les livres les user les voient
            if (widget.userRole == 'user') //verifier si l'utilisateur est un admin
              ListTile(
                title: const Text('Voir les livres'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LivreListView(
                            userName: widget.userName,
                            userRole: widget.userRole)

                    ),
                  );
                },
              ),
              if (widget.userRole == 'admin')
              ListTile(
                leading: const Icon(Icons.add, color: Colors.deepPurple),
                title: const Text('Gérer les auteurs'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AuteurListView(
                          userName: widget.userName,
                          userRole: widget.userRole)
                    ),
                  );
                },
                ),
            //les admins gerent les auteurs les user les voient
            if (widget.userRole == 'user')
            ListTile(
              title: const Text('Voir les auteurs'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AuteurListView(
                          userName: widget.userName,
                          userRole: widget.userRole)
                  ),
                );
              },
            ),
              if (widget.userRole == 'admin')
                ListTile(
                  leading: const Icon(Icons.supervised_user_circle_outlined, color: Colors.deepPurple),
                  title: const Text('Gérer les utilisateurs'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider<UserViewModel>(
                            create: (context) => UserViewModel(userName: widget.userName, userRole: widget.userRole),
                            child: UserListView(userName: widget.userName, userRole: widget.userRole),
                          );
                        },
                          ),
                      );
                    },
                ),
              if (widget.userRole == 'admin')
                const ListTile(
                  leading: const Icon(Icons.library_books, color: Colors.deepPurple),
                  title: const Text('Gestion des prêts'),
                    //onTap: () {
                      //Navigator.of(context).push(
                        //MaterialPageRoute(
                          //builder: (context) =>PretLivreView(), //remplacer par la vue de gestion des prêts
                           //),
                         //);
                        //},
                            ),
                          ],
                      ),
                    ),
                    body: Column(
                      children: [
                        Expanded(child: LivreListView(userName: widget.userName, userRole: widget.userRole,)),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.blueGrey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Connecté en tant que ${widget.userName}',
                                style: const TextStyle(color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  await Provider.of<UserViewModel>(context, listen: false).logout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginView(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Se déconnecter'),
                              ),
                            ],
    ),
                        ),
                      ],
                    ),
    );
  }
}
