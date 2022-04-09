import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
 // DetailScreen({Key? key}) : super(key: key);
  var todo;
  late Future<UserPosts> futureAlbum;

  @override
  void initState() {
   // 
    super.initState();
   //futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
     todo = ModalRoute.of(context)!.settings.arguments;
     final Future<UserPosts> post;
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: 
     FutureBuilder<UserPosts>(
            future: fetchPosts(todo),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.body);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),

     /*  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(todo.toString()),
      ), */
    );
  }
}





class UserPosts{
  String userId;
  int id;
  String title;
  String body;

  UserPosts({required this.userId, required this.id, required this.title, required this.body});

 factory UserPosts.fromJson(Map<String, dynamic> json) {
    return UserPosts(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"]
    );
  }
} 



Future<UserPosts> fetchPosts(todo) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId={$todo}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
     return UserPosts.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}



