
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
    database = await openDatabase(
      join(await getDatabasesPath(),'chess_database.db'),
      version: 4, onCreate: (db, version) async {
        _initialScript.forEach((script) async => await db.execute(script));
    }
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
  INSERT INTO Role(id, role)
  VALUES('1','admin');
  ''',
    '''
  INSERT INTO Utilisateur(id, nom)
  VALUES('auth0|65774d0654430a4cfd99db0c', 'admin@chess.ca');
  ''',
    '''
  INSERT INTO Role(id_utilisateur, role)
  VALUES('auth0|65774d0654430a4cfd99db0c', 'admin');
  '''
  ];

}