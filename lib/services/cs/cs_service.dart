import '../core/api_client.dart';

class CsService {
  Future<void> kirimPesan({
    required String topik,
    required String pesan,
  }) async {
    await ApiClient.postJson('/cs', {
      'topik': topik,
      'pesan': pesan,
    });
  }
}