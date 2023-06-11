import 'package:firebase_database/firebase_database.dart';

class Selected {
  static String animation = '';

  static void selectedOnValueListen(DatabaseReference ledStateChild){
    ledStateChild.onValue.listen((event) { 
      final data = event.snapshot.value as Map;
      Selected.animation = data['selected'];
    });
  }
}