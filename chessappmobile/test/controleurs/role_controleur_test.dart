


import 'package:chessappmobile/controleurs/role_controleur.dart';
import 'package:chessappmobile/models/role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

@GenerateMocks([RoleControleur])
void main()
{
  group('test du controleur role',() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    test('test de la méthode get roles by id', () async{
      var rc = RoleControleur();
      expect(rc.getRolesByIdUtilisateur('1'),isA<Future<List<Role>>>());
    });


  });
}