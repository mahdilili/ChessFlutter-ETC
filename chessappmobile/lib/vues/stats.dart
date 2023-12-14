import 'package:chessappmobile/controleurs/joueur_controleur.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/vues/profile_stats.dart';
import 'package:flutter/material.dart';

import '../models/joueur.dart';

class Stats extends StatefulWidget {
    const Stats({Key? key}) : super(key: key);

    @override
    State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
    late List<Joueur> lstJoueurs;
    late Future<void> joueursFuture;

    @override
    void initState() {
        super.initState();
        joueursFuture = fetchJoueurs();
    }

    Future<void> fetchJoueurs() async {
        var db = DatabaseHandler();
        List<Map<String, dynamic>>? listeJoueurs = await db.database?.query('Joueur');
        lstJoueurs = listeJoueurs?.map((joueur) => Joueur.fromMap(joueur)).toList() ?? [];
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Profile Stats'),
            ),
            body: FutureBuilder(
                future: joueursFuture,
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur lors du chargement des joueurs'));
                    } else {
                        return Column(
                            children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            'Sélectionner un profil',
                                            style: TextStyle(fontSize: 20),
                                        ),
                                    ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: lstJoueurs.length,
                                        itemBuilder: (context, index) {
                                            final joueur = lstJoueurs[index];
                                            return ListTile(
                                                title: Text(joueur.nameTag),
                                                onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ProfileStats(id: joueur.id)),
                                                    );
                                                },

                                                // Ajoutez ici d'autres détails du joueur si nécessaire
                                            );
                                        },
                                    ),
                                ),
                            ],
                        );
                    }
                },
            ),
        );
    }
}
