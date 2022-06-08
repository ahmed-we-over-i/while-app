import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/settings/widgets/settingsScreenOption.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SizedBox(
          height: 55,
          child: CupertinoNavigationBar(
            leading: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            middle: const Text('Settings'),
            padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: const SafeArea(child: SingleChildScrollView(child: SettingsScreenOptions())),
    );
  }
}
