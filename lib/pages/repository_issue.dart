import 'package:excalibur/pages/issue_description.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Issue {
  //final String issueId;
  final String? iid;
  final String? projectId;
  final String? issueTitle;
  final String? issueDescription;
  final String? issueState;
  final String? projectAvatarUrl;
  final Author? author;
  final String? userNotesCount;
  Issue({
    this.issueDescription,
    this.iid,
    this.issueState,
    this.issueTitle,
    this.projectId,
    this.projectAvatarUrl,
    this.author,
    this.userNotesCount,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      projectId: json['project_id'].toString(),
      iid: json['iid'].toString(),
      author:
          json['author'] != null ? new Author.fromJson(json['author']) : null,
      issueDescription: json['description'].toString(),
      issueState: json['state'].toString(),
      issueTitle: json['title'].toString(),
      projectAvatarUrl: json['author.avatar_url'].toString(),
      userNotesCount: json['user_notes_count'].toString(),
    );
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

class RepositoryIssue extends StatefulWidget {
  final String? projectId;
  final String? title;

  RepositoryIssue({this.projectId, this.title});
  @override
  _RepositoryIssueState createState() => _RepositoryIssueState();
}

class _RepositoryIssueState extends State<RepositoryIssue> {
  //List<Issue> _RepositoryIssueList = new List<Issue>();
  var _RepositoryIssueList = <Issue>[];
  Future<List<Issue>> _fetchRepositoryIssue(String projectId) async {
    final jobsListAPIUrl =
        'https://gitlab.com/api/v4/projects/$projectId/issues';
    final response = await http.get(Uri.parse(jobsListAPIUrl));
    if (response.statusCode == 200) {
      //List<dynamic> values = new List<dynamic>();
      var values = <dynamic>[];
      setState(() {
        values = json.decode(response.body);
      });

      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _RepositoryIssueList.add(Issue.fromJson(map));
          }
        }
      }
      return _RepositoryIssueList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    this._fetchRepositoryIssue(widget.projectId!);
    _RepositoryIssueList.sort();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(
              height: 70.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    Container(
                      child: Text(
                        widget.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
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
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Create new issue!",
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
            createListView(_RepositoryIssueList),
          ],
        ),
      ),
    );
  }

  Widget createListView(var listVariable) {
    return Flexible(
      child: ListView.builder(
        itemCount: listVariable.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: listVariable[index].issueTitle,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " (#" + listVariable[index].iid + ")",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      text: '\n',
                      style: const TextStyle(
                        fontSize: 5.0,
                        color: Colors.grey,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Created by: " +
                              listVariable[index].author.name +
                              " (gitopia18ar...qt)"
                                  "\n",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey[500],
                          ),
                        ),
                        const TextSpan(
                          text: "\n",
                          style: TextStyle(fontSize: 0.0, color: Colors.orange),
                        ),
                        const TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: listVariable[index].issueState.toUpperCase() +
                              "\n",
                          style: const TextStyle(
                              fontSize: 12.5, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(
                    listVariable[index].userNotesCount,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IssueDescription(
                          issueId: _RepositoryIssueList[index].iid,
                          title: _RepositoryIssueList[index].issueTitle,
                          issueDescription:
                              _RepositoryIssueList[index].issueDescription,
                          issueState: _RepositoryIssueList[index].issueState,
                          projectId: _RepositoryIssueList[index].projectId,
                          //issueId: _issueList[index].issueId,
                        ),
                      ),
                    );
                  },
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
