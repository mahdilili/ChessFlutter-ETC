import 'package:flutter/material.dart';
import '../controleurs/joueur_controleur.dart';
import '../models/joueur.dart';

class ProfileStats extends StatefulWidget {
  final int? id;

  ProfileStats({required this.id});

  @override
  State<StatefulWidget> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  late Joueur joueur = Joueur(nameTag: "DefaultName");

  @override
  void initState() {
    super.initState();
    loadPlayerStats();
  }

  Future<void> loadPlayerStats() async {
    if (widget.id != null) {
      JoueurControleur joueurControleur = JoueurControleur();
      var joueurStats = await joueurControleur.getJoueurById(widget.id!);

      setState(() {
        joueur = joueurStats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Stats - ${joueur.nameTag}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 200,
                child: buildStatProgress('Level', joueur.level ?? 0)),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildStatCircularProgress('Games Played', joueur.gamesplayed ?? 0),
                  SizedBox(width: 16.0),
                  buildStatCircularProgress('Games Won', joueur.gameswon ?? 0),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatCircularProgress('Games Lost', joueur.gameslost ?? 0),
                SizedBox(width: 16.0),
                buildStatCircularProgress('Experience', joueur.experience ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatProgress(String label, int value) {
    double percentage = value / 10.0;

    return Column(
      children: [
        Text(
          '$label: $value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }


  Widget buildStatCircularProgress(String label, int value) {
    double percentage = value / 10.0;

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          '$label',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
