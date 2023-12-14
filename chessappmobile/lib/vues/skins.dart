import 'package:flutter/material.dart';

class Skins extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SkinsState();
}

class _SkinsState extends State<Skins> {
  List<String> skinPaths = [
    "lib/images/board1.PNG",
    "lib/images/board2.PNG",
    "lib/images/board3.PNG",
    "lib/images/default_board.PNG",
    // Ajoutez ici les chemins d'accès à vos skins supplémentaires
  ];

  String selectedSkinPath = ''; // Le chemin du skin sélectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélection de skin'),
      ),
      body: Column(
        children: [
          // Utiliser une ListView.builder pour afficher les images dans une liste scrollable
          Expanded(
            child: ListView.builder(
              itemCount: skinPaths.length,
              itemBuilder: (context, index) {
                String path = skinPaths[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: selectedSkinPath == path ? Colors.green : Colors.transparent,
                    title: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedSkinPath == path ? Colors.black : Colors.grey,
                          width: selectedSkinPath == path ? 4 : 1,
                        ),
                      ),
                      child: Image.asset(path),
                    ),
                    onTap: () {
                      setState(() {
                        selectedSkinPath = path;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Bouton pour appliquer le skin sélectionné à la classe GameBoard
          ElevatedButton(
            onPressed: () {
              // TODO: Envoyer le chemin du skin à la classe GameBoard
              Navigator.pop(context, selectedSkinPath);
            },
            child: Text('Appliquer le skin'),
          ),
        ],
      ),
    );
  }
}
