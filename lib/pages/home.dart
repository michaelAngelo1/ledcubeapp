import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledcubeapp/constants.dart';
import 'package:ledcubeapp/controller/handle_choose_animation.dart';
import 'package:ledcubeapp/controller/handle_play_animation.dart';
import 'package:ledcubeapp/model/indicator_rtdb_model.dart';
import 'package:ledcubeapp/model/selected_rtdb_model.dart';

// Firestore global instance
final db = FirebaseFirestore.instance;

Future<List<String>> getDocumentID() async {
  CollectionReference collectionReference = db.collection("LAMBDA_8");
  QuerySnapshot snapshot = await collectionReference.get();
  List<String> documentIds = snapshot.docs.map((DocumentSnapshot doc) => doc.id).toList();
  return documentIds;
}

Future<Object> isSelectedAnimation(DatabaseReference ledStateChild, String animation) async {
  final snap = await ledStateChild.get();
  return snap.value!;  
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final rtdb = FirebaseDatabase.instance.ref();
  late Future<List<String>> animationList;

  @override
  void initState() {
    super.initState(); 
    animationList = getDocumentID();
    Indicator.indicatorOnValueListen(rtdb.child("ledState"));
    Selected.selectedOnValueListen(rtdb.child('ledState'));
  }

  @override
  Widget build(BuildContext context) {
    final ledStateChild = rtdb.child("ledState");
    final indicatorChild = rtdb.child("ledState");
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Gigalux",
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            )
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                  color: Colors.blue,
                )
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: animationList,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8), 
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: defaultPadding),
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Selected.animation == snapshot.data![index] ? Colors.green : Colors.blue,
                            ),
                            child: InkWell(
                              onTap: () => setState(() {
                                HandleChooseAnimation.handleChooseAnimation(ledStateChild, snapshot.data![index]);
                              }),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(defaultPadding + 8),
                                    child: Text(
                                      snapshot.data![index],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Colors.transparent,
                                      width: 100,
                                    )
                                  ),
                                ],
                              )
                            )
                          );
                        }
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                ),
              )
            ],
          )
        )
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => setState(() {
              HandlePlayAnimation.handlePlayAnimation(indicatorChild);
            }),
            backgroundColor: Indicator.on ? Colors.white : Colors.blue,
            child: Icon(
              Indicator.on ? Icons.pause : Icons.play_arrow,
              color: Indicator.on ? Colors.blue : Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}