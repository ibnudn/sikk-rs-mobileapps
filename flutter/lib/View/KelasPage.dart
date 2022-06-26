import 'package:flutter/material.dart';
import 'package:sikk_rs/Model/AllFaskes_Model.dart' as Detail;
import 'package:sikk_rs/View/Templates/BaseAppBar.dart';
import 'package:sikk_rs/View/Templates/DetailCard.dart';

class KelasPage extends StatefulWidget {
  final String nama;
  KelasPage({this.nama = ""});

  @override
  _KelasPageState createState() => _KelasPageState(
        nama: nama,
      );
}

class _KelasPageState extends State<KelasPage> {
  final String nama;
  List<Widget> card = [];
  Future _futureData;

  _KelasPageState({this.nama = ""});

  @override
  void initState() {
    super.initState();
    _futureData = asyncData();
  }

  asyncData() async {
    return Future.delayed(
        Duration(seconds: 1),
        () => Detail.Ketersediaan.getKetersediaan(
              page: "Kelas",
              kelas: nama,
            ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: BaseAppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                "Ketersediaan Kamar",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5,
              ),
              child: Text(
                nama,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Divider(
              height: 5,
              indent: 20,
              endIndent: 20,
              thickness: 1,
              color: Theme.of(context).primaryColor,
            ),
            Container(
              height: screenHeight * 0.7,
              child: FutureBuilder(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    for (var i = 0; i < snapshot.data.length; i++) {
                      card.add(DetailCard(
                        nama: snapshot.data[i].nama,
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
      ),
    );
  }
}
