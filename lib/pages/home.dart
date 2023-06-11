import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ledcubeapp/constants.dart';

import '../firebase/firestore_objects.dart';

// Firestore global instance
final db = FirebaseFirestore.instance;

// Read firestore
Future<City> fetchCity() async {
  
  final ref = db.collection("test cities").doc("SF").withConverter(
      fromFirestore: City.fromFirestore,
      toFirestore: (City city, _) => city.toFirestore(),
    );

  final docSnap = await ref.get();
  final city = docSnap.data(); // Convert to City object
  if (city != null) {
    return city;
  } else {
    throw Exception("Error reading firestore");
  }
}

Future<List<String>> getDocumentID() async {
  CollectionReference collectionReference = db.collection("LAMBDA_8");
  QuerySnapshot snapshot = await collectionReference.get();
  List<String> documentIds = snapshot.docs.map((DocumentSnapshot doc) => doc.id).toList();
  return documentIds;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final rtdb = FirebaseDatabase.instance.ref();
  bool animationState = false;
  bool ledState = false;
  late Future<City> animationData;
  late Future<List<String>> animationList;

  @override
  void initState() {
    super.initState();
    animationData = fetchCity();  
    animationList = getDocumentID();
  }

  // Watch user state
  final user = FirebaseAuth.instance.currentUser!;

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // final testRef = db.child("test");
    final testRefChild = rtdb.child("ledState");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
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
                              color: animationState ? Colors.green : Colors.blue,
                            ),
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  animationState = !animationState;
                                  testRefChild.set({
                                    'on': animationState,
                                  });
                                  debugPrint(animationState.toString());
                                });
                              },
                              child: Center(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(defaultPadding + 8),
                                      child: Text(
                                        snapshot.data![index],
                                        style: const TextStyle(
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
                                ),
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
            onPressed: () {
              setState(() {
                ledState = !ledState;
              });
            },
            child: Icon(ledState ? Icons.pause : Icons.play_arrow),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}