import 'package:http/http.dart' as http;
import 'dart:convert';

class Ketersediaan {
  String id, nama, kelas, kapasitas, tersedia;

  Ketersediaan({this.id, this.nama, this.kelas, this.kapasitas, this.tersedia});

  factory Ketersediaan.createKetersediaan(Map<String, dynamic> object) {
    return Ketersediaan(
      id: object['id'],
      nama: object['nama'],
      kelas: object['kelas'],
      kapasitas: object['kapasitas'],
      tersedia: object['tersedia'],
    );
  }

  static Future<List<Ketersediaan>> getKetersediaan(
      // ignore: avoid_init_to_null
      {String page,
      // ignore: avoid_init_to_null
      String nama = null,
      // ignore: avoid_init_to_null
      String kelas = null}) async {
    String baseURL = "m3118039.mhs.d3tiuns.com";
    String path = "v2/api/";
    String apiKey = "mainappkey";
    Map<String, String> params1 = <String, String>{
      'api-key': apiKey,
      'nama': nama,
    };
    Map<String, String> params2 = <String, String>{
      'api-key': apiKey,
      'kelas': kelas,
    };
    Uri apiURL =
        Uri.http(baseURL, path + page, (nama != null) ? params1 : params2);
    print(apiURL);

    var apiResult = await http.get(apiURL);

    var jsonObject = json.decode(apiResult.body);

    List<dynamic> listKetersediaan = jsonObject;
    List<Ketersediaan> ketersediaan = [];
    for (var i = 0; i < listKetersediaan.length; i++) {
      ketersediaan.add(Ketersediaan.createKetersediaan(listKetersediaan[i]));
    }
    return ketersediaan;
  }

  static Future<List<Ketersediaan>> getKetersediaanKelas(
      // ignore: avoid_init_to_null
      {String page,
      // ignore: avoid_init_to_null
      String nama = null,
      // ignore: avoid_init_to_null
      String kelas = null}) async {
    String baseURL = "10.0.2.2";
    String path = "ta/v2/api/";
    String apiKey = "mainappkey";
    Map<String, String> params1 = <String, String>{
      'api-key': apiKey,
      'nama': nama,
    };
    Map<String, String> params2 = <String, String>{
      'api-key': apiKey,
      'kelas': kelas,
    };
    Uri apiURL =
        Uri.http(baseURL, path + page, (nama != null) ? params1 : params2);
    print(apiURL);

    var apiResult = await http.get(apiURL);

    var jsonObject = json.decode(apiResult.body);

    List<dynamic> listKetersediaan = jsonObject;
    List<Ketersediaan> ketersediaan = [];
    for (var i = 0; i < listKetersediaan.length; i++) {
      ketersediaan.add(Ketersediaan.createKetersediaan(listKetersediaan[i]));
    }
    return ketersediaan;
  }
}
