import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
User Loggedinuser;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final messgaeTextController = TextEditingController();

  String messagetext;
  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        Loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                // ignore: unnecessary_statements
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ));
                  }
                  final messages = snapshot.data.docs.reversed;
                  List<messagebubble> message = [];
                  for (var mess in messages) {
                    final mtext = mess['text'];
                    final msender = mess['sender'];
                    final currentuser = Loggedinuser.email;
                    final mymessage = messagebubble(
                      sender: msender,
                      text: mtext,
                      itsme: currentuser==msender,
                    );
                    message.add(mymessage);
                  }
                  return Expanded(
                      child: ListView(
                        reverse: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          children: message));
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: messgaeTextController,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      messgaeTextController.clear();
                      _firestore.collection('messages').add(
                          {'text': messagetext, 'sender': Loggedinuser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messagebubble extends StatelessWidget {
  messagebubble({this.text, this.sender,this.itsme});
  final String sender, text;
  final bool itsme ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: (itsme==false)?CrossAxisAlignment.start:CrossAxisAlignment.end,
      children: [
        Text('$sender',style: TextStyle(color: Colors.black54,fontSize: 12.0),),
        Material(
        borderRadius: BorderRadius.only(topLeft: (itsme==true)?Radius.circular(30):Radius.circular(0),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30.0),topRight: (itsme==true)?Radius.circular(0):Radius.circular(30)),
        elevation: 5.0,
        color: (itsme==false)?Colors.white:Colors.lightBlueAccent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Text(
            '$text',
            style: TextStyle(color:itsme==false?Colors.lightBlueAccent: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
          ),
        ),
      )]),
    );
  }
}
