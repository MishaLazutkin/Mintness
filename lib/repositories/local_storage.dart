import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mintness/models/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final _singleton = LocalStorage._internal();

  factory LocalStorage() => _singleton;

  LocalStorage._internal();

  SharedPreferences prefs;

  Future<void> init() async {
    prefs ??= await SharedPreferences.getInstance();
    _loadRefreshToken();
    _loadAccessToken();
  }

  String _accessToken;
  String _refreshToken;
  int _secondsSinceEpoch;

  void _loadRefreshToken() {
    _refreshToken = prefs.getString('refreshToken');
  }

  void _loadAccessToken() {
    _accessToken = prefs.getString('accessToken');
  }

  Future<bool> saveAccessToken(String accessToken) async {
    _accessToken = accessToken;
    return prefs.setString('accessToken', accessToken);
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    return prefs.setString('refreshToken', refreshToken);
  }

  Future<bool> storeUserData(String email, User body) async {
    return prefs.setString(email, json.encode(body));
  }

  User getUserData(String email) {
    return User.fromJson(json.decode(prefs.getString(email)??'${json.encode(User())}'));
  }


  Future<bool> saveCurrentSecondsSinceEpoch() async {
    double secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch / 1000;
    return prefs.setDouble('secondsSinceEpoch', secondsSinceEpoch);
  }

  double loadPreviousSecondsSinceEpoch() {
    return prefs.getDouble('secondsSinceEpoch');
  }

  Future<bool> deleteRefreshToken() async {
    _refreshToken = null;
    return prefs.remove('refreshToken');
  }

  Future<bool> deleteAccessToken() async {
    _accessToken = null;
    return prefs.remove('accessToken');
  }

  String get refreshToken => _refreshToken;

  String get accessToken => _accessToken;

  int get previousSecondsSinceEpoch => _secondsSinceEpoch;
}
