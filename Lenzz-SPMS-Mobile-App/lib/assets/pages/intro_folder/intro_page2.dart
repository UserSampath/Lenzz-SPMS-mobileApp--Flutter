import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/sed.gif",
                    width: 300.0,
                    height: 300.0,
                  ),
                ),
                Text(
                  "Team Sprit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Collaborative Work \n Time Mangement \n Daily stand-ups",
                      textAlign: TextAlign.left,
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