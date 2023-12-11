

import 'package:chessappmobile/models/role.dart';

class Utilisateur{
  final String id;
  final String nom;

  final List<Role> roles;

  const Utilisateur(this.id,this.nom,this.roles);

  Map<String, dynamic> toMap(){
    return {'id':id , 'nom':nom};
  }

  Utilisateur.fromMap(Map<String,dynamic> utilisateurMap,List<Role> roles)
  : this.id  = utilisateurMap['id'],
    this.nom = utilisateurMap['nom'],
    this.roles = roles;

  @override
  String toString(){
    return 'Message{id:$id}, Nom:$nom, Rôle:${roles.map((e) => e.toString()).join(", ")}';
  }
}