

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

  Future<void> sauvegarderGameStats(Joueur whitePlayer, Joueur blackPlayer, bool isWhiteWinner) async {
    var db = DatabaseHandler();
    print("Saved game " + whitePlayer.nameTag + " vs " + blackPlayer.nameTag);

    if (isWhiteWinner) {
      whitePlayer.experience = (whitePlayer.experience ?? 0) + 100;
      whitePlayer.gameswon = (whitePlayer.gameswon ?? 0) + 1;
      whitePlayer.gamesplayed = (whitePlayer.gamesplayed ?? 0) + 1;

      blackPlayer.gamesplayed = (blackPlayer.gamesplayed ?? 0) + 1;
      blackPlayer.gameslost = (blackPlayer.gameslost ?? 0) + 1;
      blackPlayer.experience = (blackPlayer.experience ?? 0) + 30;
    } else {
      whitePlayer.experience = (whitePlayer.experience ?? 0) + 30;
      whitePlayer.gameslost = (whitePlayer.gameslost ?? 0) + 1;
      whitePlayer.gamesplayed = (whitePlayer.gamesplayed ?? 0) + 1;

      blackPlayer.gamesplayed = (blackPlayer.gamesplayed ?? 0) + 1;
      blackPlayer.gameswon = (blackPlayer.gameswon ?? 0) + 1;
      blackPlayer.experience = (blackPlayer.experience ?? 0) + 100;
    }

    await db.database?.update('Joueur', whitePlayer.toMap(), where: 'id = ?', whereArgs: [whitePlayer.id]);
    await db.database?.update('Joueur', blackPlayer.toMap(), where: 'id = ?', whereArgs: [blackPlayer.id]);
  }


}