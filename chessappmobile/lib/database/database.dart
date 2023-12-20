
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler{
  static final DatabaseHandler _databaseHandler = DatabaseHandler._internal();

  factory DatabaseHandler(){
    return _databaseHandler;
  }

  DatabaseHandler._internal();

  Database? database;

  Future<void> initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), 'chess_database.db');
    database = await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        _initialScript.forEach((script) async => await db.execute(script));
      },
    );
  }

  static final _initialScript = [
    '''
  PRAGMA foreign_keys = ON;
  ''',
    '''
  CREATE TABLE Utilisateur(
    id TEXT PRIMARY KEY,
    id_role INTEGER,
    nom TEXT NOT NULL,
    FOREIGN KEY(id_role) REFERENCES Role(id)
  );
  ''',
    '''
  CREATE TABLE Role(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_utilisateur TEXT NOT NULL,
    role TEXT NOT NULL,
    FOREIGN KEY(id_utilisateur) REFERENCES Utilisateur(id)
  );
  ''',
    '''
    CREATE TABLE Joueur(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nametag TEXT NOT NULL,
    gameswon INT NOT NULL,
    gameslost INT NOT NULL,
    gamesplayed INT NOT NULL,
    experience INT NOT NULL,
    level INT NOT NULL
    )
    ''',
    '''
  INSERT INTO Role(id, id_utilisateur,role)
  VALUES
  (1,'auth0|65774d0654430a4cfd99db0c','admin'),
  (2,'auth0|657b234d05aa0f5efbbaedc6','user');
  ''',
    '''
  INSERT INTO Utilisateur(id, nom) VALUES
  ('auth0|65774d0654430a4cfd99db0c', 'admin@chess.ca'),
  ('auth0|657b234d05aa0f5efbbaedc6', 'user@chess.ca');
  ''',

    '''
    INSERT INTO Joueur(id, nametag,gameswon,gameslost,gamesplayed,experience,level) 
    VALUES
    (1,'Joueur1',0,0,0,0,0),
    (2,'Joueur2',0,0,0,0,0);
    ''',
  ];

}