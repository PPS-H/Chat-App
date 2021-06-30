import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
  
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` state to false
  bool _initialized = false;
  String loginInfo;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    getUserLoginInfo();
    super.initState();
  }



  getUserLoginInfo() async{
    await HelperFunctions.getUserLoginInfo().then((value){
      setState(() {
        loginInfo=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: MaterialApp(
          title: "Chat App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent
    ),
    color: Colors.white,
            home: Center(
            child:CircularProgressIndicator(),
            
          ),
        ),
      );
    }

    return MaterialApp(
    title: "Chat App",
    debugShowCheckedModeBanner: false,
    home: loginInfo=="true"?ChatRoom():SignIn(),
    theme: ThemeData(
      primaryColor: Colors.deepPurple,
      accentColor: Colors.deepPurpleAccent
    ),
  );
  
  }
}
