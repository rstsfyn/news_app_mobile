import 'package:flutter/material.dart';
import 'package:news_app_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      if (response.data['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        
        _user = User.fromJson(response.data['user']);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      print('Logout error: $e');
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      try {
        final response = await _apiService.getUser();
        _user = User.fromJson(response.data);
        _isAuthenticated = true;
        notifyListeners();
      } catch (e) {
        await logout();
      }
    }
  }
}
