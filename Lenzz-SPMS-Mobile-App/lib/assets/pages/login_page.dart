import 'package:flutter/material.dart';
import 'package:test_app/assets/pages/dashboard.dart';
import 'package:test_app/assets/pages/forgot_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'chooseProject.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;
  bool loading = false;

  var _mail;
  var _password;
  void _updateEmail(val) {
    setState(() {
      _mail = val;
    });
  }

  void _updatePassword(val) {
    setState(() {
      _password = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 237, 250),
      appBar: AppBar(
        title: const Text("Sign In"),
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
                  "assets/p.png",
                  width: 210,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onChanged: ((val) {
                    _updateEmail(val);
                  }),
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (val) {
                    _updatePassword(val);
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: passwordController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    } else if (passwordController.text.length < 8) {
                      return "Password Length Should be more than 8 characters";
                    }
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () async {
                    if (_formfield.currentState!.validate()) {
                      print(emailController.text);
                      print(passwordController.text);

                      setState(() {
                        loading = true;
                      });
                      // Make POST request
                      final response = await http.post(
                        Uri.parse('${dotenv.env['IP_ADDRESS']}/api/user/login'),
                        body: {
                          'email': emailController.text,
                          'password': passwordController.text,
                        },
                      );
                      final responseData = jsonDecode(response.body);
                      // Check response status code
                      if (response.statusCode == 200) {
                        // Successful request, do something with the response

                        final token = responseData['token'];
                        print(token);
                        //save the token in sherd preparence

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('token', token);

                        emailController.clear();
                        passwordController.clear();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ListItem()));
                      } else {
                        // Request failed, handle the error
                        print(
                            'Request failed with status: ${response.statusCode}.');

                        final errorMessage = responseData['error'];
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Log In",
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
