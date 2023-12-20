

import 'package:chessappmobile/controleurs/utilisateur_controleur.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/models/utilisateur.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../mocks/utilisateur_provider_test.mocks.dart';

@GenerateMocks([UtilisateurControleur])
void main()
{
  group('test du controleur utilisateur',(){
    var db = DatabaseHandler();
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });
    test('test de la méthode get or insert utilisateur', () async {

      var uc = MockUtilisateurControleur();
      when(uc.getOrInsertUtilisateur(any, any))
          .thenAnswer((_) async => Utilisateur('auth0|65774d0654430a4cfd99db0c', 'admin@chess.ca', []));
      var result = await uc.getOrInsertUtilisateur('auth0|65774d0654430a4cfd99db0c', 'admin@chess.ca');


      expect(result, isA<Utilisateur>());
    });
  });
}