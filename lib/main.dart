import 'package:calendar_backend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_backend/screens/authform.dart';
import 'package:calendar_backend/screens/authscreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:StreamBuilder(builder: (context,usersnapshot){
      if(usersnapshot.hasData){
        return Home();
      }
      else{
        return AuthScreen();
      }
    },
        stream: FirebaseAuth.instance.authStateChanges(),) ,
      debugShowCheckedModeBanner: false,
    ) ;
  }
}




