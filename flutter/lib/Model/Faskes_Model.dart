import 'package:http/http.dart' as http;
import 'dart:convert';

class Ketersediaan {
  String id, nama, alamat, koordinat, website, kapasitas, tersedia;

  Ketersediaan(
      {this.id,
      this.nama,
      this.alamat,
      this.koordinat,
      this.website,
      this.kapasitas,
      this.tersedia});

  factory Ketersediaan.createKetersediaan(Map<String, dynamic> object) {
    return Ketersediaan(
      id: object['id'],
      nama: object['nama'],
      alamat: object['alamat'],
      koordinat: object['koordinat'],
      website: object['website'],
      kapasitas: object['kapasitas'],
      tersedia: object['tersedia'],
    );
  }

  static Future<List<Ketersediaan>> getKetersediaan(String page) async {
    String baseURL = "m3118039.mhs.d3tiuns.com";
    String path = "v2/api/";
    String apiKey = "mainappkey";

    Map<String, String> params = <String, String>{
      'api-key': apiKey,
    };

    Uri apiURL = Uri.http(baseURL, path + page, params);
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
