import 'package:firebase_database/firebase_database.dart';
import 'package:ledcubeapp/model/selected_rtdb_model.dart';

class HandleChooseAnimation {
    static void handleChooseAnimation(DatabaseReference ledStateChild, String animationName) {
        ledStateChild.set({
          'selected': animationName
        });
        Selected.animation = animationName;
    }
}