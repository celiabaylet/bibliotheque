import 'dart:io';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title; // Titre de la carte
  final String subtitle; // Sous-titre de la carte
  final String? jacketPath;
  final String userRole; // Rôle de l'utilisateur (pour vérifier les permissions)
  final bool displayJacket; // Indicateur pour afficher ou non la jacket
  final VoidCallback? onTap; // Callback pour l'action au tap
  final VoidCallback? onDelete; // Callback pour l'action de suppression

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.jacketPath,
    this.onTap,
    this.onDelete,
    required this.userRole,
    this.displayJacket = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[350],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: displayJacket && jacketPath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(jacketPath!),
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              );
            },
          ),
        )
            : (displayJacket
            ? const Icon(
          Icons.book,
          size: 50,
          color: Colors.blueAccent,
        )
            : null),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          if (userRole == 'admin' && onTap != null) {
            onTap!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vous n\'avez pas les droits de modification.'),
              ),
            );
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userRole == 'admin' && onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.blue),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
