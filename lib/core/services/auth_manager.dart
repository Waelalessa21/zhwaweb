import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../network/api_result.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null && _user != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      _user = Map<String, dynamic>.from(
        Uri.splitQueryString(
          userString,
        ).map((key, value) => MapEntry(key, value)),
      );
    }

    if (_token != null) {
      ApiService().setToken(_token!);
    }
  }

  Future<ApiResult<Map<String, dynamic>>> login(
    String username,
    String password,
  ) async {
    final result = await ApiService().login(username, password);

    return result.when(
      success: (data) async {
        _token = data['access_token'];
        _user = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        await prefs.setString(_userKey, _user!.toString());

        ApiService().setToken(_token!);
        return ApiResult.success(data);
      },
      failure: (message) async {
        return ApiResult.failure(message);
      },
    );
  }

  Future<void> logout() async {
    if (_token != null) {
      await ApiService().logout();
    }

    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);

    ApiService().clearToken();
  }

  bool isAdmin() {
    return _user?['type'] == 'admin';
  }

  bool isStoreOwner() {
    return _user?['type'] == 'store';
  }

  String? getUserId() {
    return _user?['id'];
  }
}
