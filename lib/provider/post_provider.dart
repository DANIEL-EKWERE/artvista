import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:artvista/constants/app_url.dart';
import 'package:artvista/models/model1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  String _regMessage = '';
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String requestBaseUrl = AppUrl.requestUrl;
  String get reqMessage => _regMessage;
  bool get isLoading => _isLoading;

  List<Post> data = <Post>[];
  List<Post> data1 = <Post>[];
  List<Post> data4 = <Post>[];
  Post allPost1 = Post(
      id: 0,
      title: '',
      image: '',
      body: '',
      publish: '',
      created: '',
      updated: '',
      status: '',
      author: Author(id: 0, image: '', bio: '', user: 0),
      video: '',
      slug: '',
      category: Category1(id: 0, title: '', image: '', updated: ''));

  Post data3 = Post(
      id: 0,
      title: '',
      image: '',
      body: '',
      publish: '',
      created: '',
      updated: '',
      status: '',
      author: Author(id: 0, image: '', bio: '', user: 0),
      video: '',
      slug: '',
      category: Category1(id: 0, title: '', image: '', updated: ''));

  Post data5 = Post(
      id: 0,
      title: '',
      image: '',
      body: '',
      publish: '',
      created: '',
      updated: '',
      status: '',
      author: Author(id: 0, image: '', bio: '', user: 0),
      video: '',
      slug: '',
      category: Category1(id: 0, title: '', image: '', updated: ''));
  // ignore: prefer_typing_uninitialized_variables
  var res;

  Future<List<Post>> allPost() async {
    _isLoading = true;
    notifyListeners();
    String url = '$requestBaseUrl/all-post/';
    try {
      http.Response req = await http.get(Uri.parse(url));
      if (req.statusCode == 200 || req.statusCode == 201) {
        res = json.decode(req.body);
        data = allPostFromJson2(req.body);
        _regMessage = 'post updated';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _regMessage = 'network unavailable';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _regMessage = 'something went wrong';
      print('something went wrong in catch $e');
      notifyListeners();
    }
    return data;
  }

  Future<List<Post>> postBasedCategory({required cat}) async {
    _isLoading = true;
    notifyListeners();
    String url = '$requestBaseUrl/post-based-category/$cat/';
    try {
      http.Response req = await http.get(Uri.parse(url));
      if (req.statusCode == 200 || req.statusCode == 201) {
        // print(req.body);
        res = json.decode(req.body);
        data1 = allPostFromJson2(req.body);
        _regMessage = 'post updated';
        notifyListeners();
        //  final data = res.map<Post>(res.fromJson).toList();
        //  print('print the post $res');
      }
    } on SocketException catch (_) {
      _regMessage = 'network unavailable';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _regMessage = 'something went wrong';
      // print('something went wrong ${e.toString()}');
      notifyListeners();
    }
    return data1;
  }

  Future<Post> singlePost({required int id}) async {
    _isLoading = true;
    notifyListeners();
    //  print('calling from method');
    print('this is single post beem called from the method itself');
    String url = '$requestBaseUrl/single-post/$id/';
    //  print(url);
    try {
      print('this is single post beem called from try block');
      http.Response req = await http.get(Uri.parse(url));
      if (req.statusCode == 200 || req.statusCode == 201) {
        res = json.decode(req.body);
        print('single post raw data ==> $res');
        data3 = allPosts(req.body);
        //  List<Post> data = res;
        print('single post from mehtod ==> $data3');
        _regMessage = 'post updated';
        notifyListeners();
        //  final data = res.map<Post>(res.fromJson).toList();
        print('print the post $res');
        return data3;
      }
    } on SocketException catch (_) {
      _regMessage = 'network unavailable';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _regMessage = 'something went wrong';
      print('something went wrong $e');
      notifyListeners();
    }
    return data3;
  }

  Future<List<Post>> searchedPost({required String query}) async {
    _isLoading = true;
    notifyListeners();
    //  print('calling from method');
    String q = query.replaceAll(RegExp(r'\s+'),'?');
    print('this is searched post beem called from the method itself');
    String url = '$requestBaseUrl/searched-post/$q/';
    print(url);
    try {
      print('this is searched post beem called from try block');
      http.Response req = await http.get(Uri.parse(url));
      print(req.statusCode);
      if (req.statusCode == 200 || req.statusCode == 201) {
        res = json.decode(req.body);
        print('single post raw data ==> $res');
        data4 = allPostFromJson2(req.body);
        //  List<Post> data = res;
        print('single post from mehtod ==> $data3');
        _regMessage = 'post updated';
        notifyListeners();
        //  final data = res.map<Post>(res.fromJson).toList();
        print('print the post $res');
        return data4;
      }
    } on SocketException catch (_) {
      _regMessage = 'network unavailable';
      _isLoading = false;
      print('network issues');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _regMessage = 'something went wrong';
      print('something went wrong $e');
      notifyListeners();
    }
    return data4;
  }
}
