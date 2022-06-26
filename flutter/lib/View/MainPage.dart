import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:sikk_rs/Model/Faskes_Model.dart' as Faskes;
import 'package:sikk_rs/Model/Kelas_Model.dart' as Kelas;
import 'package:sikk_rs/View/Templates/MainCard.dart';

Color primaryColor = HexColor("#45B6FE");
Color secondaryColor = HexColor("#ADD8E6");

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> cardFaskes = [];
  List<Widget> cardKelas = [];
  Future _futureFaskes, _futureKelas;

  @override
  void initState() {
    super.initState();
    _futureFaskes = asyncFaskes();
    _futureKelas = asyncKelas();
  }

  asyncFaskes() async {
    return Future.delayed(Duration(seconds: 1),
        () => Faskes.Ketersediaan.getKetersediaan("faskes"));
  }

  asyncKelas() async {
    return Future.delayed(Duration(seconds: 1),
        () => Kelas.Ketersediaan.getKetersediaan("kelas"));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(""),
        Container(
          child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: tabBar,
                  ),
                  Container(
                    height: screenHeight * 0.775,
                    child: TabBarView(children: [
                      FutureBuilder(
                        future: _futureFaskes,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            for (var i = 0; i < snapshot.data.length; i++) {
                              cardFaskes.add(MainCard(
                                tersedia: snapshot.data[i].tersedia,
                                kapasitas: snapshot.data[i].kapasitas,
                                nama: snapshot.data[i].nama,
                                alamat: snapshot.data[i].alamat,
                                koordinat: snapshot.data[i].koordinat,
                                tipe: "faskes",
                              ));
                            }
                            return ListView(
                              shrinkWrap: true,
                              children: cardFaskes,
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      FutureBuilder(
                        future: _futureKelas,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            for (var i = 0; i < snapshot.data.length; i++) {
                              cardKelas.add(MainCard(
                                nama: snapshot.data[i].kelas,
                                kapasitas: snapshot.data[i].kapasitas,
                                tersedia: snapshot.data[i].tersedia,
                                tipe: "kelas",
                              ));
                            }
                            return ListView(
                              children: cardKelas,
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ]),
                  ),
                ],
              )),
        )
      ],
    );
  }

  TabBar tabBar = TabBar(
    isScrollable: true,
    unselectedLabelColor: primaryColor,
    labelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BubbleTabIndicator(
      indicatorHeight: 25.0,
      indicatorColor: primaryColor,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      // Other flags
      // indicatorRadius: 1,
      // insets: EdgeInsets.all(1),
      // padding: EdgeInsets.all(10)
    ),
    tabs: [
      Tab(
        text: "Berdasarkan Faskes",
      ),
      Tab(
        text: "Berdasarkan Kelas",
      ),
    ],
  );
}
