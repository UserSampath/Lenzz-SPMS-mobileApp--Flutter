import 'package:flutter/material.dart';
import 'package:test_app/assets/pages/login_page.dart';
import 'package:test_app/assets/pages/verify_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool passToggle = true;
  bool loading = false;
  var _email;

  void _updateEmail(val) {
    setState(() {
      _email = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 237, 250),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Lock.png",
                  width: 220,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  onChanged: (value) {
                    _updateEmail(value);
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: ((value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    if (value.isEmpty) {
                      return "Enter Email";
                    } else if (!emailValid) {
                      return "Enter valid email address";
                    }
                  }),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login()));
                      },
                      child: const Text(
                        "Back to Sign in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  // onTap: () {
                  //   if (_formfield.currentState!.validate()) {
                  //     print("success");
                  //     print(emailController.text);

                  //     emailController.clear();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const VerifyOTP()));
                  //   }
                  // }
                  // ,
                  onTap: () async {
                    if (_formfield.currentState!.validate()) {
                      print(emailController.text);

                      setState(() {
                        loading = true;
                      });
                      // Make POST request
                      final response = await http.post(
                        Uri.parse(
                            'http://192.168.8.102:4000/api/user/generateOTP'),
                        body: {
                          'email': emailController.text,
                        },
                      );
                      final responseData = jsonDecode(response.body);
                      if (response.statusCode == 200) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              VerifyOTP(email: emailController.text),
                        ));
                      } else {
                        // Request failed, handle the error
                        print(
                            'Request failed with status: ${response.statusCode}.');

                        final errorMessage = responseData['error'];
                        // final errorMessage = "xvx";
                        print(errorMessage);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(errorMessage),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        emailController.clear();
                      }
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Send OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
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
