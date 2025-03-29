import'package:flutter/material.dart';
import'package:provider/provider.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;// callback pour l'action a executer a la confirmation

  ConfirmDeleteDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blueGrey,
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        //Bouton "Non" avec couleur verte
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); //fermer la boite de dialogue sans rien faire
          },
          child: Text('Non'),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white),
            backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
          ),
        ),
        //Bouton "Oui" avec couleur rouge
        TextButton(
          onPressed: () {
            onConfirm(); //executer la fonction passée en parametre
            Navigator.of(context).pop(); //fermer la boite de dialogue
          },
          child: Text('Oui'),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white),
            backgroundColor: WidgetStateProperty.all(Colors.red),
          ),
        ),
      ],
    );
  }
}
