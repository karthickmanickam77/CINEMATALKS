import 'package:flutter/material.dart';
import 'About.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'main2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAppMain()),
        );
        return Future.value(false); // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Image.asset(
                      'lib/film.png',
                      height: 40,
                      width: 50,
                    ),
                  ),
                  const Text(
                    'CINEMA TALKS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 3.0),
                          blurRadius: 3.0,
                          color: Colors.grey,
                        ),
                      ],
                      fontFamily: 'KanitBlack',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 60,
          backgroundColor: Colors.lightBlueAccent,
          //shadowColor: Colors.white,
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.lightBlueAccent.shade100,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white54, Colors.white54],
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(2, 5),
                        ),
                      ],
                    ),
                    child: UserAccountsDrawerHeader(
                      accountName: Text(
                        loggedInUser?.displayName ??
                            'AUDIENCE', // Use 'User Name' if displayName is null
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 20,
                          fontFamily: 'KanitBlack',
                          color: Colors.black,
                        ),
                      ),
                      accountEmail: Text(
                        loggedInUser?.email ??
                            'example@example.com', // Use a default email if email is null
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 15,
                          fontFamily: 'KanitBlack',
                          color: Colors.black45,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: loggedInUser?.photoURL != null
                            ? NetworkImage(loggedInUser!.photoURL!)
                            : const AssetImage('lib/avatar.png')
                                as ImageProvider<Object>?,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage('lib/cover.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text(
                    "Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17,
                      fontFamily: 'KanitBlack',
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAppMain()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "About",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17,
                      fontFamily: 'KanitBlack',
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const about()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17,
                      fontFamily: 'KanitBlack',
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAppMain()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        if (messageText.isNotEmpty && loggedInUser != null) {
                          final currentTime = DateTime.now();

                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': loggedInUser?.email ?? 'user@gmail.com',
                            'name': loggedInUser?.displayName ??
                                loggedInUser?.email ??
                                'USER',
                            'timestamp': currentTime,
                          }).then((_) {
                            print("Message added successfully");
                          }).catchError((error) {
                            print("Error adding message: $error");
                          });
                        }
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
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messager = message['name'];

          print("messageSender: $messageSender");
          print("messager: $messager");

          final currentUser = loggedInUser?.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            name: messager,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.name,
      required this.isMe});

  final String sender;
  final String text;
  final bool isMe;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            (name.isNotEmpty)
                ? name
                : (sender.isNotEmpty)
                    ? sender
                    : 'DefaultName',
            // Display name or email
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
