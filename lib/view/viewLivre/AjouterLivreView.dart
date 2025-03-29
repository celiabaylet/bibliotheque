import'dart:io';
import'package:flutter/material.dart';
import'package:provider/provider.dart';
import'package:image_picker/image_picker.dart';
import'../../viewmodel/viewModelLivre/LivreViewModel.dart';
import'../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import'../../model/Auteur.dart';
import'../../model/Livre.dart';
import'../../HomeScreen.dart';


class AjouterLivreView extends StatefulWidget {
  final String userName;
  final String userRole;

  AjouterLivreView({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  _AjouterLivreViewState createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  String _nomLivre = '';
  String? _jacketPath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;


  Future<void> _loadAuteurs() async {
    final auteurViewModel = Provider.of<AuteurViewModel>(context, listen: false);
    await auteurViewModel.chargerAuteurs();
    setState(() {
      _isLoading = false;
    });
  }

  final TextEditingController _nomLivreController = TextEditingController();
  int? _selectedAuteur;



  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      //obtenir le timestamp actuel en millisecondes
      final int timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      //obtenir le chemin d'origine et le repertoire du fichier selectionner
      final String originalPath = pickedFile.path;
      final String Directory = await originalPath.substring(
          0, originalPath.lastIndexOf('/'));

      //nv chemin avec le nom de fichier comme timestamp
      final String newPath = '$Directory/$timestamp.png';

      //'newFile' contient maintenat le fichier avec le nom modifié
      final File newFile = await File(originalPath).rename(newPath);

      setState(() {
        _jacketPath = newFile.path;
        //afficher le chemin du fichier
        print('Jacket Path: $_jacketPath');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final auteurs = Provider.of<AuteurViewModel>(context);
    final livreViewModel = Provider.of<LivreViewModel>(context);

    if (auteurs.auteurs.isEmpty){
      auteurs.chargerAuteurs();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Ajouter un Livre', style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller : _nomLivreController,
                decoration: InputDecoration(labelText: 'Nom du livre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de livre';
                  }
                  return null;
                },
              ),
              //liste deroulante popur selectionner l'auteur du livre
              DropdownButtonFormField<int>(
                value: _selectedAuteur, // L'auteur sélectionné actuellement
                hint: Text('Sélectionnez un auteur'),
                items: auteurs.auteurs.map((auteur) {
                  return DropdownMenuItem<int>(
                    value: auteur.idAuteur, // Utiliser l'objet Auteur comme valeur
                    child: Text(auteur.nomAuteur), // Afficher le nom de l'auteur
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedAuteur = value; // Mettre à jour l'auteur sélectionné
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un auteur';
                  }
                  return null;
                },
              ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text('Galerie', style: TextStyle(color: Colors.white)),
              style:ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera, color: Colors.white),
                label: const Text('Caméra', style: TextStyle(color: Colors.white)),
                style:ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _jacketPath != null
              ? Image.file(
            File(_jacketPath!),
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          )
              : const SizedBox.shrink(),



          /////////////////code a modifier
              SizedBox(height:32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //ajouter un  livre via le viewmodel    }
                    if (_selectedAuteur != null) {
                      livreViewModel.ajouterLivre(
                          _nomLivreController.text, _selectedAuteur!, _jacketPath!);
                      Navigator.pop(context); //revenir a la liste des livres
                    }
                  }
                },
                child: Text('Ajouter le livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
