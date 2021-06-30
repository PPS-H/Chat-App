import 'package:chat_app/animation/animated_image.dart';
import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/sevices/firebase_auth.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:chat_app/views/chat_room.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp>{
  final formKey=GlobalKey<FormState>();
  bool isLoding=false;
  Stream userStream;
  bool alreadyExists=false;
  DataBaseMethods dataBaseMethods=DataBaseMethods();
  AuthMethods authmethods=AuthMethods();
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  signUp(){
    if(formKey.currentState.validate()){
      Map<String,String> data={
        "name":name.text,
        "email":email.text,
        "status":"Offline"
      };

    setState(() {
      isLoding=true;
    });
    
    dataBaseMethods.getUserByUserEmail(email.text).then((value) {
      if(value.docs.length==0){
    authmethods.signUpWithEmailAndPassword(email.text, password.text).then((value) {
    HelperFunctions.setUserLoginInfo("true");
    HelperFunctions.setUserNameInfo(name.text);
    HelperFunctions.setUserEmailInfo(email.text);
    dataBaseMethods.uploadUserInfo(data);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ChatRoom()
      ));
    });

      }else{
        setState(() {
          isLoding=false;
          alreadyExists=true;
        });
      }
    });
        
    }
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar:getAppBar(context),
      body:Center(
        child: isLoding?Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ):SingleChildScrollView(
            child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal:15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  // getImage(AssetImage('images/signUp.png'),context),
                  AnimatedImage("images/signUp.png"),

                  Form(
                    key: formKey,
                    child:Column(
                      children:[
                      TextFormField(
                        validator: (value){
                          return value.isEmpty ||value.length<4?"Please enter an valid username greater than 4 characters":null;
                        },
                    controller: name,
                    decoration:textFieldDecoration(context, "Name", "Enter your name") ,
                  ),

                  SizedBox(height:10.0),
                  TextFormField(
                    validator: (value){
                          return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?null: "Please enter an valid email address";
                        },
                    controller: email,
                    decoration:textFieldDecoration(context, "Email", "Enter your email") ,
                  ),
                  

                  SizedBox(height:10.0),
                   TextFormField(
                     validator: (value){
                          return value.isEmpty ||value.length<=6?"Please enter an valid password greater than 6 characters":null;
                        },
                     obscureText: true,
                    controller: password,
                    decoration:textFieldDecoration(context, "Password", "Enter your password") ,
                  ),
                      ]
                    )
                  ),

                  

                  SizedBox(height:10.0),
                  alreadyExists?Container(
                     child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.warning,color: Color.fromRGBO(204, 0, 0,1),),
                           Text(
                             "An account is already exists on this email",
                             style: TextStyle(
                               fontSize: 16,
                               color: Color.fromRGBO(204, 0, 0, 1)
                             ),
                             ),
                         ],
                       ),
                     ),
                   ):Container(),

                  GestureDetector(
                    onTap: (){
                      signUp();
                    },
                    child: getButton(context, "Sign Up", Colors.deepPurple,Colors.white)),

                  SizedBox(height:10.0),

                  getButton(context, "Sign Up with google", Color(0xffe6e6e6),Colors.black),

                  SizedBox(height:10.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",style:TextStyle(
                        fontSize: 17
                      )),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context)=>SignIn()
                          ));
                        },
                          child: Container(
                          child: Text("Sign In",style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize:17),),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height:10.0)
              ]
            ),
        ),
          ),
      )
    );
}
}