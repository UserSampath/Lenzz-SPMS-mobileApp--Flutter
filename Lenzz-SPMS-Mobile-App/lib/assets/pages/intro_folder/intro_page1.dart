import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/home.gif",
                    width: 300.0,
                    height: 300.0,
                  ),
                  Text(
                    "Lenzz Project Management System ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Unlock the full potential of your software projects with our all-in-one project management system. Seamlessly plan organize, and collaborate with our intuitive interface and powerful features. Experience streamlined workflows, enhanced communication, and project success, all wrapped in an attractive and user-friendly web application.",
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