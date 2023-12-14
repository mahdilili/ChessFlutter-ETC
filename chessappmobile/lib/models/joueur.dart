class Joueur {
  Joueur({
    this.id,
    required this.nameTag,
    int? experience,
    int? gamesplayed,
    int? gameslost,
    int? gameswon,
    int? level,
  }) {
    this.experience = (experience ?? 0) % 100;
    this.level = (experience != null) ? ((experience / 10).clamp(0, 1)).toInt() : null;
    this.gamesplayed = gamesplayed;
    this.gameswon = gameswon;
    this.gameslost = gameslost;
  }

  int? id;
  String nameTag;

  int? gamesplayed;
  int? gameswon;
  int? gameslost;
  int? experience;

  int? level;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nametag': nameTag,
      'gamesplayed': gamesplayed,
      'gameswon': gameswon,
      'gameslost': gameslost,
      'experience': experience,
      'level': level,
    };
  }

  Joueur.fromMap(Map<String, dynamic> joueurMap)
      : id = joueurMap['id'],
        nameTag = joueurMap['nametag'],
        gamesplayed = joueurMap['gamesplayed'],
        gameswon = joueurMap['gameswon'],
        gameslost = joueurMap['gameslost'],
        experience = (joueurMap['experience'] ?? 0) % 100,
        level = (joueurMap['experience'] != null) ? ((joueurMap['experience'] / 10).clamp(0, 1)).toInt() : null;

  @override
  String toString() {
    return '$id: ' + '$nameTag';
  }
}
