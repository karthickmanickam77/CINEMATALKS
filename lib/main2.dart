import 'package:cinematalks/ChatRoom.dart';
import 'package:cinematalks/Moviedetails.dart';
import 'package:cinematalks/Poll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'movies.dart';
import 'Poll.dart';
import 'main1.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyAppMain());
}

class MyAppMain extends StatefulWidget {
  const MyAppMain({Key? key}) : super(key: key);

  @override
  State<MyAppMain> createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
  List<Movies> movieItems = [];
  @override
  void initState() {
    super.initState();
    fetchRecords();
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
              li: movie['li']),
        )
        .toList();

    setState(() {
      movieItems = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
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
            child: Material(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
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
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white54,
                              Colors.white54,
                            ],
                          ),
                          //color: Color(0xff21E1B0).withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: UserAccountsDrawerHeader(
                            accountName: Text(
                              "${user.displayName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 20,
                                fontFamily: 'KanitBlack',
                                color: Colors.white,
                              ),
                            ),
                            accountEmail: Text(
                              "${user.email}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 15,
                                fontFamily: 'KanitBlack',
                                color: Colors.black45,
                              ),
                            ),
                            currentAccountPicture: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.photoURL!,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage(
                                  'lib/cover.jpg',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text(
                        "Poll",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 17,
                          fontFamily: 'KanitBlack',
                          color: Colors.black,
                        ),
                      ),
                      leading: Icon(
                        Icons.poll_outlined,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Poll(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 17,
                          fontFamily: 'KanitBlack',
                          color: Colors.black,
                        ),
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyAppMain(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                      return SingleChildScrollView(
                        child: Column(
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
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Mdetails(
                                            name: movieItems[index].name,
                                            image: movieItems[index].image,
                                            desc: movieItems[index].description,
                                            imdb: movieItems[index].imdb,
                                            tr: movieItems[index].tr,
                                            pr: movieItems[index].pr,
                                            kr: movieItems[index].kr,
                                            toi: movieItems[index].toi,
                                            public: movieItems[index].public,
                                            google: movieItems[index].google,
                                            li: movieItems[index].li,
                                          )));
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        );
      }),
    );
  }
}
/*decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xff25008F), Color(0xffA90037)],
),
),*/
