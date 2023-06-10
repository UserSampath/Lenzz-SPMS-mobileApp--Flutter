import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:test_app/assets/pages/login_page.dart';
import 'package:test_app/assets/pages/new_password.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  final String email;
  const VerifyOTP({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final _formfield = GlobalKey<FormState>();
  final OTPController = TextEditingController();
  bool passToggle = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 237, 250),
      appBar: AppBar(
        title: const Text("OTP Verification"),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                  "assets/Mail.png",
                  width: 230,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Enter Verification code",
                      style: TextStyle(
                        color: Color(0xFF155081),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: OTPController,
                  decoration: const InputDecoration(
                    labelText: "OTP",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Enter OTP";
                    } else if (OTPController.text.length < 6 ||
                        OTPController.text.length > 6) {
                      return "OTP should be 6 characters";
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
                  onTap: () async {
                    print("EMAIL ${widget.email}");

                    if (_formfield.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      final response = await http.post(
                        Uri.parse(
                            '${dotenv.env['IP_ADDRESS']}/api/user/checkOTP'),
                        body: {
                          'email': widget.email,
                          'otp': OTPController.text,
                        },
                      );
                      print("QQQ ${widget.email}, ${OTPController.text}");

                      final responseData = jsonDecode(response.body);
                      if (response.statusCode == 200) {
                        print("200");
                        setState(() {
                          loading = false;
                        });

                        OTPController.clear();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              NewPassword(email: widget.email),
                        ));
                      } else {
                        // Request failed, handle the error
                        setState(() {
                          loading = false;
                        });
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
                        OTPController.clear();
                      }
                      print("success");
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Verify",
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
