import 'package:excalibur/pages/repository_description.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:async';

class Project {
  final String? projectId;
  final String? projectAvatarUrl;
  final String? projectName;
  final String? pathWithNamespace;
  final String? readmeUrl;

  Project(
      {this.projectId,
      this.projectAvatarUrl,
      this.projectName,
      this.pathWithNamespace,
      this.readmeUrl});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['id'].toString(),
      projectAvatarUrl: json['avatar_url'].toString(),
      projectName: json['name'].toString(),
      pathWithNamespace: json['path_with_namespace'].toString(),
      readmeUrl: json['readme_url'].toString(),
    );
  }
}

class UserRepositoryList extends StatefulWidget {
  UserRepositoryList({this.title});

  final String? title;

  @override
  _UserRepositoryListState createState() => _UserRepositoryListState();
}

class _UserRepositoryListState extends State<UserRepositoryList> {
  //List<Project> _projectList = List<Project>();
  var _projectList = <Project>[];
  Future<List<Project>>? _futureProject;

  Future<List<Project>> fetchProjects() async {
    //final response = await http.get(
    //    'https://gitlab.com/api/v4/users/abhitidarbar/projects?simple=true');

    final response = await http.get(Uri.parse(
        'https://gitlab.com/api/v4/users/abhitidarbar/projects?simple=true'));

    if (response.statusCode == 200) {
      var values = List<dynamic>.empty();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _projectList.add(Project.fromJson(map));
          }
        }
      }
      return _projectList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProject = fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        /*
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        extendBodyBehindAppBar: true,
        */
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(
              height: 80.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 35.0,
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
            FutureBuilder<List<Project>>(
              future: _futureProject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0 &&
                      widget.title != "Starred Repositories") {
                    return Expanded(
                      child: Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, int index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Hero(
                                      tag: snapshot.data![index].projectId!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0),
                                          ),
                                          child: snapshot.data![index]
                                                      .projectAvatarUrl !=
                                                  null
                                              ? CachedNetworkImage(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot
                                                      .data![index]
                                                      .projectAvatarUrl!,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .projectName![0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .projectName![0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    snapshot.data![index]
                                                        .projectName![0]
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 30.0,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data![index].projectName!,
                                      style: const TextStyle(
                                        color: Colors.white,
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
                                          const TextSpan(
                                            text: "Repository ID: ",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot
                                                    .data![index].projectId! +
                                                "\n",
                                            style: const TextStyle(
                                                fontSize: 12.5,
                                                color: Colors.orange),
                                          ),
                                          const TextSpan(
                                            text: "\n",
                                            style: TextStyle(
                                                fontSize: 0.0,
                                                color: Colors.orange),
                                          ),
                                          TextSpan(
                                            text: snapshot
                                                .data![index].pathWithNamespace,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.grey[400],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RepositoryDescription(
                                            projectId:
                                                snapshot.data![index].projectId,
                                            projectName: snapshot
                                                .data![index].projectName,
                                            projectAvatar: snapshot
                                                .data![index].projectAvatarUrl,
                                            readmeUrl:
                                                snapshot.data![index].readmeUrl,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                    endIndent: 0.0,
                                    indent: 80.0,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
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
                              child: Text(
                                "No Repositories Found.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.all(15.0),
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
          ],
        ),
      ),
    );
  }
}
