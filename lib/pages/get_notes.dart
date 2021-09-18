/*

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:gitlab_mate/pages/CreateNote.dart';
//import 'package:gitlab_mate/pages/projectDescription.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Notes {
  int id;
  //Null type;
  String body;
  //Null attachment;
  Author author;
  String createdAt;
  String updatedAt;
  bool system;
  int noteableId;
  String noteableType;
  bool resolvable;
  bool confidential;
  int noteableIid;
  CommandsChanges commandsChanges;

  Notes(
      {this.id,
      //this.type,
      this.body,
      //this.attachment,
      this.author,
      this.createdAt,
      this.updatedAt,
      this.system,
      this.noteableId,
      this.noteableType,
      this.resolvable,
      this.confidential,
      this.noteableIid,
      this.commandsChanges});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    //type = json['type'];
    body = json['body'];
    //attachment = json['attachment'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    system = json['system'];
    noteableId = json['noteable_id'];
    noteableType = json['noteable_type'];
    resolvable = json['resolvable'];
    confidential = json['confidential'];
    noteableIid = json['noteable_iid'];
    commandsChanges = json['commands_changes'] != null
        ? new CommandsChanges.fromJson(json['commands_changes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    //data['type'] = this.type;
    data['body'] = this.body;
    //data['attachment'] = this.attachment;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['system'] = this.system;
    data['noteable_id'] = this.noteableId;
    data['noteable_type'] = this.noteableType;
    data['resolvable'] = this.resolvable;
    data['confidential'] = this.confidential;
    data['noteable_iid'] = this.noteableIid;
    if (this.commandsChanges != null) {
      data['commands_changes'] = this.commandsChanges.toJson();
    }
    return data;
  }
}

class Author {
  int id;
  String name;
  String username;
  String state;
  String avatarUrl;
  String webUrl;

  Author(
      {this.id,
      this.name,
      this.username,
      this.state,
      this.avatarUrl,
      this.webUrl});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    state = json['state'];
    avatarUrl = json['avatar_url'];
    webUrl = json['web_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['state'] = this.state;
    data['avatar_url'] = this.avatarUrl;
    data['web_url'] = this.webUrl;
    return data;
  }
}

class GetNotes extends StatefulWidget {
  final String token;
  final String projectId;
  //final String title;
  final String issueId;

  GetNotes({this.token, this.projectId, this.issueId});
  @override
  GetNotesState createState() => GetNotesState();
}

class GetNotesState extends State<GetNotes> {
  List<Notes> _noteList = new List<Notes>();
  Future<List<Notes>> _fetchNotes(
      String token, String projectId, String issueId) async {
    final jobsListAPIUrl =
        'https://gitlab.com/api/v4/projects/$projectId/issues/$issueId/notes?private_token=$token';
    final response = await http.get(jobsListAPIUrl);
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      setState(() {
        values = json.decode(response.body);
      });

      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _noteList.add(Notes.fromJson(map));
          }
        }
      }
      return _noteList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    this._fetchNotes(widget.token, widget.projectId, widget.issueId);
    //_projectIssueList.sort();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18.0,
                  ),
                  Container(
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              FlatButton(
                textColor: Colors.white,
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProjectIssueSearch(_noteList, widget.token),
                  );
                },
                child: Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text(
                    "Add new comments",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNote(
                          token: widget.token,
                          //title: widget.title,
                          //issueId: _noteList[index].id,
                          projectId: widget.projectId,
                          issueId: widget.issueId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          createListView(_noteList),
        ],
      ),
    );
  }

  Widget createListView(List<Notes> listVariable) {
    return Flexible(
      child: new ListView.builder(
        itemCount: listVariable.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 18.0,
                    ),
                    Flexible(
                      child: Container(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          child: listVariable[index].author.avatarUrl != null
                              ? CachedNetworkImage(
                                  width: 18.0,
                                  height: 18.0,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      listVariable[index].author.avatarUrl,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.yellow[700]),
                                  ),
                                  errorWidget: (context, url, error) => Image(
                                    height: 18.0,
                                    width: 18.0,
                                    image: AssetImage(
                                        'assets/icons/gitlab-mate-yellow-icon.png'),
                                  ),
                                )
                              : Image(
                                  height: 18.0,
                                  width: 18.0,
                                  image: AssetImage(
                                    'assets/icons/gitlab-mate-yellow-icon.png',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                        child: Text(
                          listVariable[index].author.name,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 18.0,
                    ),
                    Text(
                      "at: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "(" + listVariable[index].createdAt + ")",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      " says :",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 18.0,
                    ),
                    Flexible(
                      child: Text(
                        listVariable[index].body,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProjectIssueSearch extends SearchDelegate<Notes> {
  final List<Notes> noteList;
  static Notes result;
  final String token;
  ProjectIssueSearch(this.noteList, this.token);
  @override
  List<Widget> buildActions(BuildContext context) {
    // Todo: implement buildActions

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Todo: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  //Add the search term to the searchBloc.
  //The Bloc will then handle the searching and add the results to the searchResults stream.
  //This is the equivalent of submitting the search term to whatever search service you are using

  @override
  Widget buildSuggestions(BuildContext context) {
    // Todo: implement buildSuggestions

    var list = query.isEmpty
        ? noteList
        : noteList
            .where((p) =>
                p.author.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return list.isEmpty
        ? Card(
            child: ListTile(
              title: Center(
                child: Text("No results found..."),
              ),
            ),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final showList = list[index];
              return ListTile(
                onTap: () {
                  result = showList;
                  query = showList.noteableType;
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     // builder: (context) => IssueDescription(
                  //     //   token: token,
                  //     //   issueId: showList.author.name,
                  //     //   //projectId: result.projectId,
                  //     //   title: showList.author.username,
                  //     //   issueDescription: showList.issueDescription,
                  //     //   issueState: showList.issueState,
                  //     // ),
                  //   ),
                  // );
                  //showResults(context);
                },
                title: Text(
                  showList.author.name,
                  style: new TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: '\n',
                    style: new TextStyle(
                      fontSize: 5.0,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "says: ",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: showList.body + "\n",
                        style: TextStyle(fontSize: 12.5, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                /*
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      showList.issueTitle,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      showList.issueState,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Divider(),
                  ],
                ),
                */
              );
            },
          );
  }
}
*/