import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  PostDetailScreen(this.post);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {

  // feTch the author's name from the API and display it
  Future<String> fetchAuthorName(int userId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData['name'];
    }

    return 'Author Not Found';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchAuthorName(widget.post['userId']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Author: ${snapshot.data}');
                }
              },
            ),
            Text(
              'Title:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.post['title'], style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(
              'Body:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(widget.post['body'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            // Fetch and style the author's name here
          ],
        ),
      ),
    );
  }
}
