import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool ledState = false;
  late Future<City> animationData;
  late Future<List<String>> animationList;

  @override
  void initState() {
    super.initState();
    animationData = fetchCity();  
    animationList = getDocumentID();
  }

  @override
  Widget build(BuildContext context) {
    // final testRef = db.child("test");
    final testRefChild = rtdb.child("ledState");

    // Firestore db
    final cities = db.collection("test cities");
    final data1 = <String, dynamic>{
      "name": "San Francisco",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 860000,
      "regions": ["west_coast", "norcal"]
    };
    cities.doc("SF").set(data1);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Switch(
                value: ledState,
                activeColor: Colors.blue,
                onChanged: (bool value) async {
                  setState(() {
                    ledState = value;
                    testRefChild.set({
                      'on': ledState,
                    });
                    debugPrint(ledState.toString());
                  });
                }
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<City>(
                future: animationData,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Text(snapshot.data!.name);
                  }
                  return const CircularProgressIndicator();
                }
              ),
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
                            height: 50,
                            color: Colors.blue,
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Text(snapshot.data![index]),
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
      )
    );
  }
}