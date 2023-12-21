
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:chessappmobile/models/utilisateur.dart';
import 'package:flutter/cupertino.dart';
import '../../models/role.dart';
import '../utilisateur_controleur.dart';

const appSchema = "chessappmobile";

class UtilisateurProvider extends ChangeNotifier{
  late Auth0 _auth0;
  Credentials? _credentials;
  Utilisateur? _utilisateur;
  late bool _isAuthenticating;
  late String _errorMessage;


  List<Role>? get roles=>_utilisateur?.roles;
  
  bool get isAutheticating=> _isAuthenticating;
  
  String get errorMessage=>_errorMessage;
  
  Uri? get pictureUrl=> _credentials?.user.pictureUrl;
  String? get name=> _credentials?.user.name;
  bool get isLoggedIn=>_credentials != null;

  late UtilisateurControleur _utilisateurControleur ;
  
  bool hasRole(String role){
    return roles?.any((element) => element.role == role)?? false;
  }
  
  
  UtilisateurProvider(Auth0 auth0, UtilisateurControleur utilisateurControleur){
    _auth0 = auth0;
    _utilisateurControleur = utilisateurControleur;
    _errorMessage = '';
    _isAuthenticating = false;
  }

  Future<void> loginAction() async{
    _isAuthenticating = true;
    _errorMessage = '';

    notifyListeners();

    try{
      final Credentials credentials = await _auth0.webAuthentication(scheme: appSchema).login();


      Utilisateur utilisateur = await _utilisateurControleur.getOrInsertUtilisateur(credentials.user.sub, credentials.user.name?? '');

      _credentials = credentials;
      _utilisateur = utilisateur;
      _isAuthenticating = false;
      notifyListeners();
    } on Exception catch(e,s){
      debugPrint('Login error: $e - stack: $s');

      _isAuthenticating = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    await _auth0.webAuthentication(scheme: appSchema).logout();

    _utilisateur = null;
    _credentials = null;
    notifyListeners();
  }
}