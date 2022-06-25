import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:latihan/Model/Direction_Helper.dart';
import 'package:latihan/View/Templates/ZoomButtonsPluginOption.dart';
import 'dart:async';
import 'dart:math' as Math;

class Direction extends StatefulWidget {
  final String koordinat;
  Direction({this.koordinat});

  @override
  _DirectionState createState() => _DirectionState(koordinat: koordinat);
}

class _DirectionState extends State<Direction> {
  final String koordinat;
  _DirectionState({this.koordinat = ""});

  CenterOnLocationUpdate _centerOnLocationUpdate;
  StreamController<double> _centerCurrentLocationStreamController;
  MapController _mapctl = MapController();
  Location _location = new Location();
  List<Marker> _marker = <Marker>[];
  Future _futureData;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double>();

    _koordinat = koordinat.split(',').toList();
    _latP = double.parse(_koordinat[0]);
    _longP = double.parse(_koordinat[1]);
    _futureData = _getLoc().then((value) => setState(() {
          _latU = value.latitude;
          _longU = value.longitude;
          getJsonData();
        }));
  }

  @override
  Widget build(BuildContext context) {
    // var _distance_widget = FutureBuilder(
    //     future: _futureData,
    //     builder: (context, snapshot) => Container(
    //           margin: EdgeInsets.only(
    //             left: 5,
    //             right: 5,
    //             top: 5,
    //           ),
    //           child: Text(
    //             (_dist != null) ? _dist.toStringAsFixed(2) + _distUnit : "",
    //             style: TextStyle(
    //               fontSize: 10,
    //               fontWeight: FontWeight.bold,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ));
    // return _map();

    var mapWidget = FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          _marker.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_latP, _longP),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ),
          );
          if (_latU != null && _latU != 0) {
            var midPoint =
                getCenterLatLong(LatLng(_latP, _longP), LatLng(_latU, _longU));
            var midBounds =
                LatLngBounds(LatLng(_latP, _longP), LatLng(_latU, _longU));
            var midZoom = (zoomLevel != null) ? getZoomLevel(zoomLevel) : 15;
            print("_map_widget() =>");
            print(_polyLines);
            print(zoomLevel);
            print(_latP);
            print(_latU);
            print(midZoom);
            print(midBounds);
            // _mapctl.move(midPoint, zoomLevel);
            // _mapctl.fitBounds(midBounds);
            _marker.add(Marker(
              point: LatLng(_latU, _longU),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_history,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ));
          }
          return FlutterMap(
            mapController: _mapctl,
            options: MapOptions(
              center: LatLng(_latP - 0.00075, _longP),
              zoom: zoomLevel,
              plugins: [
                ZoomButtonsPlugin(),
              ],
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayerOptions(
                polylines: _polyLines,
              ),
              MarkerLayerOptions(
                markers: _marker,
              ),
            ],
            nonRotatedLayers: [
              ZoomButtonsPluginOption(
                minZoom: 4,
                maxZoom: 19,
                mini: true,
                padding: 10,
                alignment: Alignment.topRight,
              ),
            ],
          );
        });

    return mapWidget;
  }

  var _koordinat;
  double _latU = 0;
  double _longU = 0;
  var _latP, _longP;
  var _polyPoints = <LatLng>[];
  var _polyLines = <Polyline>[];
  var _dist;
  var data;
  double zoomLevel = 18;
  String _distUnit = "";

  Future _getLoc() async {
    // var getLoc = await _location.getLocation();
    // return getLoc;
    return Future.delayed(Duration(seconds: 1), () => _location.getLocation());
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format
    _koordinat = koordinat.split(",").toList();
    _latP = double.parse(_koordinat[0]);
    _longP = double.parse(_koordinat[1]);

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

      var _pointA = LatLng(ls.lineString[0][1], ls.lineString[0][0]);
      var _pointB = LatLng(ls.lineString[ls.lineString.length - 1][1],
          ls.lineString[ls.lineString.length - 1][0]);

      _dist = data['features'][0]['properties']['summary']['distance'];
      zoomLevel = getZoomLevel(_dist);
      _mapctl.move(getCenterLatLong(_pointA, _pointB), zoomLevel);
      if (_dist > 1000) {
        _dist /= 1000;
        _distUnit = " KM";
      } else {
        _distUnit = " M";
      }
      print("getJsonData() =>");
      print(_pointA.toString());
      print(_pointB.toString());
      print(_dist.toString());
      print(zoomLevel);
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

  getZoomLevel(double distance) {
    double radius = distance / 2;
    // double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - Math.log(scale) / Math.log(2);
    }
    zoomLevel = zoomLevel + (zoomLevel * 0.05);
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(1));
    print("getZoomLevel()");
    print(zoomLevel);
    return zoomLevel;
  }

  LatLng getCenterLatLong(LatLng latLng1, LatLng latLng2) {
    double midLat, midLong;

    // Calculating midLat
    int coefficient = 1;

    if ((latLng1.latitude > 90 && latLng2.latitude < -90) ||
        (latLng2.latitude > 90 && latLng1.latitude < -90)) {
      midLat = 180 - ((latLng1.latitude - latLng2.latitude) / 2).abs();
      // If output will be in the 1st quartile then co-ef will remain 1, if in 4th then it will be -1
      if ((latLng1.latitude < 0 &&
              latLng1.latitude.abs() < latLng2.latitude.abs()) ||
          (latLng2.latitude < 0 &&
              latLng2.latitude.abs() < latLng1.latitude.abs()))
        coefficient = -1;
      // Applying coefficient
      midLat *= coefficient;
    } else
      midLat = (latLng2.latitude + latLng1.latitude) / 2;

    // Calculating midLong
    coefficient = 1;

    if ((latLng1.longitude > 90 && latLng2.longitude < -90) ||
        (latLng2.longitude > 90 && latLng1.longitude < -90)) {
      midLong =
          180 - ((latLng1.longitude.abs() - latLng2.longitude.abs()) / 2).abs();
      // If output will be in the 1st quartile then co-ef will remain 1, if in 4th then it will be -1
      if ((latLng1.longitude < 0 &&
              latLng1.longitude.abs() < latLng2.longitude.abs()) ||
          (latLng2.longitude < 0 &&
              latLng2.longitude.abs() < latLng1.longitude.abs()))
        coefficient = -1;

      // Applying coefficient
      midLong *= coefficient;
    } else
      midLong = (latLng2.longitude + latLng1.longitude) / 2;

    // print(LatLng(midLat, midLong));
    return LatLng(midLat - 0.001, midLong);
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
