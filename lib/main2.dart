import 'dart:async';
import 'package:cinematalks/About.dart';
import 'package:cinematalks/ChatRoom.dart';
import 'package:cinematalks/Moviedetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAppMain());
}

Future<void> checkUserAuthentication() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;

  if (user != null) {
    // User is signed in.
    print('User is signed in with email: ${user.email}');

    // Here, you can also perform additional checks if needed.
    // For example, query Firebase Firestore or Realtime Database to see if user data exists.

    // Check if the user is still valid (account not deleted or disabled).
    await user.reload(); // Refresh user data
    final refreshedUser = _auth.currentUser;

    if (refreshedUser == null) {
      // The user's account has been deleted or disabled.
      print('User account is no longer valid.');
      // Perform actions for account deletion.
    }
  } else {
    // User is not signed in.
    print('User is not signed in.');
    // You can take appropriate action here, such as showing a login screen.
  }
}

class MyAppMain extends StatefulWidget {
  const MyAppMain({Key? key}) : super(key: key);

  @override
  State<MyAppMain> createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
  List<Movies> movieItems = [];
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isme = false;
  bool isLiked = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
    fetchRecords();
    precacheImages(movieItems);

    // Add this timer
    Timer.periodic(Duration(seconds: 10), (timer) {
      checkUserAuthentication();
    });
  }

  getConnectivity() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    setState(() => isAlertSet = !isDeviceConnected);

    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() => isDeviceConnected = result != ConnectivityResult.none);

        if (!isDeviceConnected && !isAlertSet) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  fetchRecords() async {
    var records =
        await FirebaseFirestore.instance.collection('Movie_items').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map(
          (movie) => Movies(
            id: movie.id,
            description: movie['Description'],
            name: movie['name'],
            image: movie['image'],
            imdb: movie['imdb'],
            tr: movie['tr'],
            pr: movie['pr'],
            kr: movie['kr'],
            toi: movie['toi'],
            public: movie['public'],
            google: movie['google'],
            li: movie['li'],
            cast: movie['cast'],
            userLiked: false, // Initialize to false by default
            likes: movie['likes'] ?? 0,
          ),
        )
        .toList();

    setState(() {
      movieItems = list;
    });
  }

  void precacheImages(List<Movies> movieItems) {
    for (var item in movieItems) {
      precacheImage(NetworkImage(item.image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff42A974),
                    Color(0xff38A39B),
                    Color(0xff299BD4),
                  ],
                ),
              ),
            ),
            //shadowColor: Colors.white,
          ),
          drawer: Drawer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff42A974),
                    Color(0xff38A39B),
                    Color(0xff299BD4),
                  ],
                ),
              ),
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
                        user.displayName ?? 'AUDIENCE',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 20,
                          fontFamily: 'KanitBlack',
                          color: Colors.white,
                        ),
                      ),
                      accountEmail: Text(
                        "${user.email}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 15,
                          fontFamily: 'KanitBlack',
                          color: Colors.black45,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text(
                      "Chat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 17,
                        fontFamily: 'KanitBlack',
                        color: Colors.black,
                      ),
                    ),
                    leading: const Icon(
                      Icons.chat,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatScreen()),
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
          body: Scrollbar(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff42A974),
                    Color(0xff38A39B),
                    Color(0xff299BD4),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 18),
                child: ListView.builder(
                  padding: const EdgeInsets.only(right: 10.0),
                  itemCount: movieItems.length,
                  itemBuilder: (context, index) {
                    String movieName = movieItems[index].name;

                    return Column(
                      children: [
                        const SizedBox(
                          height: 11,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff299BD4),
                                  //Color(0xff11152C),
                                  Color(0xff244B8C),
                                  Color(0xff202124),
                                ],
                              ),
                              //color: Color(0xff21E1B0).withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            children: [
                              Flexible(
                                child: ListTile(
                                  leading: Image.network(
                                    movieItems[index].image,
                                  ),
                                  title: Text(
                                    movieItems[index].name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      letterSpacing: 2,
                                      //height: 1,
                                      fontFamily: 'KanitBlack',
                                      color: Colors.white70,
                                    ),
                                  ),
                                  subtitle: Text(
                                    movieItems[index].description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'GentiumBookPlus',
                                      letterSpacing: 1,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Mdetails(
                                                  name: movieName,
                                                  image:
                                                      movieItems[index].image,
                                                  desc: movieItems[index]
                                                      .description,
                                                  imdb: movieItems[index].imdb,
                                                  tr: movieItems[index].tr,
                                                  pr: movieItems[index].pr,
                                                  kr: movieItems[index].kr,
                                                  toi: movieItems[index].toi,
                                                  public:
                                                      movieItems[index].public,
                                                  google:
                                                      movieItems[index].google,
                                                  li: movieItems[index].li,
                                                  cast: movieItems[index].cast,
                                                )));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        QuerySnapshot<Map<String, dynamic>>
                                            querySnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('like_details')
                                                .where('email',
                                                    isEqualTo: user.email)
                                                .where('movieName',
                                                    isEqualTo:
                                                        movieItems[index].name)
                                                .get();

                                        if (querySnapshot.docs.isEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('like_details')
                                              .add({
                                            'email': user.email,
                                            'movieName': movieItems[index].name,
                                            'status': 'liked',
                                          });

                                          QuerySnapshot<Map<String, dynamic>>
                                              movieQuerySnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('Movie_items')
                                                  .where('name',
                                                      isEqualTo:
                                                          movieItems[index]
                                                              .name)
                                                  .get();

                                          if (movieQuerySnapshot
                                              .docs.isNotEmpty) {
                                            DocumentSnapshot<
                                                    Map<String, dynamic>>
                                                movieDocSnapshot =
                                                movieQuerySnapshot.docs.first;
                                            int currentLikes =
                                                movieDocSnapshot['likes'] ?? 0;

                                            await movieDocSnapshot.reference
                                                .update({
                                              'likes': currentLikes + 1,
                                            });

                                            setState(() {
                                              movieItems[index].likes =
                                                  currentLikes + 1;
                                              movieItems[index].userLiked =
                                                  true;
                                            });
                                          }
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeInOut,
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  movieItems[index].userLiked
                                                      ? 1.2
                                                      : 1.0),
                                            child: Icon(
                                              Icons.thumb_up_alt_rounded,
                                              color: movieItems[index].userLiked
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${movieItems[index].likes}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
/*decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xff25008F), Color(0xffA90037)],
),
),*/
