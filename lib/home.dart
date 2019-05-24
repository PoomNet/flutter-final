import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'json.dart';
import 'login.dart';
import 'profile_screen.dart';
import 'profile.dart';
import 'register.dart';
import 'sqlprofile.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class TodoListScreen extends StatefulWidget {
  TodoListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoListScreenState createState() => new _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  var username = "";
  var name = "";
  Future<List<ProfileItem>> _todoItems;
  List<ProfileItem> _completeItems = List();
  DataAccess _dataAccess = DataAccess();
  List<ProfileItem> user;

  @override
  initState() {
    super.initState();
    loadData();
    _dataAccess.open();
    _todoItems = _dataAccess.getAllUser();
    _createTodoItemWidget(_todoItems);
  }

  void _createTodoItemWidget(Future<List<ProfileItem>> item) async {
    var a = await item;
    setState(() {
      user = a;
      print(user);
    });
  }

  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      name = prefs.getString('name') ?? '';
    });
    var url = 'http://example.com/whatsit/create';
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    http.Response resp = await http.get(url);
    Map<String, dynamic> data = json.decode(resp.body);
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
        body: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: Column(
                children: <Widget>[Text("Hello $name")],
              ),
            ),
            Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  Text(CurrentUser.NAME),
                  Text(CurrentUser.AGE),
                  RaisedButton(
                      child: Text("profile setup"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      }),
                  RaisedButton(
                      child: Text("json"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendPage()));
                      }),
                  RaisedButton(
                      child: Text("signout"),
                      onPressed: () {
                        CurrentUser.USERID = "";
                        CurrentUser.USER = "";
                        CurrentUser.NAME = "";
                        CurrentUser.AGE = "";
                        CurrentUser.PASSWORD = "";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()));
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
