
import 'package:couplink_app/api/ApiService.dart';
import 'package:dio/dio.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  late final ApiService _apiService;

  UserService._internal();

  init({
    required ApiService apiService,
  }) {
    _apiService = apiService;
  }

  Future<Response> readUser() async {
    return await _apiService.dio.get('/api/v1/user/profile');
  }
}