import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

import 'package:flutter_highlight/theme_map.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class Project {
  final String? projectId;
  final String? projectAvatarUrl;
  final String? projectName;
  final String? pathWithNamespace;
  final String? RepositoryDescription;
  final String? projectDefaultBranch;
  final String? projectReadmeUrl;
  final String? projectForksCount;
  int? projectStarCount;
  final String? projectVisibility;
  final String? openIssuesCount;

  Project({
    this.projectId,
    this.projectAvatarUrl,
    this.projectName,
    this.pathWithNamespace,
    this.RepositoryDescription,
    this.projectDefaultBranch,
    this.projectReadmeUrl,
    this.projectForksCount,
    this.projectStarCount,
    this.projectVisibility,
    this.openIssuesCount,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['id'].toString(),
      projectAvatarUrl: json['avatar_url'].toString(),
      projectName: json['name'].toString(),
      pathWithNamespace: json['path_with_namespace'].toString(),
      RepositoryDescription: json['description'].toString(),
      projectDefaultBranch: json['default_branch'].toString(),
      projectReadmeUrl: json['readme_url'].toString(),
      projectForksCount: json['forks_count'].toString(),
      projectStarCount: json['star_count'],
      projectVisibility: json['visibility'].toString(),
      openIssuesCount: json['openIssuesCount'].toString(),
    );
  }
}

class RepositoryDescription extends StatefulWidget {
  RepositoryDescription({
    this.title,
    this.token,
    this.projectId,
    this.projectName,
    this.projectAvatar,
    this.issueId,
    this.readmeUrl,
  });

  final String? title;
  final String? token;
  final String? projectId;
  final String? projectName;
  final String? projectAvatar;
  final String? issueId;
  final String? readmeUrl;

  @override
  _RepositoryDescriptionState createState() => _RepositoryDescriptionState();
}

class _RepositoryDescriptionState extends State<RepositoryDescription> {
  Future<Project>? _futureProject;
  int state = 0;

  String language = "markdown";
  String theme = 'a11y-dark';
  String readmeContent = " ";

  Future<String>? _futureReadmeContent;

  Future<String> fetchReadmeContent(String url) async {
    String raw_url = url.replaceAll("-/blob/", "-/raw/");
    //https://gitlab.com/harry-hov/gitaly/-/blob/master/README.md

    final response = await http.get(Uri.parse(raw_url));

    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      return "No ReadMe file found";
    }
  }

  Future<Project> fetchProject(String projectId) async {
    final response = await http
        .get(Uri.parse('https://gitlab.com/api/v4/projects/$projectId'));
    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load User');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProject = fetchProject(widget.projectId!);
    _futureReadmeContent = fetchReadmeContent(widget.readmeUrl!);
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
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding: const EdgeInsets.all(6),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(.5),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    child: widget.projectAvatar != null
                        ? Center(
                            child: Text(
                              widget.projectName![0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 50.0,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              widget.projectName![0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 50.0,
                              ),
                            ),
                          ),
                  ),
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      widget.projectName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 27.0,
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: Text(
                      "(" + widget.projectId! + ")",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: FutureBuilder<Project>(
                    future: _futureProject,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                  color: Colors.purple[900]!,
                                  width: 2.0,
                                ),
                              ),
                              borderOnForeground: true,
                              color: Colors.black,
                              margin: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  ListTile(
                                    title: Text(
                                      snapshot.data!.RepositoryDescription!
                                              .isNotEmpty
                                          ? snapshot
                                              .data!.RepositoryDescription!
                                          : "No Project Description",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star_border,
                                            size: 20.0,
                                          ),
                                          Text(" Star | " +
                                              "${snapshot.data!.projectStarCount!}"),
                                        ],
                                      ),
                                      color: Colors.black38,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.account_tree_outlined,
                                            size: 20.0,
                                          ),
                                          Text(
                                            " Fork | " +
                                                snapshot
                                                    .data!.projectForksCount!,
                                          ),
                                        ],
                                      ),
                                      color: Colors.black38,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                  color: Colors.purple[900]!,
                                  width: 2.0,
                                ),
                              ),
                              borderOnForeground: true,
                              color: Colors.black,
                              margin: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.info_outline,
                                      color: Colors.grey,
                                    ),
                                    title: const Text(
                                      "Issues",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.grey[400],
                                    ),
                                    onTap: () {
                                      /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectIssue(
                                          token: widget.token,
                                          projectId: widget.projectId,
                                          title: "Issues",
                                        ),
                                      ),
                                    );
                                    */
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                    endIndent: 0.0,
                                    indent: 70.0,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.stacked_bar_chart,
                                      color: Colors.grey,
                                    ),
                                    title: const Text(
                                      "Commits",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.grey[400],
                                    ),
                                    onTap: () {
                                      /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectCommitList(
                                          token: widget.token,
                                          projectId: widget.projectId,
                                          title: "Commits",
                                        ),
                                      ),
                                    );
                                    */
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                    endIndent: 0.0,
                                    indent: 70.0,
                                  ),
                                  ListTile(
                                    leading: const FaIcon(
                                      FontAwesomeIcons.code,
                                      color: Colors.grey,
                                      size: 16.0,
                                    ),
                                    title: const Text(
                                      "Browse Code",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.grey[400],
                                    ),
                                    onTap: () {
                                      /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BrowseFiles(
                                          token: widget.token,
                                          projectId: widget.projectId,
                                          title: "Files",
                                          path: "",
                                        ),
                                      ),
                                    );
                                    */
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                    endIndent: 0.0,
                                    indent: 70.0,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.account_tree_outlined,
                                      color: Colors.grey,
                                      size: 16.0,
                                    ),
                                    title: const Text(
                                      "Pull Requests",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.grey[400],
                                    ),
                                    onTap: () {
                                      /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectMergeRequest(
                                          token: widget.token,
                                          projectId: widget.projectId,
                                          title: "Files",
                                          //path: "",
                                        ),
                                      ),
                                    );
                                    */
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                            /*
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateIssue(
                                    token: widget.token,
                                    title: widget.title,
                                    projectId: widget.projectId,
                                  ),
                                ),
                              );
                            },
                          ),
                          */
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: const Center(
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
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 24.0,
                    ),
                    Text(
                      "README.md",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: FutureBuilder<String>(
                    future: _futureReadmeContent,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 15.0,
                              ),
                              ListTile(
                                title: HighlightView(
                                  snapshot.data!,
                                  language: language,
                                  theme: themeMap[theme]!,
                                  padding: const EdgeInsets.all(12),
                                  textStyle: const TextStyle(
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: const Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
