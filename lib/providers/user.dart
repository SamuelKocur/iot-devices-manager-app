import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_devices_manager_app/models/app_settings.dart';

import '../models/exceptions/http_exception.dart';
import '../models/requests/auth.dart';
import '../models/responses/auth.dart';
import '../storage/storage_helper.dart';


// needed for communication with backend server API
const baseApiUrl = 'http://130.162.218.188/api';
const imageUrl = 'http://130.162.218.188';
// const baseApiUrl = 'http://192.168.15.30:8000/api';
// const imageUrl = 'http://192.168.15.30:8000';

class UserData with ChangeNotifier {
  static const userUrl = '$baseApiUrl/user';
  String? _token;
  DateTime? _expiryDate;
  int? _userId;
  String? _email;
  String? _firstName;
  String? _lastName;
  Timer? _authTimer;
  bool _isLoggedIn = false;
  UserAppSettings _userAppSettings = UserAppSettings();

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

  String? get firstName {
    return _firstName;
  }

  String? get lastName {
    return _lastName;
  }

  UserAppSettings get userAppSettings {
    return _userAppSettings;
  }

  Map<String, String> get requestHeader => {
        'Content-Type': 'application/json',
        'Authorization': 'Token $_token',
      };


  Future<String?> _checkTokenValidity() async {
    final url = Uri.parse('$userUrl/validate-token/');
    try {
      _isLoggedIn = false;
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
    _isLoggedIn = true;
    return _token;
  }

  Future<void> _authenticate(
    Map<String, dynamic> jsonRequest,
    String urlSegment,
  ) async {
    final url = Uri.parse('$userUrl/$urlSegment/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonRequest),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData.values.join().replaceAll('[', '').replaceAll(']', ''));
      }
      final authResponse = AuthDataResponse.fromJson(responseData);
      _token = authResponse.token;
      _expiryDate = authResponse.expiryDate;
      _userId = authResponse.userInfo.id;
      _email = authResponse.userInfo.email;
      _firstName = authResponse.userInfo.firstName;
      _lastName = authResponse.userInfo.lastName;
      _isLoggedIn = true;

      notifyListeners();
      _autoLogout();

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
    _firstName = extractedUserData.userInfo.firstName;
    _lastName = extractedUserData.userInfo.lastName;
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

  Future<bool> logoutLogic(String urlSegment) async {
    final url = Uri.parse('$userUrl/$urlSegment/');
    final response = await http.post(
      url,
      headers: requestHeader,
    );

    if (response.statusCode != 204) {
      return false;
    }

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
    return true;
  }

  Future<void> logout() async {
    logoutLogic('logout');
  }

  Future<bool> logoutAll() async {
    return logoutLogic('logout-all');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> deleteAccount() async {
    final url = Uri.parse('$userUrl/delete-account/');
    try {
      final response = await http.delete(
        url,
        headers: requestHeader,
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData.values.join().replaceAll('[', '').replaceAll(']', ''));
      }
      logoutAll();
    } catch (error) {
      rethrow;
    }
    return true;
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    final url = Uri.parse('$userUrl/change-password/');
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode(request.toJson()),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData.values.join().replaceAll('[', '').replaceAll(']', ''));
      }
    } catch (error) {
      rethrow;
    }
    return true;
  }

  Future<bool> updateProfile(UpdateProfileRequest request) async {
    final url = Uri.parse('$userUrl/profile/');
    try {
      final response = await http.put(
        url,
        headers: requestHeader,
        body: json.encode(request.toJson()),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData.values.join().replaceAll('[', '').replaceAll(']', ''));
      }
      final storageHelper = await _getStorageHelper();

      if (!storageHelper.containsKey('userData')) {
        return false;
      }

      _firstName = request.firstName ?? _firstName;
      _lastName = request.lastName ?? _lastName;

      final extractedUserData = AuthDataResponse.fromJson(json.decode(storageHelper.getValue('userData')!));
      extractedUserData.userInfo.firstName = _firstName ?? extractedUserData.userInfo.firstName;
      extractedUserData.userInfo.lastName = _lastName ?? extractedUserData.userInfo.lastName;
      storageHelper.setValue('userData', json.encode(extractedUserData.toJson()));
    } catch (error) {
      rethrow;
    }
    return true;
  }

  Future<void> fetchAppSettings() async {
    final url = Uri.parse('$userUrl/app-settings/');
    try {
      final response = await http.get(url, headers: requestHeader);
      final responseData = (jsonDecode(response.body) ?? <String, dynamic>{})  as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final UserAppSettings loadedAppSettings = UserAppSettings.fromJson(responseData);
        _userAppSettings = loadedAppSettings;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAppSettings(UserAppSettings request) async {
    final url = Uri.parse('$userUrl/app-settings/');
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode(request.toJson()),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData.values.join().replaceAll('[', '').replaceAll(']', '')
        );
      }
      _userAppSettings.update(request);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    return true;
  }

  Future<StorageHelper> _getStorageHelper() async {
    final storageHelper = StorageHelper();
    await storageHelper.initPrefs();
    return storageHelper;
  }
}
