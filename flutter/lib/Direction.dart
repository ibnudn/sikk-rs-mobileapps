import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:sikk_rs/Model/Direction_Helper.dart';
import 'dart:async';

class Direction extends StatefulWidget {
  final String koordinat;
  Direction({this.koordinat});

  @override
  _DirectionState createState() => _DirectionState(koordinat: koordinat);
}

class _DirectionState extends State<Direction> {
  final String koordinat;
  _DirectionState({this.koordinat = ""});

  // CenterOnLocationUpdate _centerOnLocationUpdate;
  // StreamController<double> _centerCurrentLocationStreamController;
  Location _location = new Location();
  Future _futureData;

  @override
  void initState() {
    super.initState();
    // _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    // _centerCurrentLocationStreamController = StreamController<double>();
    _futureData = _getLoc().then((value) => setState(() {
          _latU = value.latitude;
          _longU = value.longitude;
          getJsonData();
        }));
    setPolyLines();
  }

  @override
  Widget build(BuildContext context) {
    var _distance_widget = FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) => Container(
              margin: EdgeInsets.only(
                left: 5,
                right: 5,
                top: 5,
              ),
              child: Text(
                (_dist != null) ? _dist.toStringAsFixed(2) + _distUnit : "",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ));

    var map_polylines = PolylineLayerOptions(
      polylines: [
        Polyline(
          points: _polyPoints,
          strokeWidth: 4.0,
          gradientColors: [
            Color(0xffE40203),
            Color(0xffFEED00),
            Color(0xff007E2D),
          ],
        ),
      ],
      // PolylineLayerOptions(
      //   polylines: snapshot.data!,
      //   polylineCulling: true,
      // ),
    );
    Map<String, dynamic> _widgets = {
      'user_coordinate': map_polylines,
      'distance': _distance_widget
    };
    print(_polyLines.toList());
    return _distance_widget;
  }

  var _latU, _longU;
  var _polyPoints = <LatLng>[];
  var _polyLines = <Polyline>[];
  var _dist;
  var data;
  String _distUnit = "";

  Future _getLoc() async {
    // var getLoc = await _location.getLocation();
    // return getLoc;
    return Future.delayed(Duration(seconds: 1), () => _location.getLocation());
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format
    var _koordinat = koordinat.split(",").toList();
    var _latP = double.parse(_koordinat[0]);
    var _longP = double.parse(_koordinat[1]);

    DirectionHelper _direction = DirectionHelper(
      startLat: _latU,
      startLng: _longU,
      endLat: _latP,
      endLng: _longP,
    );

    try {
      // getData() returns a json Decoded data
      data = await _direction.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);
      // print(ls);

      for (int i = 0; i < ls.lineString.length; i++) {
        _polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }
      if (_polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }

      _dist = data['features'][0]['properties']['summary']['distance'];
      if (_dist > 1000) {
        _dist /= 1000;
        _distUnit = " KM";
      } else {
        _distUnit = " M";
      }
      print(_dist.toString());
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      color: Colors.lightBlue,
      strokeWidth: 7.5,
      points: _polyPoints,
    );
    _polyLines.add(polyline);
    // print(_polyPoints.toString());
    // setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
