


import 'package:chessappmobile/controleurs/joueur_controleur.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/models/joueur.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../mocks/joueur_controleur_test.mocks.dart';


@GenerateMocks([JoueurControleur])
void main(){
  group('test du controleur du joueur',(){
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

    test('test de la méthode get joueurs',() async {
      final db = DatabaseHandler();
      await db.initDb();
      var jc = JoueurControleur();
      expect(jc.getJoueurs(),isA<Future<List<Joueur>>>());
    });

    test('test d''insertion d''un nouveau joueur', ()async {
      var joueur = Joueur(nameTag: "testJoueur",level: 0,gameswon: 0,gamesplayed: 0,gameslost: 0,experience: 0);
      var jc = JoueurControleur();

      expect(jc.sauvegarderJoueur(joueur),isA<Future<void>>());
    });

    test('test pour get un joueur avec son id', () async {
      var jc = JoueurControleur();
      expect(jc.getJoueurById(1),isA<Future<Joueur>>());
    });

    test('test de sauvegarde des stats', () async {
      //ici pour pas écire directement dans la database j'utilise un mock pour tester la base de données
      //sans écraser ou écrire des données
      var jc = JoueurControleur();
      var jc2 = MockJoueurControleur();
      Joueur j1 = await jc.getJoueurById(1);
      Joueur j2 = await jc.getJoueurById(2);

      expect(jc2.sauvegarderGameStats(j1, j2, true), isA<Future<void>>());
    });
  });
}