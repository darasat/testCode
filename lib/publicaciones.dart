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
     FutureBuilder<List<UserPosts>>(
            future: getPostsForUser(todo),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
             itemCount: 10,
             itemBuilder: (_, index) {
               return 
                  Card(
                  child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                    ListTile(
                
                    title: Text(snapshot.data![index].title.toString()),
                    subtitle: Text(
                    snapshot.data![index].body.toString(),
                   
                  ))]));

             } );
              } else if (snapshot.hasError) {
               // print (snapshot.error);
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
  int userId;
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



  Future<List<UserPosts>> getPostsForUser(int userId) async {
    // ignore: deprecated_member_use
    var posts = <UserPosts>[];
    // Get user posts for id
    var response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts?=$userId'));

    print (response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
      // parse into List
    var parsed = json.decode(response.body) as List<dynamic>;

    // loop and convert each item to Post
    for (var post in parsed) {
      //print (post);
      posts.add(UserPosts.fromJson(post));
    }

    return posts;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load posts');
  }
  


  }



