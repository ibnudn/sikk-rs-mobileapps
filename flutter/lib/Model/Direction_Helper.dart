import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionHelper {
  DirectionHelper({this.startLng, this.startLat, this.endLng, this.endLat});

  final String baseURL = 'api.openrouteservice.org';
  final String path = 'v2/directions/';
  final String apiKey =
      '5b3ce3597851110001cf624808c8644f95a449b780962517382ed745';
  final String pathParam = 'driving-car'; // Change it if you want
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    String start = startLng.toString() + "," + startLat.toString();
    String end = endLng.toString() + "," + endLat.toString();
    Map<String, dynamic> params = <String, dynamic>{
      'api_key': apiKey,
      'start': start,
      'end': end
    };
    Uri apiURL = Uri.https(baseURL, path + pathParam, params);
    print(apiURL);
    // http.Response response = await http.get(
    //     '$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');
    http.Response response = await http.get(apiURL);

    if (response.statusCode == 200) {
      String data = response.body;
      return json.decode(data);
    } else {
      print(response.statusCode);
    }
  }
}
