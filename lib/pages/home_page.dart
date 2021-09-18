import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController personalTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Hero(
                          tag: "user-avatar",
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            child: Image(
                              height: 100.0,
                              width: 100.0,
                              image: AssetImage('assets/user-avatar.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Abhiti Darbar',
                              style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              text: 'gitopia18ar4dewyqntslxe...qnzqt',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          RichText(
                            text: const TextSpan(
                              text: '21',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' followers',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: '        8',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: ' following',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: const Text(
                  "Welcome,",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const ListTile(
                contentPadding: EdgeInsets.only(left: 20),
                leading: Text(
                  "My Work",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
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
                      height: 10.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.star,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Starred Repositories",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey[400],
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[300],
                      endIndent: 0.0,
                      indent: 70.0,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.all_inbox_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Your Repositories",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey[400],
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[300],
                      endIndent: 0.0,
                      indent: 70.0,
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
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey[400],
                      ),
                      onTap: () {},
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
                      ),
                      title: const Text(
                        "Pull Requests",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey[400],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.only(
                  left: 20,
                  right: 15,
                  bottom: 0,
                ),
                leading: Text(
                  "Top Repositories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Card(
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
                          "No Top Repositories :)",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
