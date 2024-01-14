import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  Future<void> storeUserId(int? id) async {
    if (id==null) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', id);
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<bool> isLoggedin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('UserId')!=null ;
  }
}
