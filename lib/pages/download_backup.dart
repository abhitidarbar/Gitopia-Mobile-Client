import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadBackup extends StatefulWidget {
  const DownloadBackup({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DownloadBackupState createState() => _DownloadBackupState();
}

class _DownloadBackupState extends State<DownloadBackup> {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: const TextSpan(
                  text: 'Recovery Phrase',
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
                  text: 'If you ever lose your account,',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
              RichText(
                text: const TextSpan(
                  text: 'you can use this phrase to recover this account.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              RichText(
                text: const TextSpan(
                  text:
                      '1. tide       2. shoulder    3. tree        4. accident',
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
                  text:
                      '5. good       6. differ      7. across      8. picture',
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
                  text:
                      '9. dinosour     10. sand      11. control     12. industry',
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
                  text:
                      '13. absent       14. pony       15. monkey      16. feed',
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
                  text:
                      '17. thank       18. chuck       19. act      20. vessel',
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
                  text:
                      '21. prepare     22. journey      23. unknown      24. scan',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              OutlinedButton(
                child: const Text(
                  'Download Backup',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(108, 13, 108, 13),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                child: const Text('Done'),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.deepPurple,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(150, 13, 150, 13),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 14,
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
