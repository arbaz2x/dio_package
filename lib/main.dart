import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main (){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: DataFromAPI(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {



  Future getUserData()async {
    var response = await http.get(
        ((Uri.parse('jsonplaceholder.typicode.com/users'))));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u['name'], u['email'], u['userName']);
      users.add(user);
    }
  }

  Future<Album> fetchAlbum() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/5'));
    //print(response.contentLength);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  late Future<Album> futureAlbum;
  // late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: const Text('User Data'),
      ),
      body: Center(
        child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: const Center(
                      child: Text('loading data in few secs'),
                    ));
              } else
              {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data!.name),
                        subtitle: Text(snapshot.data!.username),
                        trailing: Text(snapshot.data!.email),

                      );
                    });
                // By default, show a loading spinner.
              }

              return const CircularProgressIndicator();

            }),
      ),

    );
  }
}
class User {

  final String name,email,userName;
  User(this.name,this.email,this.userName);


}

class Album {
  final String name;
  final String username;
  final String email;

  const Album({
    required this.name,
    required this.username,
    required this.email,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

 get length => 1;
}



