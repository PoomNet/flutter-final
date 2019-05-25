import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'profile.dart';
import 'register.dart';
import 'sqlprofile.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  final CounterStorage storage;

  ProfileScreen({Key key, this.title, @required this.storage})
      : super(key: key);

  final String title;

  @override
  ProfileScreenState createState() => new ProfileScreenState();
}

class CounterStorage {
  //ต้องส่ง storage: CounterStorage() สำคัญมากๆๆๆๆๆๆๆๆๆ
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  var check = 0;
  final fkey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final passController = TextEditingController();
  final quoteController = TextEditingController();
  Future<List<ProfileItem>> _todoItems;
  List<ProfileItem> _completeItems = List();
  DataAccess dataAccess = DataAccess();
  List<ProfileItem> user;

  String _counter = "";

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((String value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter(String value) {
    setState(() {
      _counter = value;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add),
              color: Colors.white,
              // onPressed: _addTodoItem,
            )
          ],
        ),
        body: Form(
          key: fkey,
          child: Container(
              height: 500,
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: CurrentUser.USER), //โชของเดิม
                    controller: userController,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Please fill username 6-12";
                      } else if (value.length > 12) {
                        return "Please fill username 6-12";
                      } else if (value.isEmpty) {
                        return "Please fill username 6-12";
                      }
                    },
                    onSaved: (value) => print(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), hintText: CurrentUser.NAME),
                    controller: nameController,
                    validator: (value) {
                      int check = 0;
                      value.runes.forEach((int rune) {
                        var character = new String.fromCharCode(rune);
                        if (character == ' ') {
                          check += 1;
                        }
                      });
                      if (check == 0) {
                        return "Please fill name and lastname";
                      }
                    },
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), hintText: 'Please Enter Age'),
                    controller: ageController,
                    validator: (value) {
                      if (int.parse(value) < 10) {
                        return "Please fill age 10-80";
                      } else if (int.parse(value) > 80) {
                        return "Please fill age 10-80";
                      } else if (value.isEmpty) {
                        return "Please fill age 10-80";
                      }
                    },
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Please Enter password'),
                    controller: passController,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Please fill password > 6";
                      } else if (value.isEmpty) {
                        return "Please fill password > 6";
                      }
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), hintText: 'Please Enter Quote'),
                    controller: quoteController,
                    validator: (value) {},
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                  RaisedButton(
                      child: Text("Continue"),
                      onPressed: () async {
                        await dataAccess.open();
                        bool status = true;
                        var userlist = await dataAccess.getAllUser();
                        for (var i = 0; i < user.length; i++) {
                          print(user[i].user);
                          if (user[i].user == userController.text &&
                              user[i].pass == passController.text) {
                            check += 1;
                            break;
                          }
                        }

                        if (fkey.currentState.validate() && status) {
                          ProfileItem update = ProfileItem();
                          update.id = CurrentUser.USERID;
                          CurrentUser.USER = update.user = userController.text;
                          CurrentUser.NAME = update.name = nameController.text;
                          CurrentUser.AGE = update.age = ageController.text;
                          CurrentUser.PASSWORD =
                              update.pass = passController.text;
                          CurrentUser.QUOTE = quoteController.text;
                          _incrementCounter(quoteController.text);
                          await dataAccess.update(update);
                        }

                        // async {
                        //   if (fkey.currentState.validate()) {
                        //     await dataAccess.open();

                        //     ProfileItem data = ProfileItem(); //สร้างไว้updateค่า ต้องมีid
                        //     data.id = CurrentUser.USERID;
                        //     data.user = userController.text;
                        //     data.name = nameController.text;
                        //     data.age = ageController.text;
                        //     data.pass = passController.text;

                        //     userController.text = '';
                        //     nameController.text = '';
                        //     ageController.text = '';
                        //     passController.text = '';

                        //     await dataAccess.update(data);
                        //     CurrentUser.NAME = data.name;
                        //     CurrentUser.USER = data.user;
                        //     CurrentUser.AGE = data.age;
                        //     CurrentUser.PASSWORD = data.pass;
                        //     Navigator.pop(context);
                        //   }
                        // }
                      }),
                ],
              )),
        ));
  }
}
