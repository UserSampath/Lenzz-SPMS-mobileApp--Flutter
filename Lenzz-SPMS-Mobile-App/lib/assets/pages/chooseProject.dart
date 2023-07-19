import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'new_a.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const ListItem());
}

class ListItem extends StatefulWidget {
  const ListItem({Key? key}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class MyObject {
  final dynamic projectName;
  final dynamic id;

  MyObject(this.projectName, this.id);
}

class _ListItemState extends State<ListItem> {
  List<MyObject> _items = [];

  @override
  void initState() {
    super.initState();
    getProjects(context);
  }

  Future<String> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  //A list of projects needs to be retrieved from a backend API
  void getProjects(BuildContext context) async {
    String a = await getTokenFromSharedPreferences();
    print('Text was clicked ${a}');
    final response = await http.get(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/api/project'),
      headers: {'Authorization': 'Bearer ${a}'},
    );
    final responseData = jsonDecode(response.body);
    print("project responce ${responseData}");
    if (response.statusCode == 200) {

      setState(() {
        _items = List<MyObject>.from(responseData.map((item) {
          return MyObject(
            item['projectname'],
            item['_id'],
          );
        }));
      });
      _items.forEach((MyObject item) {
        print('Project Name: ${item.projectName}');
        print('ID: ${item.id}');
        print('---');
      });
      print("state ${_items.length}");
    }else if(response.statusCode==400){
      print('Bad');
    }
    else if (response.statusCode == 401) {
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
      backgroundColor: Colors.blue[400],
      body: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Choose \n your project',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/hit.png',
            height: 200,
            width: 200,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(width: 2, color:Color(0xFF42A5F5),),
                        ),
                        child: ListTile(
                          onTap: () {
                            print("contextqqqqqqqqq${_items}");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyJobs(id: _items[index].id),
                              ),
                            );
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _items[index].projectName,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://as2.ftcdn.net/v2/jpg/04/33/76/69/1000_F_433766963_8gZOOwnAHgrsSl1MMEi4t712X1ZD8d66.jpg'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}