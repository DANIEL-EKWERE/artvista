import 'dart:io';
import 'package:artvista/models/model1.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Postdb extends ChangeNotifier {
  Post? post;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();


  Future<bool> saveFavouritePost(Post post) async{
    SharedPreferences value = await _pref;
    if(await value.setString('favourite',post.toString())){
      return true;
    }
    return false;
  }



//   Future<List<Post>> getPosts() async {
// SharedPreferences value = await _pref;
// if (value.containsKey('favourite')) {
//       String data = value.getString('favourite')!;
//        Map<String, dynamic> x = Post.fromJson(data.);
//       notifyListeners();
//       return 
//     } else {
//       _phone = '';
//       notifyListeners();
//       return '';
//     }
//   }

}