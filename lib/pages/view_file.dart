import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'dart:async';

class ViewCode extends StatefulWidget {
  ViewCode({this.title, this.name, this.projectId, this.id});

  final String? title;
  final String? name;
  final String? projectId;
  final String? id;

  @override
  _ViewCodeState createState() => _ViewCodeState();
}

class _ViewCodeState extends State<ViewCode> {
  String? language;
  String theme = 'atelier-cave-dark';
  String fileContent = " ";

  Future<String>? _futureFileContent;

  Future<String> fetchFileContent(String projectId, String sha) async {
    final response = await http.get(Uri.parse(
        'https://gitlab.com/api/v4/projects/$projectId/repository/blobs/$sha/raw?'));

    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception('Failed to load File Content');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureFileContent = fetchFileContent(widget.projectId!, widget.id!);
    var pos = widget.name!.lastIndexOf('.');
    language = (pos != -1)
        ? widget.name!.substring(pos + 1, widget.name!.length)
        : "null";
  }

  Widget _buildMenuContent(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: <Widget>[
        Text(text, style: const TextStyle(fontSize: 16)),
        const Icon(Icons.arrow_drop_down)
      ]),
    );
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
                  height: 70.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      child: _buildMenuContent(theme),
                      itemBuilder: (context) {
                        return themeMap.keys.map((key) {
                          return CheckedPopupMenuItem(
                            value: key,
                            child: Text(key),
                            checked: theme == key,
                          );
                        }).toList();
                      },
                      onSelected: (selected) {
                        if (selected != null) {
                          setState(() {
                            theme = selected;
                          });
                        }
                      },
                    ),
                  ],
                ),
                /*
              PopupMenuButton<String>(
                child: _buildMenuContent(theme),
                itemBuilder: (context) {
                  return themeMap.keys.map((key) {
                    return CheckedPopupMenuItem(
                      value: key,
                      child: Text(key),
                      checked: theme == key,
                    );
                  }).toList();
                },
                onSelected: (selected) {
                  if (selected != null) {
                    setState(() {
                      theme = selected;
                    });
                  }
                },
              ),
              */
                Container(
                  child: FutureBuilder<String>(
                    future: _futureFileContent,
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
                              const SizedBox(height: 20),
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
                const SizedBox(
                  height: 20.0,
                ),
                /* Logout Button */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
