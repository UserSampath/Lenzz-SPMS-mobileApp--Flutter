import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chooseProject.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Task {
  String progressStage;
  String taskTitles;
  Color flagColor;
  String linkedTask;
  String assignTo;
  String reportTo;
  String startDate;
  String endDate;
  String description;

  Task({
    required this.progressStage,
    required this.taskTitles,
    required this.flagColor,
    required this.linkedTask,
    required this.assignTo,
    required this.reportTo,
    required this.startDate,
    required this.endDate,
    required this.description,
  });
}

class MyObject {
  final dynamic id;
  final dynamic title;
  final List<dynamic> cards;


  MyObject(this.id, this.title, this.cards);
}

class MyJobs extends StatefulWidget {
  final String id;

  MyJobs({Key? key, required this.id}) : super(key: key);

  @override
  State<MyJobs> createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> with
    SingleTickerProviderStateMixin{

  List<dynamic> _projects = [];
  List <MyObject> tasksWhithPs = [];


  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    getProjects(context);
    fetchData(); // Call the method to fetch data from the API
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Update this line to check for nullability
    super.dispose();
  }

  Future<String> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  void getProjects(BuildContext context) async {
    String a = await getTokenFromSharedPreferences();
    print('Text was clicked ${a}');
    final response = await http.get(
      Uri.parse('${dotenv.env['IP_ADDRESS']}/api/project'),
      headers: {'Authorization': 'Bearer $a'},
    );
    final responseData = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        _projects = responseData.map((item) => item['projectname']).toList();
        print(_projects);
      });
    } else if (response.statusCode == 400) {
      print('Bad');
    } else if (response.statusCode == 401) {
      print('Request is not authorized');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
    } else {
      print('Request failed with status: ${response.statusCode}.');
      final errorMessage = responseData['error'];
      print(errorMessage);
    }
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> requestBody = {
        'id': widget.id,
      };
      final response = await http.post(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/progressStage/taskWithPS'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          tasksWhithPs = List<MyObject>.from(responseData.map((item) {
            return MyObject(
              item['_id'],
              item['title'],
              item['cards'],
            );
          }));

          tabs = tasksWhithPs.map((myObject) => Tab(child: Text(myObject.title))).toList();
        });

        print("aaaaaaaaaaaa${tasksWhithPs}");

        tasksWhithPs.forEach((MyObject item) {
          print('id: ${item.id}');
          print('title: ${item.title}');
          print('cards: ${item.cards}');
        });


        List<Task> fetchedTasks = [];
        for (var progressData in responseData['progressstage']) {
          for (var taskData in progressData) {
            final progressStage = taskData['progressStage'];
            final title = taskData['title'];
            final flagColor = _getColorFromHex(taskData['flagColor']);
            final linkedTask = taskData['linkedTask'];
            final assignTo = taskData['assignTo'];
            final reportTo = taskData['reportTo'];
            final startDate = taskData['startDate'];
            final endDate = taskData['endDate'];
            final description = taskData['description'];

            Task task = Task(
              progressStage: progressStage,
              taskTitles: title,
              flagColor: flagColor,
              linkedTask: linkedTask,
              assignTo: assignTo,
              reportTo: reportTo,
              startDate: startDate,
              endDate: endDate,
              description: description,
            );
            fetchedTasks.add(task);
          }
        }
        setState(() {
          _tabController = TabController(
            length: tasksWhithPs.length,
            vsync: this,
          );
        });
      } else if (response.statusCode == 400) {
        print('Bad');
      } else if (response.statusCode == 401) {
        print('Request is not authorized');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        final errorMessage = responseData['error'];
        print(errorMessage);
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
  List<Tab> tabs=[];
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 237, 250),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (BuildContext context) {
                return BackButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const ListItem()));
                    }
                );
              },
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/hasthiya.png',
                  height: 70,
                  width: 70,
                ),
                Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      dropdownColor: Color.fromARGB(255, 11, 149, 255),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      items: List.generate(
                        _projects.length,
                            (index) => DropdownMenuItem<String>(
                          value: (index + 1).toString(),
                          child: Center(child: Text(_projects[index])),
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
                            fontSize: 17.0,
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
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://as2.ftcdn.net/v2/jpg/04/33/76/69/1000_F_433766963_8gZOOwnAHgrsSl1MMEi4t712X1ZD8d66.jpg'),
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 11, 149, 255),
                child: PopupMenuButton(
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
              ),
            ],
            backgroundColor: Color.fromARGB(255, 11, 149, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
            ),

            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child:TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            )
        ),

        body: TabBarView(
          controller: _tabController,
          children: List.generate(
            tasksWhithPs.length,
                (index) => ListView.builder(
              itemCount: tasksWhithPs[index].cards.length,
              itemBuilder: (context, cardIndex) {
                final cardTitle = tasksWhithPs[index].cards[cardIndex]['name'];

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.white,
                          title: Text("${tasksWhithPs[index].cards[cardIndex]['name']}"),
                          content: DefaultTextStyle(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            child: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Row(
                                    children: [
                                      Text("Flag: ${tasksWhithPs[index].cards[cardIndex]['flag']}"),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text("Linked Task: ${tasksWhithPs[index].cards[cardIndex]['link']}"),
                                  SizedBox(height: 8.0),
                                  Text("Assign To: ${tasksWhithPs[index].cards[cardIndex]['assign']}"),
                                  SizedBox(height: 8.0),
                                  Text("Report To: ${tasksWhithPs[index].cards[cardIndex]['reporter']}"),
                                  SizedBox(height: 8.0),
                                  Text("Start Date: ${tasksWhithPs[index].cards[cardIndex]['startDate']} "),
                                  SizedBox(height: 8.0),
                                  Text("End Date: ${tasksWhithPs[index].cards[cardIndex]['endDate']} "),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${tasksWhithPs[index].cards[cardIndex]['description']}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://sampathnalaka.s3.eu-north-1.amazonaws.com/uploads/IMG_20210907_151753_997.jpg",
                        ),
                      ),
                      title: Text(
                        cardTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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