


import 'package:chessappmobile/controleurs/role_controleur.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/models/utilisateur.dart';

import '../models/role.dart';

class UtilisateurControleur{
  final RoleControleur _roleControleur = const RoleControleur();

  Future<Utilisateur> getOrInsertUtilisateur(String userID, String name) async{
    DatabaseHandler dbHandler = DatabaseHandler();
    List<Map<String,dynamic>>? utilisateur = await dbHandler.database?.query(
        "Utilisateur",
              where: "id = ?",
              whereArgs: [userID]);

    if(utilisateur!.isEmpty){
      var newUtilisateur = Utilisateur(userID, name ?? "", List<Role>.empty());

      await dbHandler.database?.insert('Utilisateur', newUtilisateur.toMap());

      utilisateur = await dbHandler.database?.query("Utilisateur", where: "id = ?", whereArgs: [userID]);

    }
    List<Role> listRoles = await _roleControleur.getRolesByIdUtilisateur(userID);

    return Utilisateur.fromMap(utilisateur!.first, listRoles);
  }
}