import 'package:flutter/cupertino.dart';
import 'package:going_live/model/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    uid: "",
    username: "",
    email: "",
  );
  User get user => _user;
  setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
