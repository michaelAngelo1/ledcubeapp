import 'dart:async';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledcubeapp/constants.dart';
import 'package:ledcubeapp/controller/handle_choose_animation.dart';
import 'package:ledcubeapp/controller/handle_play_animation.dart';
import 'package:ledcubeapp/model/indicator_rtdb_model.dart';
import 'package:ledcubeapp/model/selected_rtdb_model.dart';
import 'package:video_player/video_player.dart';

final db = FirebaseFirestore.instance;

Future<List<String>> getDocumentID() async {
  CollectionReference collectionReference = db.collection("LAMBDA_8");
  QuerySnapshot snapshot = await collectionReference.get();
  return snapshot.docs.map((DocumentSnapshot doc) => doc.id).toList();
}

Future<Object> isSelectedAnimation(DatabaseReference ledStateChild, String animation) async {
  final snap = await ledStateChild.get();
  return snap.value!;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rtdb = FirebaseDatabase.instance.ref();
  late StreamController<List<String>> _animationListController;
  late Stream<List<String>> _animationListStream;
  late DatabaseReference ledStateChild;
  late DatabaseReference indicatorChild;
  List<String>? animations;

  // VIDEO PLAYER
  late CustomVideoPlayerController _customVideoPlayerController;
  String videoPath = "assets/rain.mp4";


  Future<void> _updateAnimationList() async {
    try {
      animations = await getDocumentID();
      _animationListController.add(animations!);
    } catch (e) {
      print("Error updating animation list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _animationListController = StreamController<List<String>>.broadcast();
    _animationListStream = _animationListController.stream;
    ledStateChild = rtdb.child("ledState");
    indicatorChild = rtdb.child("ledState");
    Indicator.indicatorOnValueListen(indicatorChild);
    Selected.selectedOnValueListen(rtdb.child('ledState'));
    _updateAnimationList();

    db.collection("LAMBDA_8").snapshots().listen((event) {
      _updateAnimationList();
    });


    // INITIALIZE VIDEO PLAYER
    initializeVideoPlayer();
    // Notify the state that initialization is complete
    setState(() {});
  }

  @override
  void dispose() {

    _animationListController.close();
    super.dispose();
  }

  double containerHeight = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 11, 60, 135),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12.0),
            Text(
              "Coobie",
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "by JL MA JB",
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 11, 60, 135),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                "Choose from the list of animations",
                style: GoogleFonts.montserrat(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: StreamBuilder<List<String>>(
                  stream: _animationListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 30,
                        ),
                        itemBuilder: (context, index) {
                          String animation = animations![index];
                          debugPrint("DEBUG ANIMATION: $animation");
                          return Container(
                            margin: const EdgeInsets.only(bottom: defaultPadding),
                            height: containerHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue[900]!.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              // border: Border.all(
                              //   color: Colors.white,
                              //   width: 3.0,
                              // ),
                              color: Selected.animation == snapshot.data![index]
                                  ? const Color(0xffad9c00)
                                  : Colors.blue[900],
                            ),
                            child: InkWell(
                              onTap: () => setState(() {
                                HandleChooseAnimation.handleChooseAnimation(
                                  ledStateChild, snapshot.data![index]);
                              }),
                              onLongPress: () {
                                setState(() {
                                  if (Selected.animation == snapshot.data![index]) {
                                    containerHeight = 30;
                                  }
                                });
                              },
                              child: 
                                Stack(
                                  children: [
                                    // SizedBox(
                                    //   height: 300,
                                    //   width: 300,
                                    //   child: CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController,)
                                    // ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(defaultPadding + 8),
                                          child: Text(
                                            snapshot.data![index],
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: Colors.transparent,
                                            width: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 1,
            focusElevation: 1.0,
            // double? hoverElevation,
            // double? highlightElevation,
            splashColor: const Color(0xffad9c00),
            onPressed: () => setState(() {
              HandlePlayAnimation.handlePlayAnimation(indicatorChild);
            }),
            backgroundColor: Indicator.on ? const Color(0xffad9c00) : const Color.fromARGB(255, 11, 60, 135),
            child: Icon(
              Indicator.on ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void initializeVideoPlayer() {
    VideoPlayerController videoPlayerController; 
    videoPlayerController = VideoPlayerController.asset(videoPath)
      ..initialize()
      .then((value) {
        setState(() {
          
        });
      });
    
    _customVideoPlayerController = CustomVideoPlayerController(context: context, videoPlayerController: videoPlayerController);
  }
}
