import '../api/apiService.dart';

class AuthService extends ApiService {
  AuthService(String baseUrl) : super(baseUrl);

  Future<dynamic> login(String phoneNumber, String password) async {
    final response = await post('/login', data: {'phone_number': phoneNumber, 'password': password});
    return response.data;
  }

  Future<dynamic> register(String username, String password, String nom, String prenom, String telephone) async {
    final response = await post('/register', data: {
      'username': username,
      'password': password,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone
    });
    return response.data;
  }

  Future<dynamic> confirmSms(String telephone, String code) async {
    final response = await post('/confirm-sms', data: {'telephone': telephone, 'code': code});
    return response.data;
  }

  Future<dynamic> logout() async {
    final response = await post('/logout');
    return response.data;
  }

  void setAuthToken(String token) {
    setToken(token);
  }
}