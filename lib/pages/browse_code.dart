import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:excalibur/pages/view_file.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

List<RepositoryFile> repositoryFileFromJson(String str) =>
    List<RepositoryFile>.from(
        json.decode(str).map((x) => RepositoryFile.fromJson(x)));

String repositoryFileToJson(List<RepositoryFile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RepositoryFile {
  RepositoryFile({
    this.id,
    this.name,
    this.type,
    this.path,
    this.mode,
  });

  String? id;
  String? name;
  Type? type;
  String? path;
  String? mode;

  factory RepositoryFile.fromJson(Map<String, dynamic> json) => RepositoryFile(
        id: json["id"],
        name: json["name"],
        type: typeValues.map[json["type"]],
        path: json["path"],
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": typeValues.reverse[type],
        "path": path,
        "mode": mode,
      };
}

enum Type { TREE, BLOB }

final typeValues = EnumValues({"blob": Type.BLOB, "tree": Type.TREE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}

class BrowseFiles extends StatefulWidget {
  BrowseFiles({this.title, this.projectId, this.path});

  final String? title;
  final String? projectId;
  final String? path;

  @override
  _BrowseFilesState createState() => _BrowseFilesState();
}

class _BrowseFilesState extends State<BrowseFiles> {
  //List<RepositoryFile> _fileList = new List<RepositoryFile>();
  var _fileList = <RepositoryFile>[];
  Future<List<RepositoryFile>>? _futureFiles;

  Future<List<RepositoryFile>> fetchFiles(String projectId, String path) async {
    final response = await http.get(Uri.parse(
        'https://gitlab.com/api/v4/projects/$projectId/repository/tree/?path=$path'));

    if (response.statusCode == 200) {
      //List<dynamic> values = new List<dynamic>();
      var values = <dynamic>[];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _fileList.add(RepositoryFile.fromJson(map));
          }
        }
      }
      return _fileList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureFiles = fetchFiles(widget.projectId!, widget.path!);
  }

  @override
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
            FutureBuilder<List<RepositoryFile>>(
              future: _futureFiles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Expanded(
                      child: Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, int index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        snapshot.data![index].type == Type.BLOB
                                            ? const FaIcon(
                                                FontAwesomeIcons.file,
                                                color: Colors.blueGrey,
                                              )
                                            : const FaIcon(
                                                FontAwesomeIcons.folder,
                                                color: Colors.blue,
                                              ),
                                    title: Text(
                                      snapshot.data![index].name!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing:
                                        snapshot.data![index].type != Type.BLOB
                                            ? Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.grey[400],
                                              )
                                            : const Text(""),
                                    onTap: () {
                                      if (snapshot.data![index].type !=
                                          Type.BLOB) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BrowseFiles(
                                              title: "> " +
                                                  snapshot.data![index].name!,
                                              projectId: widget.projectId,
                                              path: snapshot.data![index].path,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewCode(
                                              title: "> " +
                                                  snapshot.data![index].name!,
                                              name: snapshot.data![index].name!,
                                              projectId: widget.projectId!,
                                              id: snapshot.data![index].id!,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey[300],
                                    endIndent: 0.0,
                                    indent: 0.0,
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
                                "No Projects Found.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14.0,
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
