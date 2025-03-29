import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import'../../model/Auteur.dart';

class AjouterAuteurView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Ajouter un Auteur', style: TextStyle(color: Colors.white)),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller : _nomAuteurController,
              decoration: InputDecoration(labelText: 'Nom de l\'auteur'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom d\'auteur';
                }
                return null;
              },
            ),
            SizedBox(height:32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //ajouter un  auteur via le viewmodel    }
                  Provider.of<AuteurViewModel>(context, listen: false)
                      .ajouterAuteur(_nomAuteurController.text);
                  Navigator.pop(context); //revenir a la liste des auteurs
                }
              },
              child: Text('Ajouter l\'auteur'),
            ),
          ],
        ),
      ),
    ),
  );
}
}
