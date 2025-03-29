import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Livre.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart';

class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  ModifierLivreView({Key? key, required this.livre}) : super(key: key);

  @override
  _ModifierLivreViewState createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomLivreController = TextEditingController();
  final TextEditingController _idAuteurController = TextEditingController();
  String? _jacketPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les données du livre
    _nomLivreController.text = widget.livre.nomLivre;
    _idAuteurController.text = widget.livre.idAuteur.toString();
    _jacketPath = widget.livre.jacketPath; // Charger l'image existante si elle existe
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // obtenir le timestamp actuel en millisecondes
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      // obtenir le chemin d'origine et le répertoire du fichier sélectionné
      final String originalPath = pickedFile.path;
      final String directory = originalPath.substring(0, originalPath.lastIndexOf('/'));

      // nouveau chemin avec le nom de fichier comme timestamp
      final String newPath = '$directory/$timestamp.png';

      //'newFile' contient maintenant le fichier avec le nom modifié
      final File newFile = await File(originalPath).rename(newPath);

      setState(() {
        _jacketPath = newFile.path;
        // afficher le chemin du fichier
        print('Jacket Path: $_jacketPath');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le livre', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        // modifier le bouton retour
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomLivreController,
                decoration: const InputDecoration(labelText: 'Nom du livre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de livre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idAuteurController,
                decoration: const InputDecoration(labelText: 'Id de l\'auteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un id d\'auteur';
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera, color: Colors.white),
                    label: const Text('Caméra', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<LivreViewModel>(context, listen: false).mettreAJourLivre(
                      widget.livre.idLivre!,
                      _nomLivreController.text,
                      int.parse(_idAuteurController.text),
                      _jacketPath!,
                    );
                    Navigator.pop(context); // revenir à la liste des livres
                  }
                },
                child: const Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
