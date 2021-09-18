import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecoverExistingWallet extends StatefulWidget {
  const RecoverExistingWallet({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RecoverExistingWalletState createState() => _RecoverExistingWalletState();
}

class _RecoverExistingWalletState extends State<RecoverExistingWallet> {
  TextEditingController personalTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: const TextSpan(
                  text: 'Recover Wallet',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                text: const TextSpan(
                  text: 'Enter your wallet recovery phrase to Log In',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: const TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: '24 word recover phrase',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                child: const Text('Recover'),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.deepPurple,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(144, 13, 144, 13),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 16,
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
