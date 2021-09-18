import 'package:excalibur/pages/create_new_wallet.dart';
import 'package:excalibur/pages/recover_existing_wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Hero(
                tag: "gitopia-logo",
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: AssetImage('assets/logo-g.png'),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                text: const TextSpan(
                  text: 'Access Gitopia',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CreateNewWallet(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Colors.purple[900]!,
                        width: 2.0,
                      ),
                    ),
                    borderOnForeground: true,
                    color: Colors.black,
                    margin: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            const Image(
                              height: 100.0,
                              width: 100.0,
                              image: AssetImage('assets/new-wallet.png'),
                            ),
                            RichText(
                              text: const TextSpan(
                                text: 'Create new wallet',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const RecoverExistingWallet(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Colors.purple[900]!,
                        width: 2.0,
                      ),
                    ),
                    borderOnForeground: true,
                    color: Colors.black,
                    margin: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            const Image(
                              height: 100.0,
                              width: 100.0,
                              image: AssetImage('assets/existing-wallet.png'),
                            ),
                            RichText(
                              text: const TextSpan(
                                text: 'Recover existing wallet',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
