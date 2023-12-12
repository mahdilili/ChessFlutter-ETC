

class Joueur{

  const Joueur({this.id, required this.nameTag,  this.experience,this.gamesplayed,this.gameslost,
  this.gameswon, this.level});

  final int? id;
  final String nameTag;

  final int? gamesplayed;
  final int? gameswon;
  final int? gameslost;
  final int? experience;
  final int? level;


  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'nametag': nameTag,
      'gamesplayed' : gamesplayed,
      'gameswon' : gameswon,
      'gameslost' : gameslost,
      'experience' : experience,
      'level' : level
    };
  }

  Joueur.fromMap(Map<String,dynamic> joueurMap):
      this.id = joueurMap['id'],
      this.nameTag = joueurMap['nametag'],
      this.gamesplayed = joueurMap['gamesplayed'],
      this.gameswon = joueurMap['gameswon'],
      this.gameslost = joueurMap['gameslost'],
      this.experience = joueurMap['experience'],
      this.level = joueurMap['level'];

  @override
  String toString(){
    return '$nameTag';
  }
}