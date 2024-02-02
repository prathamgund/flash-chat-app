import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;
  final _firestore = FirebaseFirestore.instance;
  var textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = _auth.currentUser;
    if(user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    } else{
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs.reversed;
                  List<MessageBubble> messageWidgets = [];

                  for (var element in messages) {
                    final messageText = element['text'];
                    final messageSender = element['sender'];

                    final currentUser = loggedInUser.email;
                    
                    final messageWidget = MessageBubble(
                      messageText: messageText, 
                      messageSender: messageSender, isMe: currentUser == messageSender,
                      );
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                        children: messageWidgets,
                      ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(top: 200.0),
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              },
              stream: _firestore
              .collection('messages')
              .orderBy("timestamp")
              .snapshots()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      textController.clear();
                      getCurrentUser();
                      _firestore.collection('messages').add(
                        {"sender": loggedInUser.email, 
                        "text": messageText,
                        "timestamp": FieldValue.serverTimestamp()
                        });
                    },
                    child: const Text(
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.messageText,
    required this.messageSender,
    required this.isMe,
  });

  final dynamic messageText;
  final dynamic messageSender;
  final dynamic isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender, 
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$messageText',
                style: TextStyle( 
                  color: isMe ? Colors.white : Colors.black, fontSize: 16.0),
                ),
            ),
              ),
        ],
      ),
    );
  }
}
