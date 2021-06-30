import 'package:chat_app/sevices/constants.dart';
import 'package:chat_app/sevices/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
bool isSearching=false;
bool isSearched=false;
bool notFound=false;
bool alreadyExist=false;

  DataBaseMethods dataBaseMethods=DataBaseMethods();
  Stream userStream,usersListStream;


  
  searchUser(String value)async{

    setState(() {
    isSearching=true;
    alreadyExist=false;
      
    });
    userStream=await dataBaseMethods.getUserByUserName(value);
    setState(() {
      isSearched=true;
    });
  }

createChatRoomAndConversation(String username){
  if(username!=Constants.myName){
        
  String chatRoomId=getChatRoomId(username, Constants.myName);
  var time=DateTime.now();
  List <String> users=[username,Constants.myName];
  Map<String,dynamic> chatRoomMap={
    "users":users,
    "ChatRoomId":chatRoomId,
    "lastMessage":"",
    "lastTime":time,
    "lastSendBy":Constants.myName
  };

  dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context)=>ConversationRoom(chatRoomId,username)
    ));

      }else{
        setState(() {
           alreadyExist=true;
          isSearched=false;
        });
      }
  
  }


  



  Widget searchList(){
    return StreamBuilder(
      stream: userStream,
      builder: (context,snapshot){
        return snapshot.hasData?ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
          DocumentSnapshot ds=snapshot.data.docs[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical:10.0,horizontal:10.0),
            margin: EdgeInsets.symmetric(vertical:5.0),
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
              child:Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text(
                        ds["name"],
                        style: TextStyle(
                          fontSize: 16
                        ),
                       ),                            GestureDetector(
                        onTap: (){
                          createChatRoomAndConversation(ds["name"]);
                        },
                        child: Container(
                           margin: EdgeInsets.symmetric(vertical:10.0),
                            padding: EdgeInsets.symmetric(vertical:8.0,horizontal:8.0),
                            alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.deepPurple
                              ),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                fontSize: 16,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                      padding: EdgeInsets.only(top:5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ds["email"],
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ))
                      ],

                    ),
              );
          }):Center(
            child:CircularProgressIndicator()
          );
      },
    );
  }


getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}



  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:getAppBar(context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:20),
        child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical:20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter the full user name here.....",
                      isDense:true ,
                      contentPadding: EdgeInsets.all(10.0),
                      prefixIcon: Icon(Icons.search),
                       focusedBorder: OutlineInputBorder(
                         borderRadius:BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.deepPurple)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        )
                    ),
                    onSubmitted: (value){
                      searchUser(value.toLowerCase());
                    },
                    
                    
                    
                  ),
                ),
               
                isSearching && isSearched?searchList():Container(),
                alreadyExist?Text(
                  "This user is already in your Chat list.",
                  textAlign: TextAlign.center,
                  style:TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                  ):Container()
              ],
            ),
      ),    
        );
  }
}
