import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'dart:convert';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sikk_rs/View/Templates/BaseAppBar.dart';
import 'package:sikk_rs/View/Templates/DetailCard.dart';
import 'package:sikk_rs/Model/AllFaskes_Model.dart' as Detail;
import 'package:sikk_rs/Direction.dart' as Direction;
import 'package:sikk_rs/_Dir.dart' as direction_;

class FaskesPage extends StatefulWidget {
  final String nama, alamat, koordinat;
  FaskesPage({this.nama = "", this.alamat = "", this.koordinat = ""});

  @override
  _FaskesPageState createState() =>
      _FaskesPageState(nama: nama, alamat: alamat, koordinat: koordinat);
}

class _FaskesPageState extends State<FaskesPage> {
  final String nama, alamat, koordinat;
  List<Widget> card = [];
  Future _futureData;
  Widget _distance;
  Widget _mapLayer;

  _FaskesPageState({this.nama = "", this.alamat = "", this.koordinat = ""});

  @override
  void initState() {
    super.initState();
    _futureData = asyncData();
    // _distance = Direction.Direction(koordinat: koordinat);
    _mapLayer = direction_.Direction(koordinat: koordinat);
    // _distance = Direction();
  }

  asyncData() async {
    return Future.delayed(
        Duration(seconds: 1),
        () => Detail.Ketersediaan.getKetersediaan(
              page: "Faskes",
              nama: nama,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: BackButton(),
      ),
      body: SlidingUpPanel(
        maxHeight: MediaQuery.of(context).size.height,
        body: Container(
          child: _mapLayer,
        ),
        panel: _panelList(),
      ),
    );
  }

  Widget _map() {
    var _koordinat = koordinat.split(",").toList();
    var _latitude = double.parse(_koordinat[0]);
    var _longitude = double.parse(_koordinat[1]);
    // LatLng(-7.55853, 110.84222)

    return FlutterMap(
      options: MapOptions(
        center: LatLng(_latitude - 0.00075, _longitude),
        zoom: 18,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(_latitude, _longitude),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _panelList() {
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 5,
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                nama,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 5,
            ),
            child: Text(
              alamat,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: _distance,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Ketersediaan Kamar",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
              Divider(
                height: 5,
                indent: 25,
                endIndent: 25,
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          Container(
            height: screenHeight * 0.675,
            child: FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var i = 0; i < snapshot.data.length; i++) {
                    card.add(DetailCard(
                      nama: snapshot.data[i].kelas,
                      tersedia: snapshot.data[i].tersedia,
                      kapasitas: snapshot.data[i].kapasitas,
                      tipe: "kelas",
                    ));
                  }
                  return ListView(
                    children: card,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
