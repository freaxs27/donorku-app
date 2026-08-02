import '../core/api_client.dart';
import '../../model/data_sertifikat.dart';

class SertifikatService {
  Future<List<DataSertifikat>> ambilDaftarSertifikat() async {
    final list = await ApiClient.getList('/sertifikat');
    return list
        .map((e) => DataSertifikat.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}