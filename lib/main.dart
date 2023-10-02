import 'package:cinematalks/main2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main1.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //GoogleSignIn.init();
  runApp(const Directionality(
    textDirection: TextDirection.ltr,
    child: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const MyAppMain();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something Went Wrong'),
              );
            } else {
              return const Gscreen();
            }
          },
        ),
      );
}
