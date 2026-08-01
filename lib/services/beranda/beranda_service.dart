import '../core/api_client.dart';
import '../../model/beranda_data.dart';

/// Service untuk endpoint Beranda. Sesuai kontrak:
/// src/app/api/mobile/beranda/route.ts (GET, butuh login).
class BerandaService {
  Future<BerandaData> ambilDataBeranda() async {
    final body = await ApiClient.get('/beranda');
    return BerandaData.fromJson(body);
  }
}