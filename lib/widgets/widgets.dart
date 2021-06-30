import 'package:flutter/material.dart';

Widget getAppBar(BuildContext context){
  return AppBar(
    title:Text("Chat App")
  );
}

Widget getImage(AssetImage assetImage,BuildContext context) {
  var padding=MediaQuery.of(context).padding;
  Image image = Image(image: assetImage,
  height: (MediaQuery.of(context).size.height-padding.top-kToolbarHeight)*0.4,
  width: MediaQuery.of(context).size.width*0.7,
  fit: BoxFit.fill);
  return Container(
    child: image,
    padding: EdgeInsets.only(bottom:10.0),
    // margin: EdgeInsets.symmetric(vertical:20.0),
  );
}


InputDecoration textFieldDecoration(BuildContext context,String label,String hint){
  return InputDecoration(
                labelText: label,
                hintText:hint,
                isDense:true ,
                contentPadding: EdgeInsets.all(12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(5.0)
                )
              );

}

Container getButton(BuildContext context,String text,Color buttonColor,Color textColor ){
  return Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical:12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: buttonColor
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor
                  ),
                  ),
              );
}