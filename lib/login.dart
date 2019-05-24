import 'package:flutter/material.dart';
import 'profile.dart';
import 'sqlprofile.dart';
import 'register.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Loginstate();
  }
}

class Loginstate extends State<Loginpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  DataAccess _dataAccess = DataAccess();
  Future<List<ProfileItem>> alluser;
  final GlobalKey<ScaffoldState> _scafkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  CurrentUser currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scafkey,
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Image.asset("image/1.jpg", width: 300),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_circle), hintText: 'User ID'),
                  controller: userController,
                  validator: (value) {},
                  keyboardType: TextInputType.text,
                  onSaved: (value) => print(value),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), hintText: 'Password'),
                  controller: passController,
                  validator: (value) {},
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  onSaved: (value) => print(value),
                ),
                RaisedButton(
                    child: Text("Login"),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      _dataAccess.open();
                      int check = 0, i = 0;
                      alluser = _dataAccess.getAllUser();

                      var user = await alluser;
                      for (i = 0; i < user.length; i++) {
                        print(user[i].user);
                        if (user[i].user == userController.text &&
                            user[i].pass == passController.text) {
                          check += 1;
                          break;
                        }
                      }
                      print(check);
                      _formKey.currentState.validate();
                      if (userController.text == "" ||
                          passController.text == "") {
                        _scafkey.currentState.showSnackBar(SnackBar(
                          content: Text('กรุณา ระบุ user or password'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ));
                      } else if (check != 1) {
                        _scafkey.currentState.showSnackBar(SnackBar(
                          content: Text('user or passwordผผิด'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        // final myString = prefs.getString('my_string_key') ?? '';
                        prefs.setString('username', user[i].user);
                        prefs.setString('name', user[i].name);
                        userController.text = "";
                        passController.text = "";
                        CurrentUser.USERID = user[i].id;
                        CurrentUser.USER = user[i].user;
                        CurrentUser.NAME = user[i].name;
                        CurrentUser.AGE = user[i].age;
                        CurrentUser.PASSWORD = user[i].pass;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoListScreen()));
                      }
                    }),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        child: Text(
                          "Register New Account",
                          style:
                              TextStyle(color: Color.fromARGB(1000, 0, 234, 0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        })),
              ],
            ),
          ),
        ));
  }
}
