import 'package:chat_app/Cryption/EncryptDecrypt.dart';
import 'package:chat_app/sevices/constants.dart';
import 'package:chat_app/sevices/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';

class ConversationRoom extends StatefulWidget {
final String chatRoomId;
final String name;
  ConversationRoom(this.chatRoomId,this.name){}
  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> {

  bool getData=false;
  @override
  DataBaseMethods dataBaseMethods=DataBaseMethods();
  TextEditingController message=TextEditingController();
  Stream messageSnapshot;
  QuerySnapshot snapshot;


  Widget chatMessagesList(){  
    return StreamBuilder(
      stream: messageSnapshot,
      builder: (context,snapshot){
        
        return snapshot.hasData?ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            bool sendByMe=ds["sendBy"]==Constants.myName;
          return MessageTile(ds["messages"], sendByMe);
        }):Container();
    });
  }

  
  sendMessage()async{ 
    if(message.text.isNotEmpty){
   String data=await MyEncryption.encyption(message.text);

    var time=DateTime.now();
    Map <String,dynamic> messagesMap={
      "messages":data,
      "sendBy":Constants.myName,
      "ts":time
    };

    Map<String,dynamic> lastChatDetails={
      "lastMessage":message.text,
      "lastTime":time,
      "lastSendBy":Constants.myName,
    };
    
    dataBaseMethods.setLastDetails(widget.chatRoomId, lastChatDetails);
    

    dataBaseMethods.addConversationMessages(widget.chatRoomId, messagesMap);
    message.text="";
    }
  }


  getMessages()async{
    messageSnapshot=await dataBaseMethods.getConversationMessages(widget.chatRoomId);
      getData=true;
    setState(() {
    });
  }

  @override
  void initState(){
    getMessages();
    super.initState();
  } 

   
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body:Container(
        child:Stack(
          children: [
            Container(
              
              padding: EdgeInsets.only(bottom:80.0),
              child: getData?chatMessagesList():Container()),
            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(vertical:0.0,horizontal:10.0),
                child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:5.0),
                        child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                        hintText: "Type Message.....",
                        isDense:true ,
                        contentPadding: EdgeInsets.all(15.0),
                        focusedBorder: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.deepPurple)
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.deepPurple),
                        )
              ),
          ),
                      ),
                    ),
                    GestureDetector(
                          onTap: (){
                            sendMessage();
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom:5.0),
                          child: Container(
                            margin: EdgeInsets.only(left:5.0),
                            padding: EdgeInsets.symmetric(horizontal:15.0,vertical: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                            color: Colors.deepPurple,
                            ),
                            child: Icon(Icons.send,color: Colors.white),
                          ),
                        ),
                    )
                  ],
                ),
        ),
            ),
    ],
  ),
      ),);
  }

  }



  class MessageTile extends StatelessWidget {
    String message;
    bool sendByMe;
    MessageTile(this.message,this.sendByMe){
    }
    @override
    Widget build(BuildContext context) {
      return Container(
        alignment: sendByMe?Alignment.centerRight:Alignment.centerLeft,
        child: Container(
          margin:sendByMe?EdgeInsets.only(top:5.0,right:10.0,left:100.0,bottom:5.0):EdgeInsets.only(top:5.0,right:100.0,left:10.0,bottom:5.0),
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: sendByMe?BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)
                ):BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
                ),
                gradient: sendByMe?LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Color.fromRGBO(125, 0, 179, 1)
                  ]
                ):LinearGradient(
                  colors: [
                    Color.fromRGBO(179, 179, 179, 1),
                    Color.fromRGBO(153, 153, 153, 1)
                  ])
            ),
            child:Text(
              MyEncryption.decryption(message),
              style: TextStyle(
                fontSize: 17,
                color: sendByMe?Colors.white:Colors.black
              ),
              )
          ),
        )
      ); 
  }
}


