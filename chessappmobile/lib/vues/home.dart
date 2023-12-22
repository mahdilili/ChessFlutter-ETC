import 'package:flutter/material.dart';
import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../controleurs/providers/utilisateur_provider.dart';
import '../database/database.dart';
import '../models/joueur.dart';
import '../controleurs/joueur_controleur.dart';
import '../vues/chessboard.dart';
import '../vues/skins.dart';
import '../vues/stats.dart';
import 'package:restart_app/restart_app.dart';

class Home extends StatefulWidget {
  final String? selectedSkinPath;

  Home({Key? key, this.selectedSkinPath}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  String? userCity;
  bool isLoading = true;
  bool gotpermission = false;
  @override
  void initState(){
    super.initState();
    _initLocation();
  }
  @override
  Widget build(BuildContext context) {
    final utilisateurProvider = Provider.of<UtilisateurProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chess App'),
        actions: [
          IconButton(
            onPressed: () async {
              await utilisateurProvider.logoutAction();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      drawer: _buildDrawer(context),
      body: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(
                spawnMaxRadius: 50.00,
                spawnMinSpeed: 10.00,
                particleCount: 30,
                spawnMaxSpeed: 50,
                minOpacity: 0.3,
                spawnOpacity: 0.4,
                baseColor: Colors.white60),
          ),
          vsync: this,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_pin, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      gotpermission
                          ? userCity != null
                          ? '$userCity'
                          : 'Chargement...'
                          : 'Permission non accordée',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: gotpermission ? Colors.white : Colors.red,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),


              Padding(
                padding: const EdgeInsets.only(top:180),
                child: Container(

                  height: 70,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white54)),
                      ),
                    ),
                    onPressed: () => _dialogCreateGame(context),
                    child: Text(
                      "Créer une nouvelle partie",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white54)),
                    ),
                  ),
                  onPressed: () => _dialogBuilder(context),
                  child: Text(
                    'Créer un profil joueur',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white54)),
                    ),
                  ),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: Text('Quitter', style: TextStyle(fontSize: 25)),
                ),
              ),

            ],
          ),
        ),
      );

  }

  Widget _buildDrawer(BuildContext context) {
    final utilisateurProvider = Provider.of<UtilisateurProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Main menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Profile Stats'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Stats()));
            },
          ),
          if (utilisateurProvider.isLoggedIn &&
              utilisateurProvider.hasRole('admin'))
            ListTile(
              title: Text('Skins'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Skins()));
              },
            ),
        ],
      ),
    );
  }

  Future<void> _dialogCreateGame(BuildContext context) async {
    DatabaseHandler db = DatabaseHandler();

    String? premierjoueur;
    String? deuxiemejoueur;
    List<Map<String, dynamic>>? listeJoeurs =
    await db.database?.query("Joueur");
    List<String> NomJoueurs = [];

    for (Map<String, dynamic> joueur in listeJoeurs!) {
      NomJoueurs.add(Joueur.fromMap(joueur).toString());
    }

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: AlertDialog(
                elevation: 16,
                scrollable: false,
                title: const Text('Créer une partie'),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButton(
                            icon: null,
                            elevation: 16,
                            items: NomJoueurs
                                .where((element) => element != deuxiemejoueur)
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Align(child: Text(value)),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                premierjoueur = newValue!;
                              });
                            },
                            value: premierjoueur,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: const Text(
                            'vs',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            icon: null,
                            elevation: 16,
                            items: NomJoueurs
                                .where((value) => value != premierjoueur)
                                .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Align(child: Text(value)),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                deuxiemejoueur = newValue!;
                              });
                            },
                            value: deuxiemejoueur,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (premierjoueur != null &&
                              deuxiemejoueur != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameBoard(
                                  whitePlayer: premierjoueur,
                                  blackplayer: deuxiemejoueur,
                                  selectedSkinPath: widget.selectedSkinPath ?? " ",
                                ),
                              ),
                            );
                          } else {
                            _showAlert(context);
                          }
                        },
                        child: const Text('Créer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }



  Future<void> _initLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String ville = placemarks.first.locality ?? "";
        String province = placemarks.first.administrativeArea ?? "";
        String pays = placemarks.first.country ?? "";
        userCity = '$ville, $province, $pays';

        setState(() {
          isLoading = false;
          gotpermission = true;
        });

      } catch (e) {
        print("Erreur lors de l'obtention de la position de l'utilisateur: $e");
      }
    } else {
      await Permission.location.request();


      Restart.restartApp();
      setState(() {
        isLoading = false;
        gotpermission = false;
      });
    }
  }



  Future<void> _dialogBuilder(BuildContext context) async {
    DatabaseHandler db = DatabaseHandler();
    JoueurControleur jc = JoueurControleur();

    final NameTagControleur = TextEditingController();


    double statusBarHeight = MediaQuery.of(context).padding.top;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AnimatedPadding(

            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + statusBarHeight,
            ),
            duration: const Duration(milliseconds: 100),
            child: AlertDialog(
              title: const Text('Nouveau profil'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: NameTagControleur,
                            decoration: InputDecoration(
                              labelText: 'Name tag',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String nametag = NameTagControleur.text;
                            Joueur joueur = Joueur(
                              nameTag: nametag,
                              experience: 0,
                              gameslost: 0,
                              gamesplayed: 0,
                              gameswon: 0,
                              level: 0,
                            );
                            jc.sauvegarderJoueur(joueur);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Créer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }


  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sélectionnez deux joueurs'),
        content: Text('Veuillez sélectionner deux joueurs pour commencer le jeu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
