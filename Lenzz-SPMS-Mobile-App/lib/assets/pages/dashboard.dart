import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/assets/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    clickedDashboard(context); // call the method here
  }

  Future<String> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  void clickedDashboard(BuildContext context) async {
    String a = await getTokenFromSharedPreferences();
    print('Text was clicked ${a}');
    final response = await http.get(
      Uri.parse('http://192.168.1.9:4000/api/user/getUsers'),
      headers: {'Authorization': 'Bearer ${a}'},
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('success');
    } else if (response.statusCode == 401) {
      print('Request is not authorized');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Login()));
    } else {
      print('Request failed with status: ${response.statusCode}.');
      final errorMessage = responseData['error'];
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 220, 237, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            GestureDetector(
              onTap: () => clickedDashboard(context),
              child: const Text(
                "this is Dashboard",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 34),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
