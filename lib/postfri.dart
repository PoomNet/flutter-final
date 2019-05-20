import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobilefinal/todofri.dart';

import 'comment.dart';
// import './myfriendPage.dart';

class PostFriendPage extends StatefulWidget {
  int id;
  PostFriendPage({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

Future<List<User>> fetchUsers(int userid) async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/users/${userid}/posts');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    print(body);
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
  final String title;
  final String body;

  User({this.id, this.title, this.body});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class FriendPageState extends State<PostFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            FutureBuilder(
              future: fetchUsers(widget.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<User> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: InkWell(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${(values[index].id).toString()} : ${values[index].title}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(values[index].body)
                ]),
                 onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComFriendPage(id: values[index].id),
                ),
              );
            },
          ));
        },
      ),
    );
  }
}
