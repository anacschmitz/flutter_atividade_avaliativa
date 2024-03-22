import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UsersPage(),
    );
  }
}
 
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}
 
class _UsersPageState extends State<UsersPage> {
  Future<List<User>> readJson() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final data = await json.decode(response);
    return List<User>.from(data["users"].map((x) => User.fromJson(x)));
  }
 
  @override
  Widget build(BuildContext context) {
    var container = Container(
        color: Colors.green[100],
        child: FutureBuilder<List<User>>(
          future: readJson(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];
                    return Card(
                      color: Colors.green[50],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            return CircularProgressIndicator();
          },
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: container,
    );
  }
}
 
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
 
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
  });
 
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      imageUrl: json['image'],
    );
  }
}