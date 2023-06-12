import 'package:firebase_database/firebase_database.dart';
import 'package:ledcubeapp/model/indicator_rtdb_model.dart';

class HandlePlayAnimation {
  static void handlePlayAnimation(DatabaseReference indicatorChild) {
    indicatorChild.update({
      'on': !Indicator.on
    });
    Indicator.on = !Indicator.on;
  }
}