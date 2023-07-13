import 'package:flutter/material.dart';

class Comment {
  Comment(
      {required this.comment_id, required this.content, required this.pin_id});
  int comment_id;
  String content;
  int pin_id;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment_id: json['comment_id'] as int,
      content: json['content'] as String,
      pin_id: json['point_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': comment_id,
      'content': content,
      'point_id': pin_id,
    };
  }
}

class Comments {
  late int pin_id;
  List<Comment> comment_list = [];
  Comments();
  Future<void> update_Comments(BuildContext context) async {
    // TODO get comments_list
  }
  void set_pin_id(int pin_id) {
    this.pin_id = pin_id;
  }
}

class CommentListPage extends StatefulWidget {
  final int pin_id;
  final DateTime upload_time;
  CommentListPage({required this.pin_id, required this.upload_time});

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  Comments comments = Comments();
  void initState() {
    super.initState();
    comments.set_pin_id(widget.pin_id);
    comments.update_Comments(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment List'),
      ),
      //update comments before Comment List with delete and good bad botton, and add comment add form
      body: FutureBuilder<void>(
        future: comments.update_Comments(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // show comment list with upload time and delete and good bad botton
            return Column(
              children: [
                Text('Upload Time: ${widget.upload_time}'),
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.comment_list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments.comment_list[index].content),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              onPressed: () {
                                // TODO good
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.thumb_down),
                              onPressed: () {
                                // TODO bad
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // TODO delete
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Comment upload form
                CommentUploadForm(),
              ],
            );
          } else {
            // show loading while waiting response
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// Comment upload form
class CommentUploadForm extends StatefulWidget {
  @override
  _CommentUploadFormState createState() => _CommentUploadFormState();
}

class _CommentUploadFormState extends State<CommentUploadForm> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Comment form
          TextFormField(
            decoration: InputDecoration(labelText: 'Comment'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter comment';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _content = value;
              });
            },
          ),
          // Submit button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO submit
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter comment'),
                  ),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
