import 'package:cinematalks/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'email.dart';
import 'help.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //GoogleSignIn.init();
  runApp(const Gscreen());
}

class Gscreen extends StatelessWidget {
  const Gscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(builder: (context) {
            return Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff42A974),
                      Color(0xff38A39B),
                      Color(0xff299BD4),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Welcome To Cinema Talks',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'KanitBlack',
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.white54,
                                  Colors.white54,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    'lib/tape.png',
                                    height: 30,
                                    width: 60,
                                  ),
                                ),
                                const Text(
                                  'Find Out Your Movie',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontFamily: 'Julee',
                                    color: Colors.lightBlue,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'CINEMA TALKS',
                                    textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'KanitBlack',
                                      color: Colors.black,
                                    ),
                                    speed: const Duration(milliseconds: 200),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/chaplin.png',
                            height: 140,
                            width: 50,
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Image.asset(
                            'lib/coupon.png',
                            height: 90,
                            width: 190,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 230,
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.redAccent,
                              ),
                              label: const Text('Sign Up with Google'),
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.googleLogin();
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.voicemail,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Navigate to your email/password login screen
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const EmailLoginPage(),
                                ));
                              },
                              label: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text('Sign In with Email'),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InstructionsPage()),
                                  );
                                },
                                child: const Text(
                                  'Help',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
}
