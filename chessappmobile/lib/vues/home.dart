import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:chessappmobile/controleurs/joueur_controleur.dart';
import 'package:chessappmobile/controleurs/providers/utilisateur_provider.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/vues/chessboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/joueur.dart';

class Home extends StatefulWidget{

  @override
  State<Home> createState()=> HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Chess App'),
      ),
      drawer: _buildDrawer(context),
      body:   AnimatedBackground(
    behaviour: RandomParticleBehaviour(
    options: const ParticleOptions(
        spawnMaxRadius: 50.00,
        spawnMinSpeed: 10.00,
        particleCount: 30,
        spawnMaxSpeed: 50,
        minOpacity: 0.3,
        spawnOpacity: 0.4,
        baseColor: Colors.white60
    )
    ),
    vsync: this,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Container(height: 70,
    child: ElevatedButton(
    style: ButtonStyle(shape:MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),side: BorderSide(color: Colors.white54))
    )),
    onPressed: () => _dialogCreateGame(context),
    child: Text("Créer une nouvelle partie", style: TextStyle(fontSize: 25),),
    ),
    ),
    SizedBox(height: 5), // Espacement entre les boutons
    Container(height: 70,
    child: ElevatedButton(
    style: ButtonStyle(shape:MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),side: BorderSide(color: Colors.white54))
    )),
    onPressed: () => _dialogBuilder(context),
    child: Text('Créer un joueur', style: TextStyle(fontSize: 25),),
    ),
    ),
    SizedBox(height: 5), // Espacement entre les boutons
    Container(height: 70,
    child: ElevatedButton(
    style: ButtonStyle(shape:MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),side: BorderSide(color: Colors.white54))
    )),
    onPressed: () {
    if (Platform.isAndroid) {
    SystemNavigator.pop();
    } else if (Platform.isIOS) {
    exit(0);
    }
    },
    child: Text('Quitter', style: TextStyle(fontSize: 25),),
    ),
    ),
    ],
    ),),);

  }


  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(height: 100,
            child: DrawerHeader(

              decoration: BoxDecoration(

                color: Colors.blue,
              ),
              child: Text(
                'Main menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Profile Stats'),
            onTap: () {
              _dialogCreateGame(context);
              Navigator.pop(context); // Fermer le Drawer après avoir sélectionné une option
            },
          ),
          // Vous pouvez ajouter d'autres options de menu ici
        ],
      ),
    );
  }

  Future<void> _dialogCreateGame(BuildContext context) async{
    DatabaseHandler db = DatabaseHandler();

    String? premierjoueur;
    String? deuxiemejoueur;
    List<Map<String,dynamic>>? listeJoeurs = await db.database?.query("Joueur");
    List<String> NomJoueurs=[];

    for(Map<String,dynamic> joueur in listeJoeurs!){
      NomJoueurs.add(Joueur.fromMap(joueur).toString());
    }


    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: AlertDialog(
                elevation: 16,
                scrollable: false,
                title: const Text('Créer une partie'),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButton(
                            icon: null,
                            elevation: 16,
                            items: NomJoueurs.where((element) => element !=deuxiemejoueur)
                                .map<DropdownMenuItem<String>>(
                                  (String value) {

                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Align(child: Text(value)),
                                  ),
                                );

                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                premierjoueur = newValue!;
                              });
                            },
                            value: premierjoueur,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: const Text(
                            'vs',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            icon: null,
                            elevation: 16,
                            items: NomJoueurs
                                .where((value) => value != premierjoueur)
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Align(child: Text(value)),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                deuxiemejoueur = newValue!;
                              });
                            },
                            value: deuxiemejoueur,
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameBoard(
                                whitePlayer: premierjoueur,
                                blackplayer: deuxiemejoueur,

                              ),
                            ),
                          );
                        },
                        child: const Text('Créer'),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        });
      },
    );

  }

  Future<void> _dialogBuilder(BuildContext context) async {
    DatabaseHandler db = DatabaseHandler();
    JoueurControleur jc = JoueurControleur();

    final NameTagControleur = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: AlertDialog(
                scrollable: false,
                title: const Text('Créer un joueur'),
                content: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: NameTagControleur,
                            decoration: InputDecoration(
                              labelText: 'Name tag',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String nametag = NameTagControleur.text;
                            Joueur joueur = Joueur(
                              nameTag: nametag,
                              experience: 0,
                              gameslost: 0,
                              gamesplayed: 0,
                              gameswon: 0,
                              level: 0,
                            );
                            jc.sauvegarderJoueur(joueur);

                            // Ajoutez ici le code pour fermer le dialogue après avoir créé le joueur si nécessaire
                            Navigator.of(context).pop();
                          },
                          child: const Text('Créer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
