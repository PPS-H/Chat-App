import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/sevices/firebase_auth.dart';
import 'package:chat_app/views/forget_password_success.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email=TextEditingController();
  DataBaseMethods dataBaseMethods=DataBaseMethods();
  AuthMethods authMethods=AuthMethods();
  bool notFound=false;
  bool isLoding=false;

  resetPassword()async{
    setState(() {
      isLoding=true;
    });
    dataBaseMethods.getUserByUserEmail(email.text).then((value) {
      if(value.docs.length>0){
        authMethods.resetPassword(email.text);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ForgetPasswordSuccess()));

      }else{
        setState(() {
          notFound=true;
          isLoding=false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:getAppBar(context),
      body: !isLoding?Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:30.0),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Forget Password??",
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold
                  ),),
              ),
            ),
            Center(child: getImage(AssetImage("images/forgetPassword.png"), context)),
            SizedBox(height:10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal:20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:15.0),
                    child: TextFormField(
                    validator: (value){
                    return RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?null: "Please enter an valid email address";
            },
                    controller: email,
                    decoration:textFieldDecoration(context, "Email", "Enter your email") ,
                    ),
                  ),
                  SizedBox(height:10.0),
                  GestureDetector(
                    onTap: (){
                      resetPassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0),
                      child: getButton(context, "Continue", Colors.deepPurple,Colors.white),
                    )),
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
                ],
              ),
            )
          ],
          ),
      ):Center(
        child:CircularProgressIndicator()
      )
    );
  }
}