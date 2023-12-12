import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:chessappmobile/controleurs/providers/utilisateur_provider.dart';
import 'package:chessappmobile/controleurs/utilisateur_controleur.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:chessappmobile/vues/chessboard.dart';
import 'package:chessappmobile/vues/home.dart';
import 'package:chessappmobile/vues/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
    providers: [
     ChangeNotifierProvider(create: (_)=> UtilisateurProvider(
         Auth0('dev-umqpsmfpsmtkaf0r.us.auth0.com', '1b60dmza7wtOMnWqrfLAjrkcFBOb18dO'),
         UtilisateurControleur()))
    ],
         child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final utilisateurProvider= Provider.of<UtilisateurProvider>(context);
    return MaterialApp(
      title: 'Chess Mobile',
      theme:ThemeData(useMaterial3: true,colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent, brightness: Brightness.dark)),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider.value(value: utilisateurProvider,
     child: const MyHomePage(title:'Chess mobile'),
      ));
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHandler _db = DatabaseHandler();
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    if(_db.database == null){
      _isLoading = true;
      _initDatabase();
    }
    else{
      _isLoading = false;
    }
  }

  void _initDatabase() async{
    await _db.initDb();

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Chess mobile'),
      ),
      body: Consumer<UtilisateurProvider>(
        builder: (context, utilisateurProvider, child){
          return Center(
            child: _isLoading || utilisateurProvider.isAutheticating
                ? const CircularProgressIndicator()
                : utilisateurProvider.isLoggedIn
                ? Home()
                : const Login(),
          );
        },
      ),
    );
  }
}
