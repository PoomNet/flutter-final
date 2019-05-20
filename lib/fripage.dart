import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobilefinal/todofri.dart';

import 'postfri.dart';
// import './myfriendPage.dart';

class EachFriendPage extends StatefulWidget {
  int id;
  String user;
  EachFriendPage({Key key, @required this.id, @required this.user}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    // print(body);
    for (int i = 0; i < body.length; i++) {
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }

    return userApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User({this.id, this.name, this.email, this.phone, this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class FriendPageState extends State<EachFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(widget.user),
            RaisedButton(
              child: Text("BACK"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            RaisedButton(
                child: Text("post"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostFriendPage(id: widget.id)));
                }),
            RaisedButton(
                child: Text("todo"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TodoFriendPage(id: widget.id)));
                }),
          ],
        ),
      ),
    );
  }

}
