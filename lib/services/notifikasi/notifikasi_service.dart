import '../core/api_client.dart';
import '../../model/data_notifikasi.dart';

class NotifikasiService {
  Future<List<DataNotifikasi>> ambilNotifikasi() async {
    final list = await ApiClient.getList('/notifikasi');
    return list
        .map((e) => DataNotifikasi.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> tandaiBaca(int idNotifikasi) async {
    await ApiClient.patch('/notifikasi/$idNotifikasi', {});
  }
}