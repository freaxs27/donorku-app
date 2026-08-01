import '../core/api_client.dart';
import '../../model/lokasi_donor.dart';

// Service untuk endpoint Lokasi.
class LokasiService {
  Future<List<LokasiDonor>> ambilDaftarLokasi({String? search}) async {
    final query = (search != null && search.trim().isNotEmpty)
        ? '?search=${Uri.encodeQueryComponent(search.trim())}'
        : '';
    final body = await ApiClient.getList('/lokasi$query');
    return body.map((e) => LokasiDonor.fromJson(e as Map<String, dynamic>)).toList();
  }
}