import 'package:chat_app/model/user.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods{
  
 final FirebaseAuth _auth=FirebaseAuth.instance;
 
 
 ApplicationUser _userFromFirebase(User user){
   return user!=null?ApplicationUser(user.uid):null;
 }


 Future signInWithEmailAndPassword(String email,String password)async{
  try{
    //it will give us user authentication result......
    UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password).catchError((e){
      print("ERROR"+e.toString());
      return null;
    });
    //it will give us a user
    User user=result.user;
    if(user.uid==null){
      return null;
    }else{

    return _userFromFirebase(user);
    }
  }catch(e){
    print(e.toString());
  }
 }


  Future signUpWithEmailAndPassword(String email,String password)async{

    try{
    UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User user=result.user;
    return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email)async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }
  Future signOut()async{
    HelperFunctions.setUserLoginInfo("false");
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}