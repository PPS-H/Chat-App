import 'package:chat_app/sevices/constants.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DataBaseMethods{

    Future <Stream<QuerySnapshot>> getUserByUserName(String username)async{
      return FirebaseFirestore.instance.collection("users_chat_id").where("name".toLowerCase(),isEqualTo:username).snapshots();
    }

    

    Future <QuerySnapshot> getUserByUserEmail(String userEmail)async{
      Future <QuerySnapshot> sp;
      sp= FirebaseFirestore.instance.collection("users_chat_id").where("email",isEqualTo:userEmail).get();
      return sp;
    }

  uploadUserInfo(userInfo){
    FirebaseFirestore.instance.collection("users_chat_id").add(userInfo);
  }
  

  createChatRoom(String chatRoomId, chatRoomMap)async{
    await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
      debugPrint("ERROR WHILE CREATING CHAT ROOM ${e.toString()}");
    });
  }

  addConversationMessages(String chatRoomId,messagesMap)async{
     FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messagesMap).catchError((e){
      debugPrint("Messaging error $e");
    });
  }

  Future <Stream<QuerySnapshot>> getConversationMessages(String chatRoomId) async{
    return FirebaseFirestore.instance.collection("ChatRoom").
    doc(chatRoomId).collection("chats").orderBy("ts").snapshots();
  }

  setLastDetails(String chatRoomId,messagesMap)async{
     await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).update(messagesMap);
  }


  Future <Stream<QuerySnapshot>> getChatRoom()async{
    String name;
    await HelperFunctions.getUserNameInfo().then((value) {
      name=value;
    });
    return FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: name).orderBy("lastTime",
    descending:true).snapshots();
  }



getUserList(String name)async{
  return FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: name).snapshots();

}
}