

import 'package:chessappmobile/database/database.dart';

import '../models/joueur.dart';

class JoueurControleur{
  Future<List<Joueur>> getJoueurs() async{
    var db = DatabaseHandler();
    List<Joueur> joueurs = [];

    List<Map<String,dynamic>>? listeJoueurs = await db.database?.query("Joueur");
    for(Map<String,dynamic> joueur in listeJoueurs!){
      joueurs.add(Joueur.fromMap(joueur));
    }

    return joueurs;
  }

  Future<void> sauvegarderJoueur (Joueur joueur) async{
    var db = DatabaseHandler();

    await db.database?.insert('Joueur', joueur.toMap());

  }

  Future<Joueur> getJoueurById (int id) async {
    Future<List<Joueur>> joueursListe = getJoueurs();
    List<Joueur> joueurs = await joueursListe;

    Joueur joueur = joueurs.firstWhere((element) => element.id == id);

    return joueur;
  }
}