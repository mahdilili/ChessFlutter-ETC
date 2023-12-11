
class Role{
  final String role;
  final int id;
  final String idUtilisateur;

  const Role(this.role,this.id,this.idUtilisateur);

  Map<String, dynamic> toMap(){
    return {'id':id, 'id_utilisateur':idUtilisateur, 'role':role};
  }

  Role.fromMap(Map<String,dynamic> roleMap)
  :this.id=roleMap['id'],
  this.idUtilisateur = roleMap['id_utilisateur'],
  this.role = roleMap['role'];


  @override
  String toString(){
    return 'Message{id:$id},id utilisateur:$idUtilisateur, rôle:$role';
  }
}