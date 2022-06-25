import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String tersedia, kapasitas, nama, tipe;

  DetailCard(
      {this.tersedia = "",
      this.kapasitas = "",
      this.nama = "",
      this.tipe = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
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
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        nama,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              tipe == "rs" ? FontWeight.w100 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      Container(
                        height: 75,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Jumlah Kamar",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              kapasitas,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 75,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            Text("Kamar Tersedia"),
                            Text(
                              tersedia,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
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
