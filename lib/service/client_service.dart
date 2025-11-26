import '../api/apiService.dart';

class ClientService extends ApiService {
  ClientService(String baseUrl) : super(baseUrl);

  Future<dynamic> getClients() async {
    final response = await get('/clients');
    return response.data;
  }

  Future<dynamic> getClient(int id) async {
    final response = await get('/clients/$id');
    return response.data;
  }

  Future<dynamic> createClient(dynamic data) async {
    final response = await post('/clients', data: data);
    return response.data;
  }

  Future<dynamic> updateClient(int id, dynamic data) async {
    final response = await put('/clients/$id', data: data);
    return response.data;
  }

  Future<dynamic> deleteClient(int id) async {
    final response = await delete('/clients/$id');
    return response.data;
  }
}