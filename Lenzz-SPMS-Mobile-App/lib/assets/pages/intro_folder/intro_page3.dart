import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[400],
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/mag.png",
                  width: 300.0,
                  height: 300.0,
                ),
                Text(
                  "Best Quality Software Products ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "We believe in providing a streamlined approach to deliver high-quality products to our clients. Our goal is to ensure that the software solutions we develop meet and exceed their expectations.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),

      ),
    );
  }
}