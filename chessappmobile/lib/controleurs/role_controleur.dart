

import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/models/role.dart';

class RoleControleur{
  const RoleControleur();

  Future<List<Role>> getRolesByIdUtilisateur (String idUtilisateur) async {
    DatabaseHandler dbHandler = DatabaseHandler();

    List<Map<String,dynamic>>? roleList = await dbHandler.database?.query
      ("Role", where: "id_utilisateur = ?", whereArgs: [idUtilisateur]);

    return roleList?.map((e)=> Role.fromMap(e)).toList()?? List<Role>.empty();
  }
}