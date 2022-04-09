import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/publicaciones.dart';

void main() => runApp(new MaterialApp(
  home: new HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    setState(() {
      for (var user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: Text('Home'),
        elevation: 0.0,
      ),
      body:  Column(
        children: <Widget>[
           Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Card(
                child:  ListTile(
                  leading:  Icon(Icons.search),
                  title:  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          // ignore: unnecessary_new
           Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ?  ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return  Card(
                  child: ListTile(
                   // leading: new CircleAvatar(backgroundImage: new NetworkImage(_searchResult[i].profileUrl,),),
                    title: Text(_searchResult[i].firstName + ' ' + _searchResult[i].lastName),
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                :  ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
      
            return  Card(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               ListTile(
                
                title:  Text(_userDetails[index].firstName + ' ' + _userDetails[index].lastName),
                 subtitle:  Text(
                   _userDetails[index].phone,
                   
                ),
                
                
              ),
              Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: 
               Text(_userDetails[index].email),
              
              ) ,
           
                ButtonBar(
                  children: <Widget>[
                     FlatButton(
                      child: const Text('VER PUBLICACIONES'),
                      onPressed: () {
                         /* ... */
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  DetailPage(),
                            settings: RouteSettings(
                            arguments: _userDetails[index].id,
                            ),),
                          );
                          
                    
                      })
                  
                  ],
                ),
                       
            ],
          ),
            );

              },
            ),
          ),
        ],
      ),
  );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  final int id;
  final String firstName, lastName, phone, email;

  UserDetails({required this.id, required this.firstName, required this.lastName, required this.phone, required this.email});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
      phone: json['phone'],
      email: json['email']
    );
  }
}