import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/exceptions/http_exception.dart';
import '../models/requests/auth.dart';
import '../models/responses/auth.dart';
import '../storage/storage_helper.dart';

// const baseUrl = 'http://192.168.15.30:8000/api';
const baseUrl = 'http://192.168.68.114:8000/api';
const imageUrl = 'http://10.0.2.2:8000';

class Auth with ChangeNotifier {
  static const authUrl = '$baseUrl/auth';
  String? _token;
  DateTime? _expiryDate;
  int? _userId;
  String? _email;
  String? _fullName;
  Timer? _authTimer;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> get isAuth async {
    return await token != null;
  }

  Future<String?> get token async {
    var token = await _checkTokenValidity();
    return token;
  }

  int? get userId {
    return _userId;
  }

  String? get email {
    return _email;
  }

  String? get fullName {
    return _fullName;
  }

  Map<String, String> get requestHeader => {
        'Content-Type': 'application/json',
        'Authorization': 'Token $_token',
      };


  Future<String?> _checkTokenValidity() async {
    final url = Uri.parse('$authUrl/validate-token/');
    try {
      final response = await http.get(
        url,
        headers: requestHeader,
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || !responseData.containsKey('valid') || responseData['valid'] == false) {  // invalid token found
        return null;
      }
    } catch (error) {
      return null;
    }
    return _token;
  }

  Future<void> _authenticate(
    Map<String, dynamic> jsonRequest,
    String urlSegment,
  ) async {
    final url = Uri.parse('$authUrl/$urlSegment/');
    try {
      final response = await http.post(
        url,
        body: json.encode(jsonRequest),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(
            responseData.values.join().replaceAll('[', '').replaceAll(']', '')
        );
      }
      final authResponse = AuthDataResponse.fromJson(responseData);
      _token = authResponse.token;
      _expiryDate = authResponse.expiryDate;
      _userId = authResponse.userInfo.id;
      _email = authResponse.userInfo.email;
      _fullName = authResponse.userInfo.fullName;
      _isLoggedIn = true;

      _autoLogout();
      notifyListeners();

      final storageHelper = await _getStorageHelper();
      storageHelper.setValue('userData', json.encode(authResponse.toJson()));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(RegisterRequest request) async {
    final jsonRequest = request.toJson();
    return _authenticate(jsonRequest, 'register');
  }

  Future<void> login(LoginRequest request) async {
    final jsonRequest = request.toJson();
    return _authenticate(jsonRequest, 'login');
  }

  Future<bool> tryAutoLogin() async {
    final storageHelper = await _getStorageHelper();

    if (!storageHelper.containsKey('userData')) {
      return false;
    }
    final extractedUserData = AuthDataResponse.fromJson(json.decode(storageHelper.getValue('userData')!));
    if (extractedUserData.expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData.token;
    _userId = extractedUserData.userInfo.id;
    _email = extractedUserData.userInfo.email;
    _fullName = extractedUserData.userInfo.fullName;
    _expiryDate = extractedUserData.expiryDate;

    if (await token == null) {
      storageHelper.clear();
      return false;
    }

    _isLoggedIn = true;
    notifyListeners();

    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    final url = Uri.parse('$authUrl/logout/');
    final response = await http.post(
      url,
      headers: requestHeader,
    );
    _token = null;
    _userId = null;
    _email = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    _isLoggedIn = false;
    notifyListeners();

    final storageHelper = await _getStorageHelper();
    storageHelper.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<StorageHelper> _getStorageHelper() async {
    final storageHelper = StorageHelper();
    await storageHelper.initPrefs();
    return storageHelper;
  }
}
