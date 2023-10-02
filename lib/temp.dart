import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'SlideTrans.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main2.dart';

class Mdetails extends StatefulWidget {
  final String name, image, desc, imdb, tr, pr, kr, toi, public, google, li;
  const Mdetails({
    Key? key,
    required this.name,
    required this.image,
    required this.desc,
    required this.imdb,
    required this.tr,
    required this.pr,
    required this.kr,
    required this.toi,
    required this.public,
    required this.google,
    required this.li,
  }) : super(key: key);

  @override
  State<Mdetails> createState() => _MdetailsState();
}

class _MdetailsState extends State<Mdetails> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    var videoId = YoutubePlayer.convertUrlToId(widget.li) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
      ),
    )..addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_controller!.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  double value = 0;
  double opinion = 0;
  double decide(String decision) {
    double rating = 0;
    if (decision == 'Very Good') {
      rating = 0.8;
    } else if (decision == 'Excellent') {
      rating = 1;
    } else if (decision == 'Good' || decision == 'Average') {
      rating = 0.6;
    } else if (decision == 'Okay' || decision == '1 time') {
      rating = 0.4;
    } else if (decision == 'Bad') {
      rating = 0.2;
    } else if (decision == 'Waste') {
      rating = 0.1;
    }
    return rating;
  }

  late double perc = decide(widget.public) * 100;

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
          flexibleSpace: AppBar(
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
                    Color(0xff25008F),
                    Color(0xffA90037),
                  ],
                ),
              ),
            ),
            //shadowColor: Colors.white,
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
                  Color(0xff25008F),
                  Color(0xffA90037),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white54,
                          Colors.white54,
                        ],
                      ),
                      //color: Color(0xff21E1B0).withOpacity(0.5),
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: UserAccountsDrawerHeader(
                        accountName: Text(
                          "${user.displayName}",
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
                          backgroundImage: NetworkImage(
                            user.photoURL!,
                          ),
                        ),
                        decoration: const BoxDecoration(
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
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text(
                    "Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17,
                      fontFamily: 'KanitBlack',
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAppMain(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17,
                      fontFamily: 'KanitBlack',
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAppMain(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff25008F), Color(0xffA90037)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF).withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SlideTransitionImage(
                        imageUrl: widget.image,
                        duration:
                            Duration(microseconds: (0.9 * 1000000).round()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 8),
                          child: Text(
                            'Story : ${widget.desc}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Column(
                      children: [
                        const Text(
                          'Public Review : ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'GentiumBookPlus',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 2000,
                          radius: 100,
                          lineWidth: 20,
                          percent: decide(widget.public),
                          progressColor: Colors.limeAccent,
                          backgroundColor: Colors.white60,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            '$perc %',
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          Text(
                            'IMDB: ${widget.imdb}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.deepOrange,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 90),
                          Text(
                            'TAMIL TALKIES: ${widget.tr}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 6, top: 12),
                      child: Row(
                        children: [
                          Text(
                            "Kalki's Review: ${widget.kr}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Prasand Review: ${widget.pr}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 6, top: 15),
                      child: Row(
                        children: [
                          Text(
                            "Google users Review: ${widget.google}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Times Of India: ${widget.toi}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'GentiumBookPlus',
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 5.0, left: 5.0, bottom: 10.0),
                      child: YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
