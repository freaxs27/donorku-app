import '../core/api_client.dart';
import '../../model/riwayat_donor.dart';
import '../../model/item_pendaftaran.dart';

class RiwayatService {
  /// [filter]: 'all' | '1bulan' | '6bulan' | '1tahun'
  /// (sesuai format yang diterima backend teman)
  Future<RiwayatResponse> ambilRiwayat(String filter) async {
    final query = filter == 'all' ? '' : '?filter=$filter';
    final body = await ApiClient.get('/riwayat$query');
    return RiwayatResponse.fromJson(body);
  }

  Future<List<ItemPendaftaran>> ambilDaftarPendaftaran() async {
    final list = await ApiClient.getList('/pendaftaran');
    return list
        .map((e) => ItemPendaftaran.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> batalkanPendaftaran(int idPendaftaran) async {
    await ApiClient.patch('/pendaftaran/$idPendaftaran/batalkan', {});
  }
}