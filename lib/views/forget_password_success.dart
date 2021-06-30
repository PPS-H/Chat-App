import 'package:chat_app/views/sign_in.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ForgetPasswordSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:getAppBar(context),
      body: Container(
        color:Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child:getImage(AssetImage("images/mail.png"), context)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:30.0,horizontal: 20.0),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "An Email has been sent on your email address!!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
              ),
            ),
            GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 20.0),
                      child: getButton(context, "Back to Sign In", Colors.deepPurple,Colors.white),
                    )),
          ],
        ),
      ),
    );
  }
}