import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MyJobs extends StatefulWidget {
  const MyJobs({super.key});

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {

  List<dynamic> _items = [];
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    getProjects(context);
    getTasks(context);
  }


  Future<String> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }
//A list of projects needs to be retrieved Drop down menu from a backend API
  void getProjects(BuildContext context) async {
    String a = await getTokenFromSharedPreferences();
    print('Text was clicked ${a}');
    final response = await http.get(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/api/project'),
      headers: {'Authorization': 'Bearer ${a}'},
    );
    final responseData = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _items = responseData.map((item) => item['projectname']).toList();
        print(_items);
      });
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


  //task api
  void getTasks(BuildContext context) async {
    print("aaaaaa ${context}");
    String token = await getTokenFromSharedPreferences();
    print('Text was clicked $token');
    Map<String, dynamic> requestBody = {
      'id': '648077ce822996c09ca50e05',
    };

    final response = await http.post(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/progressStage/taskWithPS'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    try {
      final responseData = jsonDecode(response.body);
      print("aaaa${response.statusCode}");
      print("ddd${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          _tasks = (responseData as List<dynamic>).cast<Map<String, dynamic>>();
        });
        print(_tasks);

    } else if (response.statusCode == 400) {
        print('Bad');
      } else if (response.statusCode == 401) {
        print('Request is not authorized');
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Login()));
      } else {
        print('Request failed with status: ${response.statusCode}.');
        final errorMessage = responseData['error'];
        print(errorMessage);
      }
    } catch (e) {
      print('Error decoding response body: $e');
    }
  }


  List<Tab> tabs=[
    Tab(child: Text("ToDo")),
    Tab(child: Text("In Progress")),
    Tab(child: Text("QA")),
    Tab(child: Text("Done")),
    Tab(child: Text("Started")),
  ];



  List<Map<String, dynamic>> cardDataList = [
    {
      'title': 'Front End Design',
      'date': 'March 4, 2023',
    },
    {
      'title': 'Back End Development',
      'date': 'March 6, 2023',
    },
    {
      'title': 'Create Chat App',
      'date': 'April 2, 2023',
    },
    {
      'title': 'DB Connection',
      'date': 'March 20, 2023',
    },
    {
      'title': 'Mobile App Development',
      'date': 'March 6, 2023',
    },
    {
      'title': 'Mobile App Development',
      'date': 'March 6, 2023',
    },

  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 2.0),
                child: InkWell(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://as2.ftcdn.net/v2/jpg/04/33/76/69/1000_F_433766963_8gZOOwnAHgrsSl1MMEi4t712X1ZD8d66.jpg'),
                  ),
                ),
              ),
              PopupMenuButton(
                onSelected: (value) => _logout(context),
                itemBuilder: (BuildContext bc) {
                  return const [
                    PopupMenuItem(
                      value: '/logout',
                      child: Text("Logout",
                        style: TextStyle(fontSize: 14.0),),
                    ),
                  ];
                },
              ),
            ],
            backgroundColor: Colors.indigo[400],
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Hasthiya",
                  style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                ),
                Image.asset(
                  'assets/img.png',
                  height: 40,
                  width: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                ),
                Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      dropdownColor: Colors.indigo[300],
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      items: List.generate(
                        _items.length,
                            (index) => DropdownMenuItem<String>(
                          value: (index + 1).toString(),
                          child: Center(child: Text(_items[index])),
                        ),
                      ),
                      onChanged: (value) => {
                        print(value.toString()),
                      },
                      hint: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Projects',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child:TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            )
        ),

        body: Container(
          color: Colors.indigo[200],
          child: TabBarView(
            children: [
              Center(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width * 0.7,
                        height: height * 0.15,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: width * 0.010,
                            left: width * 0.01,
                            right: width * 0.01,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((15)),
                              side: const BorderSide(
                                  width: 3, color: Colors.black),
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[200],
                                      title: Text(_tasks[index]['title']),
                                      content: DefaultTextStyle(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        child: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Flag:"),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text("Linked Task:"),
                                              SizedBox(height: 8.0),
                                              Text("Assign To:"),
                                              SizedBox(height: 8.0),
                                              Text("Report To:"),
                                              SizedBox(height: 8.0),
                                              Text("Start Date: ${_tasks[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("End Date: ${_tasks[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("Description: Inside the app bar create 5 tab bar elements using React JS framework."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close', style: TextStyle(color: Colors.black),),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              title: Text(
                                _tasks[index]['title'],
                                textAlign: TextAlign.left,
                              ),
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: cardDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width * 0.7,
                        height: height * 0.15,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: width * 0.010,
                            left: width * 0.01,
                            right: width * 0.01,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((15)),
                              side: const BorderSide(
                                  width: 3, color: Colors.black),
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[200],
                                      title: Text(cardDataList[index]['title']),
                                      content: DefaultTextStyle(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        child: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Flag:"),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text("Link To:"),
                                              SizedBox(height: 8.0),
                                              Text("Assign To:"),
                                              SizedBox(height: 8.0),
                                              Text("Report To:"),
                                              SizedBox(height: 8.0),
                                              Text("Start Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("End Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("Description: Inside the app bar create 5 tab bar elements using React JS framework."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close', style: TextStyle(color: Colors.black),),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              title: Text(
                                cardDataList[index]['title'],
                                textAlign: TextAlign.left,
                              ),
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: cardDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width * 0.7,
                        height: height * 0.15,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: width * 0.010,
                            left: width * 0.01,
                            right: width * 0.01,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((15)),
                              side: const BorderSide(
                                  width: 3, color: Colors.black),
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[200],
                                      title: Text(cardDataList[index]['title']),
                                      content: DefaultTextStyle(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        child: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Flag:"),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text("Link To:"),
                                              SizedBox(height: 8.0),
                                              Text("Assign To:"),
                                              SizedBox(height: 8.0),
                                              Text("Report To:"),
                                              SizedBox(height: 8.0),
                                              Text("Start Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("End Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("Description: Inside the app bar create 5 tab bar elements using React JS framework."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close', style: TextStyle(color: Colors.black),),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              title: Text(
                                cardDataList[index]['title'],
                                textAlign: TextAlign.left,
                              ),
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: cardDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width * 0.7,
                        height: height * 0.15,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: width * 0.010,
                            left: width * 0.01,
                            right: width * 0.01,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((15)),
                              side: const BorderSide(
                                  width: 3, color: Colors.black),
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[200],
                                      title: Text(cardDataList[index]['title']),
                                      content: DefaultTextStyle(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        child: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Flag:"),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text("Link To:"),
                                              SizedBox(height: 8.0),
                                              Text("Assign To:"),
                                              SizedBox(height: 8.0),
                                              Text("Report To:"),
                                              SizedBox(height: 8.0),
                                              Text("Start Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("End Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("Description: Inside the app bar create 5 tab bar elements using React JS framework."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close', style: TextStyle(color: Colors.black),),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              title: Text(
                                cardDataList[index]['title'],
                                textAlign: TextAlign.left,
                              ),
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: cardDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: width * 0.7,
                        height: height * 0.15,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: width * 0.010,
                            left: width * 0.01,
                            right: width * 0.01,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((15)),
                              side: const BorderSide(
                                  width: 3, color: Colors.black),
                            ),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[200],
                                      title: Text(cardDataList[index]['title']),
                                      content: DefaultTextStyle(
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        child: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Flag:"),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Text("Link To:"),
                                              SizedBox(height: 8.0),
                                              Text("Assign To:"),
                                              SizedBox(height: 8.0),
                                              Text("Report To:"),
                                              SizedBox(height: 8.0),
                                              Text("Start Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("End Date: ${cardDataList[index]['date']}"),
                                              SizedBox(height: 8.0),
                                              Text("Description: Inside the app bar create 5 tab bar elements using React JS framework."),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close', style: TextStyle(color: Colors.black),),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              title: Text(
                                cardDataList[index]['title'],
                                textAlign: TextAlign.left,
                              ),
                              trailing: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg"
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear user authentication token or session data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => route.isFirst,
    ); // navigate user back to login screen
  }
}