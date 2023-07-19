import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_app/assets/pages/intro_folder/intro_page1.dart';
import 'package:test_app/assets/pages/intro_folder/intro_page2.dart';
import 'package:test_app/assets/pages/intro_folder/intro_page3.dart';
import 'login_page.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({Key? key}) : super(key: key);

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  PageController _controller = PageController();

  bool onLastPage=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index){
                setState((){
                  onLastPage = (index == 2);
                });
              },
              children: [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
              ],
            ),
            Container(
                alignment: Alignment(0, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //  skip
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return Login();
                            },
                            ),
                          );
                        },
                        child: Text("Skip", style: TextStyle(color: Colors.white),)),
                    //dot indicator
                    SmoothPageIndicator(controller: _controller, count: 3),
                    //next
                    onLastPage
                        ?GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return Login();
                            },
                            ),
                          );
                        },
                        child: Text("Done", style: TextStyle(color: Colors.white)))
                        :GestureDetector(
                        onTap: (){
                          _controller.nextPage(duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text("Next", style: TextStyle(color: Colors.white)))
                  ],
                )
            )

          ]


      ),
    );
  }
}

