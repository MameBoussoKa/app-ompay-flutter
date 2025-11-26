import '../api/apiService.dart';

class TransactionService extends ApiService {
  TransactionService(String baseUrl) : super(baseUrl);

  Future<dynamic> getTransactions() async {
    final response = await get('/transactions');
    return response.data;
  }

  Future<dynamic> getTransaction(int id) async {
    final response = await get('/transactions/$id');
    return response.data;
  }

  Future<dynamic> createTransaction(dynamic data) async {
    final response = await post('/transactions', data: data);
    return response.data;
  }

  Future<dynamic> updateTransaction(int id, dynamic data) async {
    final response = await put('/transactions/$id', data: data);
    return response.data;
  }

  Future<dynamic> deleteTransaction(int id) async {
    final response = await delete('/transactions/$id');
    return response.data;
  }
}