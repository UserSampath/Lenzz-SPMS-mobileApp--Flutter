import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigoAccent,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/gra.gif",
                  width: 300.0,
                  height: 300.0,
                ),
                Text(
                  "Software Developmenet Life Cycle ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "The software development life cycle, proper documentation, version control, and collaboration among team members are crucial for smooth progress and successful completion of the project.",
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