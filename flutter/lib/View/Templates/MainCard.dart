import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sikk_rs/View/FaskesPage.dart';
import 'package:sikk_rs/View/KelasPage.dart';

class MainCard extends StatelessWidget {
  final String tersedia, kapasitas, nama, alamat, koordinat, tipe;

  MainCard(
      {this.tersedia = "",
      this.kapasitas = "",
      this.nama = "",
      this.alamat = "",
      this.koordinat = "",
      this.tipe = ""});

  @override
  Widget build(BuildContext context) {
    var persen = int.parse(tersedia) / int.parse(kapasitas) * 100;

    return SizedBox(
      height: 225,
      width: 500,
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        color: Theme.of(context).colorScheme.secondary,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (tipe == "faskes") {
                return FaskesPage(
                  nama: nama,
                  alamat: alamat,
                  koordinat: koordinat,
                );
              } else {
                return KelasPage(
                  nama: nama,
                );
              }
            }));
          },
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    tersedia,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Kamar Tersedia",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      nama,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: tipe == "faskes"
                            ? FontWeight.w200
                            : FontWeight.w100,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  child: Center(
                    child: Text(
                      persen.toStringAsFixed(0) +
                          " % tersedia dari " +
                          kapasitas +
                          " kamar",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: LinearPercentIndicator(
                    width: 300,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: persen / 100,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
