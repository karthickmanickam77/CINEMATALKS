import 'package:cinematalks/Moviedetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'movies.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            userLiked: true,
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/Rema.png',
                  height: 80,
                  width: 60,
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'CinemaTalks',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'AkayaTelivigala',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          elevation: 60,
          //shadowColor: Colors.white,
          backgroundColor: const Color(0xffFFD700),
        ),
        body: Container(
          color: Colors.grey,
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
                                  Color(0xff11152C),
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
                                fontSize: 25,
                                fontFamily: 'AkayaTelivigala',
                                color: Colors.amber,
                              ),
                            ),
                            subtitle: Text(
                              movieItems[index].description,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'IndieFlower',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                                        cast: movieItems[index].cast,
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
  }
}
/*decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xff25008F), Color(0xffA90037)],
),
),*/
