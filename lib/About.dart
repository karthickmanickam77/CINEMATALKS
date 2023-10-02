import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movies.dart';
import 'main2.dart';

class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
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
            li: movie['li'],
            userLiked: movie['userLiked'],
            likes: movie['likes'],
            cast: movie['cast'],
          ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
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
                    ListTile(
                      title: const Text(
                        "Delete Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 17,
                          fontFamily: 'KanitBlack',
                          color: Colors.black,
                        ),
                      ),
                      leading: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        // Show a confirmation dialog
                        // Check if the user's email is not equal to "demo"
                        if (user.email != "democinematalks@gmail.com") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm Account Deletion"),
                                content: const Text(
                                    "Are you sure you want to delete your account? This action cannot be undone."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance.currentUser
                                            ?.delete();
                                        // Account deleted successfully, navigate to the sign-in or home screen
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyAppMain(),
                                          ),
                                        );
                                      } catch (e) {
                                        print("Account deletion error: $e");
                                        // Handle error, display a message to the user, etc.
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Show something else when the condition is not met
                          // For example, display a message or navigate to a different screen
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    "You are not able to delete this Account"),
                                content: const Text(
                                    "Because This is a demo Account used for testing purpose it need to avail all the time."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF).withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    // color: Colors.white38,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const Text(
                            """Introducing "Cinema Talks" – Your Authentic Movie Review Hub!

        Cinema Talks is a genuine and dedicated movie review app designed exclusively for cinema enthusiasts like you. Say goodbye to sifting through endless reviews and welcome a platform where real moviegoers share their candid opinions, helping you make informed decisions about your next movie experience.

        With Cinema Talks, you'll gain access to a vibrant community of fellow film lovers who love to share their thoughts and insights on the latest blockbusters, timeless classics, and hidden gems. Dive into engaging discussions, discover unique perspectives, and find your perfect movie match based on authentic, heartfelt reviews.

        Our commitment to providing appropriate content ensures a safe and inclusive space for users of all ages. Say hello to constructive feedback, valuable critiques, and genuine recommendations that resonate with your tastes.

        Navigate through an intuitive interface, explore diverse genres, and stay up-to-date with the latest movie ratings and reviews. Cinema Talks empowers you to take control of your movie-watching experience, making it easier than ever to find that movie that truly speaks to you.

        Are you ready to embark on a cinematic journey filled with genuine conversations? Look no further than Cinema Talks – your ultimate companion for all things movies!""",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'GentiumBookPlus',
                              letterSpacing: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'PUBLIC REVIEW SCORE BASED ON:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Table(
                            border:
                                TableBorder.all(), // Add borders around cells
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            // Align content vertically

                            children: const [
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Text(
                                    'Percentage ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )), // Header cell
                                  TableCell(
                                      child: Text(
                                    'Meaning',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )), // Header cell
                                  // Header cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('100')), // Data cell
                                  TableCell(
                                      child: Text('Excellent')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('90')), // Data cell
                                  TableCell(
                                      child: Text('Impressive')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('80')), // Data cell
                                  TableCell(
                                      child: Text('Very Good')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('70')), // Data cell
                                  TableCell(
                                      child: Text('Satisfied')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('60')), // Data cell
                                  TableCell(child: Text('Good')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('50')), // Data cell
                                  TableCell(
                                      child: Text('Average')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('40')), // Data cell
                                  TableCell(child: Text('Okay')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('30')), // Data cell
                                  TableCell(child: Text('1 time')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('20')), // Data cell
                                  TableCell(child: Text('Bad')), // Data cell
                                  // Data cell
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(child: Text('10')), // Data cell
                                  TableCell(child: Text('Waste')), // Data cell
                                  // Data cell
                                ],
                              ),
                              // Add more rows here...
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            """Fair Use Disclaimer: Include a disclaimer in your app's terms of use or disclaimer section stating that certain content used within the app may be subject to the fair use policy. Explain that fair use is a legal doctrine that allows limited use of copyrighted material without permission or licensing fees for specific purposes.

Educational and Non-Commercial Use: Clarify that the app's purpose is primarily educational, informational, or non-commercial in nature. State that the use of copyrighted material is intended for transformative purposes, such as criticism, commentary, research, or parody.

Four Factors Consideration: Inform users that the app's use of copyrighted material is evaluated based on the four fair use factors - purpose and character of use, nature of the copyrighted work, amount and substantiality of the portion used, and effect on the potential market or value of the original work.

Case-by-Case Basis: Emphasize that fair use is determined on a case-by-case basis, and there are no fixed rules or thresholds for determining fair use. Each situation is evaluated individually, and the determination may vary based on the specific circumstances.

Copyright Compliance: Encourage users to respect copyright laws and guidelines. Remind them that the fair use policy is not a blanket permission to use any copyrighted material without restriction. Users should be cautious and consider seeking permission for use when necessary.

Copyright Owners: Advise users to provide proper attribution and credit to the original copyright owners when using their work within the app. Provide guidelines on how to give appropriate credit for the content used.

Reporting Copyright Infringement: Establish a process for copyright owners to report any potential infringement within the app. Provide contact information or a reporting mechanism for copyright takedown requests.

Legal Notice: Include a legal notice stating that while the app aims to comply with copyright laws and the fair use policy, the app developer and owners are not responsible for any misuse or unauthorized use of copyrighted material by users.""",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'GentiumBookPlus',
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'With the Support of TEAMTECHSQUAD',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'TiltPrism',
                                letterSpacing: 1.5,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Image.asset(
                            'lib/TEAM.png',
                            height: 260,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
