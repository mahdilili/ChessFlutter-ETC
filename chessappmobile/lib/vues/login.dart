import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controleurs/providers/utilisateur_provider.dart';

class Login extends StatelessWidget {
  const Login();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage('lib/images/login_screen.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top:360),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<UtilisateurProvider>(context, listen: false)
                      .loginAction();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 20),),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                ),
                child: const Text("Quitter", style: TextStyle(fontSize: 20),),
              ),
              Consumer<UtilisateurProvider>(
                builder: (context, utilisateurProvider, child) {
                  return Text(utilisateurProvider.errorMessage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }




}
