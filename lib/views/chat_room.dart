import 'package:chat_app/sevices/constants.dart';
import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/sevices/firebase_auth.dart';
import 'package:chat_app/sevices/helper_functions.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
DataBaseMethods dataBaseMethods=DataBaseMethods();
class ChatRoom extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatRoom();
  }
}

class _ChatRoom extends State<ChatRoom>{
  AuthMethods authMethods=AuthMethods();
  bool getChats=false;
  Stream chatRoomsStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    HelperFunctions.getUserNameInfo().then((value) {
      setState(() {
      Constants.myName=value;
      });
    });

    dataBaseMethods.getChatRoom().then((value){
      setState(() {
        chatRoomsStream=value;
        getChats=true;
      });
    });
  }

  Widget getChatsList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData?ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            return GestureDetector(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationRoom(ds["ChatRoomId"],getUserName(ds["ChatRoomId"]))
                  ));
              },
              child: ChatTile(ds["ChatRoomId"],ds["lastMessage"],ds["lastTime"]));
          }
          ):Container();
      }
    );
  }

  

  @override
  Widget build(BuildContext context) {
    
    return(
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Chat App"),
          actions: [
            IconButton(
              icon:Icon(Icons.search,color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()
                ));
                
              },
            ),
            GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>SignIn()
                  ));
              },
                child: Container(
                padding: EdgeInsets.symmetric(horizontal:15),
                child: Icon(Icons.exit_to_app)
                ),
            ),
          ],
        ),

         body: getChats?Container(child: getChatsList()):Container(),
      )
    );
  }

}

 String getUserName(String temp){
    int length=temp.length;
    int index=temp.indexOf("_");
    if(Constants.myName==temp.substring(index+1,length)){
    return temp.substring(0,index);
    }else{
    return temp.substring(index+1,length);
    }
 }

 

class ChatTile extends StatelessWidget {
  String nameFirstLetter;
  String name;
  String lastMessage;
  Timestamp lastTime;
  String time;
  ChatTile(String temp,this.lastMessage,this.lastTime){
    name=getUserName(temp);
    nameFirstLetter=name[0];
    DateTime format =lastTime.toDate();
    time=DateFormat.jm().format(format);
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal:5.0,vertical:5.0),
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color:Colors.white),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                    
              BoxShadow(
                color:Colors.grey,
                  blurRadius:10.0,
                  spreadRadius:1.0,
                  offset:Offset(
                    1.0,1.0,  
                    ),
                  )
                ]
              ),
        child: Column(
          children: [ 
            Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.deepPurple
                      ),
                      child:Padding(
                        padding: EdgeInsets.symmetric(horizontal:25.0,vertical:20.0),
                        child: Text(
                          nameFirstLetter.toUpperCase(),
                          style:TextStyle(
                            color:Colors.white,
                            fontSize: 25
                          )
                          ),
                      ),
                    ),
                    Expanded(
                      
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 18
                            ),),
                            Padding(
                            padding: const EdgeInsets.symmetric(horizontal:5.0),
                            child: Text(
                            time,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14
                            ),),
                          ),
                        ],
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical:5.0),
                      child: Row(
                        children: [
                          Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 16
                          ),),
                          
                        ],
                      ),
                    )
                    ],
                  ),
                )
                  ],
                  
                ),
              ),     
          ],
        ),
    );
  }
}