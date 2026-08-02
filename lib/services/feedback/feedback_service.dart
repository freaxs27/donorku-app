import '../core/api_client.dart';

class FeedbackService {
  Future<void> kirimFeedback({
    required int rating,
    String? saranKeluhan,
    int? idPendaftaran,
  }) async {
    await ApiClient.postJson('/feedback', {
      'rating': rating,
      if (saranKeluhan != null && saranKeluhan.isNotEmpty)
        'saran_keluhan': saranKeluhan,
      if (idPendaftaran != null) 'id_pendaftaran': idPendaftaran,
    });
  }
}