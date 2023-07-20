import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movies.dart';
import 'package:cinematalks/ChatRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main2.dart';

class Poll extends StatefulWidget {
  const Poll({Key? key}) : super(key: key);

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  List<Movies> movieItems = [];
  int? selectedIndex;
  int? selectedOption;

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
            li: movie['li'],
          ),
        )
        .toList();

    setState(() {
      movieItems = list;
    });
  }

  void handleOptionSelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedOption = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  ListTile(
                    title: Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 17,
                        fontFamily: 'KanitBlack',
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppMain()),
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff42A974),
                Color(0xff38A39B),
                Color(0xff299BD4),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: movieItems.length,
            itemBuilder: (context, index) {
              final movie = movieItems[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Colors.blue
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                child: ListTile(
                  onTap: () => handleOptionSelected(index),
                  title: Text(
                    movie.name,
                    style: TextStyle(
                      color:
                          selectedIndex == index ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: selectedIndex == index && selectedOption == 100
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "100%",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : null,
                  leading: Image.network(
                    movie.image,
                    height: 80,
                    width: 80,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
