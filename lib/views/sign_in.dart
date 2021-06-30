import 'package:chat_app/animation/animated_image.dart';
import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/sevices/firebase_auth.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:chat_app/views/forget_password.dart';
import 'package:chat_app/views/register.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'chat_room.dart';

AuthMethods authmethods=AuthMethods();
DataBaseMethods dataBaseMethods=DataBaseMethods();
Stream userStream;
class SignIn extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn>{
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  final formKey=GlobalKey<FormState>();
  bool isLoding=false;
  bool notFound=false;
  QuerySnapshot snapshot;
  DocumentSnapshot ds;
 

  signIn(){
  if(formKey.currentState.validate()){

    setState(() {
      isLoding=true;
    });

    dataBaseMethods.getUserByUserEmail(email.text).then((value) {
      if(value.docs.length>0){
      snapshot=value;      
      ds=snapshot.docs[0];

      authmethods.signInWithEmailAndPassword(email.text,password.text).then((value) {
        if(value==null){
          setState(() {
            isLoding=false;
            notFound=true;
          });
        }else{
      HelperFunctions.setUserLoginInfo("true");
      HelperFunctions.setUserNameInfo(ds["name"]);
      HelperFunctions.setUserEmailInfo(email.text);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ChatRoom()
      ));
        }  
    });
      }else{
        
        setState(() {
          isLoding=false;
          notFound=true;
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
            padding: EdgeInsets.symmetric(horizontal:15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  // getImage(AssetImage('images/signIn.png'),context),
                  AnimatedImage("images/signIn.png"),
                   Form(
                     key: formKey,
                     child: Column(
                      children:[                       
                  TextFormField(
                     validator: (value){
                        return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?null: "Please enter an valid email address";
                        },
                      controller: email,
                      decoration:textFieldDecoration(context, "Email", "Enter your email"),
                  ),
                  
                  SizedBox(height:10.0),TextFormField(
                            obscureText: true,
                            validator: (value){
                            return value.isEmpty ||value.length<=6?"Please enter an valid password greater than 6 characters":null;
                          },
                        controller: password,
                        decoration:textFieldDecoration(context, "Password", "Enter your password"),
                    ),
                  SizedBox(height:10.0),
                       ]
                     ),
                   ),

                   notFound?Container(
                     child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.warning,color: Color.fromRGBO(204, 0, 0,1),),
                           Text(
                             "Invalid email or password",
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
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context)=>ForgetPassword()));
                    },
                    child: Container(
                    alignment: Alignment.centerRight,
                    child:Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontSize: 16
                    ),
                    )),
                  ),

                  SizedBox(height:10.0),

                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: getButton(context, "Sign In", Colors.deepPurple,Colors.white)
                    ),

                  SizedBox(height:10.0),

                  getButton(context, "Sign In with google", Color(0xffe6e6e6),Colors.black),

                  SizedBox(height:10.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",style:TextStyle(
                        fontSize: 17
                      )),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context)=>SignUp()
                          ));
                        },
                          child: Container(
                          child: Text("Register",style: TextStyle(
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