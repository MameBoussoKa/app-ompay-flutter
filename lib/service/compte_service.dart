import '../api/apiService.dart';

class CompteService extends ApiService {
  CompteService(String baseUrl) : super(baseUrl);

  Future<dynamic> me() async {
    final response = await get('/me');
    return response.data;
  }

  Future<dynamic> getSolde(String id) async {
    final response = await get('/compte/$id/solde');
    return response.data;
  }

  Future<dynamic> pay(String id, Map<String, dynamic> data) async {
    final response = await post('/compte/$id/pay', data: data);
    return response.data;
  }

  Future<dynamic> transfer(String id, Map<String, dynamic> data) async {
    final response = await post('/compte/$id/transfer', data: data);
    return response.data;
  }

  Future<dynamic> getTransactions(String id, {int? page, int? perPage}) async {
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page.toString();
    if (perPage != null) queryParameters['per_page'] = perPage.toString();
    final response = await get('/compte/$id/transactions', queryParameters: queryParameters);
    return response.data;
  }

  void setAuthToken(String token) {
    setToken(token);
  }
}