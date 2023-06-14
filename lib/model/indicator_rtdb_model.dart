import 'package:firebase_database/firebase_database.dart';

class Indicator {
  static bool on = false;

  static void indicatorOnValueListen(DatabaseReference indicatorChild){
    indicatorChild.onValue.listen((event) { 
      final data = event.snapshot.value as Map;
      Indicator.on = data['on'];
    });
  }
}