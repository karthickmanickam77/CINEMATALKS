import 'package:flutter/material.dart';
import 'main1.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Gscreen()),
            );
            return Future.value(false); // Prevent default back button behavior
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Instructions'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Login Credentials Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please note the following requirements when providing login credentials:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You can Access it via Google and Email to get access to the main page.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      '\nYou can simply tap sign in via google to sign in via google account and if you don\'t have an account it will be created.\n'
                      '\nAnd If you Want to Sign in via Email then you need to tap the '
                      'signin via Email and it will redirect you to the page in that '
                      'page you are able to sign in if you already had an account and '
                      'remember your password if you don\'t had an account by tapping the '
                      'create new account you will be able to create new account.\n\nYour Password and info all are store in a Firebase so there will no issues in that.\n\nAnd if you want to delete Account in the About'
                      'Page you will found out the option delete account after the conformation your account will'
                      'be deleted and forgot password also available so you are able to reset your password '
                      'and all that are take care of firebase they send you the link and after that you will be able '
                      'to reset your password \n If you are facing any issues in deletion of account or anything else contact us by the info below.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\nEmail and password should be in format and if you want to contact us \nEmail:karthickmanickam77@gmail.com',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(
                            "https://accountdeletion-cinematalks.web.app/");
                        await launchUrl(url);
                      },
                      child: const Text(
                        'Click here for Account Deletion and any other issues',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue, // Make it look like a link.
                          decoration:
                              TextDecoration.underline, // Add underline.
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
