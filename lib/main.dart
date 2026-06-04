import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            return snapshot.data!.getString('username') == null
                ? LogIn()
                : App();
          }
        },
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(backgroundColor: Color(0xFFF8F9FA)),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(Icons.bar_chart_rounded, size: 60, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            "Welcome Back!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Please enter your name to continue",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 16),
          TextField(
            controller: name,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              hintText: "Your Name",
              prefixIcon: Icon(Icons.person_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (name.text.isNotEmpty) {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setString('username', name.text);
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        Text(
                          "Please enter your name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.all(12)),
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            child: Text(
              "Log In",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String username = '';
  final title = TextEditingController();
  final description = TextEditingController();
  final time = TextEditingController();
  final date = TextEditingController();

  final titleEdit = TextEditingController();
  final descriptionEdit = TextEditingController();
  final timeEdit = TextEditingController();
  final dateEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        username = prefs.getString('username')!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        title: Text(
          "Hi, $username",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actionsPadding: EdgeInsets.all(8),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.manage_accounts,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: TextField(
                    maxLength: 20,
                    controller: titleEdit..text = username,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Your Name",
                      prefixIcon: Icon(Icons.person_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (titleEdit.text.isNotEmpty) {
                          Navigator.pop(context);
                          setState(() {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString('username', titleEdit.text);
                            });
                            username = titleEdit.text;
                          });
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
              foregroundColor: WidgetStateProperty.all(Colors.blue),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            icon: Icon(Icons.manage_accounts),
          ),
        ],
      ),
      body: FutureBuilder(
        future: DBHelper().read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: snapshot.data![index].isCompleted,
                      onChanged: (value) {
                        setState(() {
                          DBHelper().update(
                            Task(
                              id: snapshot.data![index].id,
                              title: snapshot.data![index].title,
                              description: snapshot.data![index].description,
                              date: snapshot.data![index].date,
                              isCompleted: value!,
                            ),
                            snapshot.data![index].id!,
                          );
                        });
                      },
                    ),
                    title: Text(
                      snapshot.data![index].title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: snapshot.data![index].isCompleted
                            ? Colors.grey
                            : Colors.black,
                        decoration: snapshot.data![index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data![index].description ?? ''),
                        Text(snapshot.data![index].date ?? ''),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                icon: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.edit,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  "Edit Task",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(0),
                                  children: [
                                    TextField(
                                      controller: titleEdit
                                        ..text = snapshot.data![index].title!,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: "Title",
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: descriptionEdit
                                        ..text =
                                            snapshot.data![index].description!,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: "Description",
                                        prefixIcon: Icon(Icons.description),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: dateEdit
                                              ..text = snapshot
                                                  .data![index]
                                                  .date!
                                                  .split(" - ")
                                                  .first,
                                            keyboardType: TextInputType.none,
                                            textInputAction:
                                                TextInputAction.next,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2101),
                                                  );
                                              if (pickedDate != null) {
                                                setState(() {
                                                  dateEdit.text =
                                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Date",
                                              prefixIcon: Icon(
                                                Icons.calendar_today,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: timeEdit
                                              ..text = snapshot
                                                  .data![index]
                                                  .date!
                                                  .split(" - ")
                                                  .last,
                                            keyboardType: TextInputType.none,
                                            textInputAction:
                                                TextInputAction.done,
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                              if (pickedTime != null) {
                                                setState(() {
                                                  timeEdit.text = pickedTime
                                                      .format(context);
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Time",
                                              prefixIcon: Icon(
                                                Icons.access_time,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[100],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[100],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (titleEdit.text.isNotEmpty &&
                                          descriptionEdit.text.isNotEmpty &&
                                          dateEdit.text.isNotEmpty &&
                                          timeEdit.text.isNotEmpty) {
                                        Navigator.pop(context);
                                        setState(() {
                                          DBHelper().update(
                                            Task(
                                              id: snapshot.data![index].id,
                                              title: titleEdit.text,
                                              description: descriptionEdit.text,
                                              date:
                                                  "${dateEdit.text} - ${timeEdit.text}",
                                              isCompleted: snapshot
                                                  .data![index]
                                                  .isCompleted,
                                            ),
                                            snapshot.data![index].id!,
                                          );
                                        });
                                        titleEdit.clear();
                                        descriptionEdit.clear();
                                        dateEdit.clear();
                                        timeEdit.clear();
                                      }
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.grey[200],
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.blue,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              DBHelper().delete(snapshot.data![index].id!);
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.grey[200],
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.red,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Colors.white,
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              icon: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.add_alarm_sharp,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Add New Task",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                children: [
                  TextField(
                    controller: title,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Title",
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Description",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: date,
                          keyboardType: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                date.text =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Date",
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: time,
                          keyboardType: TextInputType.none,
                          textInputAction: TextInputAction.done,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                time.text = pickedTime.format(context);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Time",
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (title.text.isNotEmpty &&
                        description.text.isNotEmpty &&
                        date.text.isNotEmpty &&
                        time.text.isNotEmpty) {
                      Navigator.pop(context);
                      setState(() {
                        DBHelper().insert(
                          Task(
                            title: title.text,
                            description: description.text,
                            date: "${date.text} - ${time.text}",
                            isCompleted: false,
                          ),
                        );
                      });
                      title.clear();
                      description.clear();
                      date.clear();
                      time.clear();
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  int? id;
  String? title;
  String? description;
  String? date;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'isCompleted': isCompleted,
    };
  }
}

class DBHelper {
  Database? db;

  Future openDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (db != null) return db;
    db = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, isCompleted BOOLEAN)',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insert(Task task) async {
    final db = await openDB();
    await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> read() async {
    final db = await openDB();
    final List<Map<String, Object?>> taskMaps = await db.query('tasks');
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String,
            'date': date as String,
            'isCompleted': isCompleted as int,
          }
          in taskMaps)
        Task(
          id: id,
          title: title,
          description: description,
          date: date,
          isCompleted: isCompleted == 1,
        ),
    ];
  }

  Future<void> update(Task task, int id) async {
    final db = await openDB();
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await openDB();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
