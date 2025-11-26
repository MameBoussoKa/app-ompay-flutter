import 'auth_service.dart';
import 'compte_service.dart';

class AuthManager {
  static const String baseUrl = 'http://localhost:8000/api';

  late AuthService _authService;
  late CompteService _compteService;
  String? _token;

  AuthManager() {
    _authService = AuthService(baseUrl);
    _compteService = CompteService(baseUrl);
  }

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    try {
      final response = await _authService.login(phoneNumber, password);
      if (response['success'] == true) {
        _token = response['data']['token'];
        _authService.setAuthToken(_token!);
        _compteService.setAuthToken(_token!);
      }
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: $e'
      };
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, String nom, String prenom, String telephone) async {
    try {
      final response = await _authService.register(username, password, nom, prenom, telephone);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur d\'inscription: $e'
      };
    }
  }

  Future<Map<String, dynamic>> confirmSms(String telephone, String code) async {
    try {
      final response = await _authService.confirmSms(telephone, code);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de confirmation: $e'
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _authService.logout();
      _token = null;
      return response;
    } catch (e) {
      _token = null;
      return {
        'success': false,
        'message': 'Erreur de déconnexion: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _compteService.me();
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de récupération des données: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getSolde(String compteId) async {
    try {
      final response = await _compteService.getSolde(compteId);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de récupération du solde: $e'
      };
    }
  }

  Future<Map<String, dynamic>> pay(String compteId, Map<String, dynamic> data) async {
    try {
      final response = await _compteService.pay(compteId, data);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de paiement: $e'
      };
    }
  }

  Future<Map<String, dynamic>> transfer(String compteId, Map<String, dynamic> data) async {
    try {
      final response = await _compteService.transfer(compteId, data);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de transfert: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getTransactions(String compteId, {int? page, int? perPage}) async {
    try {
      final response = await _compteService.getTransactions(compteId, page: page, perPage: perPage);
      return response;
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de récupération des transactions: $e'
      };
    }
  }
}