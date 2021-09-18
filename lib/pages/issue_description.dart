import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:excalibur/pages/get_notes.dart';

import 'package:http/http.dart' as http;

class Issue {
  final String? issueId;
  final String? projectId;
  final String? issueTitle;
  final String? issueDescription;
  final String? issueState;
  final String? projectAvatarUrl;
  Issue(
      {this.issueDescription,
      this.issueId,
      this.issueState,
      this.issueTitle,
      this.projectId,
      this.projectAvatarUrl});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        projectId: json['project_id'].toString(),
        issueId: json['id'].toString(),
        issueDescription: json['description'].toString(),
        issueState: json['state'].toString(),
        issueTitle: json['title'].toString(),
        projectAvatarUrl: json['author.avatar_url'].toString());
  }
}

Notes notesFromJson(String str) => Notes.fromJson(json.decode(str));

class Notes {
  int? id;
  //Null type;
  String? body;
  //Null attachment;
  Author? author;
  String? createdAt;
  String? updatedAt;
  bool? system;
  int? noteableId;
  String? noteableType;
  bool? resolvable;
  bool? confidential;
  int? noteableIid;
  //CommandsChanges ?commandsChanges;

  Notes({
    this.id,
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
    //this.commandsChanges
  });

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
    //commandsChanges = json['commands_changes'] != null
    //    ? new CommandsChanges.fromJson(json['commands_changes'])
    //    : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    //data['type'] = this.type;
    data['body'] = this.body;
    //data['attachment'] = this.attachment;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['system'] = this.system;
    data['noteable_id'] = this.noteableId;
    data['noteable_type'] = this.noteableType;
    data['resolvable'] = this.resolvable;
    data['confidential'] = this.confidential;
    data['noteable_iid'] = this.noteableIid;
    /*
    if (this.commandsChanges != null) {
      data['commands_changes'] = this.commandsChanges.toJson();
    }
    */
    return data;
  }
}

class Author {
  int? id;
  String? name;
  String? username;
  String? state;
  String? avatarUrl;
  String? webUrl;

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

class IssueDescription extends StatefulWidget {
  final String? token;
  final String? issueId;
  final String? title;
  final String? issueDescription;
  final String? issueState;
  final String? projectId;

  IssueDescription(
      {this.issueId,
      this.token,
      this.title,
      this.issueDescription,
      this.issueState,
      this.projectId});
  @override
  _IssueDescriptionState createState() => _IssueDescriptionState();
}

class _IssueDescriptionState extends State<IssueDescription> {
  get issueDescription => null;

  Future<Issue>? _futureIssue;
  Future<Issue> _fetchUserIssue(String issueId) async {
    final jobsListAPIUrl = 'https://gitlab.com/api/v4/issues?id=$issueId';
    final response = await http.get(Uri.parse(jobsListAPIUrl));
    //print(response.body);
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      return Issue.fromJson(jsonresponse[0]);
    } else {
      throw Exception('Failed to load Issue');
    }
  }

  //List<Notes> _noteList = new List<Notes>();
  var _noteList = <Notes>[];
  Future<List<Notes>> _fetchNotes(String projectId, String issueId) async {
    final jobsListAPIUrl =
        'https://gitlab.com/api/v4/projects/$projectId/issues/$issueId/notes';
    final response = await http.get(Uri.parse(jobsListAPIUrl));
    if (response.statusCode == 200) {
      //List<dynamic> values = new List<dynamic>();
      var values = <dynamic>[];
      setState(() {
        values = json.decode(response.body);
      });

      if (values.isNotEmpty) {
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

  final TextEditingController noteBody = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureIssue = _fetchUserIssue(widget.issueId!);
    this._fetchNotes(widget.projectId!, widget.issueId!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 70.0,
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: widget.title,
                      style: const TextStyle(
                        fontSize: 21.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " (" + widget.issueId! + ")",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.purple[900]!,
                      width: 2.0,
                    ),
                  ),
                  margin: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15.0,
                      ),
                      ListTile(
                        title: Text(
                          widget.issueDescription!.length != 0
                              ? widget.issueDescription!
                              : "No Issue Description",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                /*
            Flexible(
              child: FutureBuilder<Issue>(
                future: _futureIssue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          ListTile(
                            title: Text(
                              snapshot.data.issueDescription.length != 0
                                  ? snapshot.data.issueDescription
                                  : "No Issue Description",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(
                            child: CircularProgressIndicator(),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            */
                Row(
                  children: const [
                    SizedBox(
                      width: 18.0,
                    ),
                    Text(
                      "Comments",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                createListView(_noteList),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: noteBody,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                    hintText: "type your comment here",
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.purple[900]!,
                      width: 2.0,
                    ),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Add new comments",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createListView(List<Notes> listVariable) {
    return Container(
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listVariable.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    Flexible(
                      child: Container(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100.0)),
                          child: listVariable[index].author!.avatarUrl != null
                              ? CachedNetworkImage(
                                  width: 18.0,
                                  height: 18.0,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      listVariable[index].author!.avatarUrl!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.yellow[700]),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Image(
                                    height: 18.0,
                                    width: 18.0,
                                    image: AssetImage('assets/user-avatar.png'),
                                  ),
                                )
                              : const Image(
                                  height: 18.0,
                                  width: 18.0,
                                  image: AssetImage(
                                    'assets/user-avatar.png',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                        child: Text(
                          listVariable[index].author!.name!,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    const Text(
                      "at: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "(" + listVariable[index].createdAt! + ")",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Text(
                      " says :",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    Flexible(
                      child: Text(
                        listVariable[index].body!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
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
