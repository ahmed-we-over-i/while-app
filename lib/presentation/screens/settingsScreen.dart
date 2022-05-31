import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/data/models/settings.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: SizedBox(
            height: 65,
            child: CupertinoNavigationBar(
              leading: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              middle: const Text('Settings'),
              padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        body: const SafeArea(child: SettingsScreenOptions()),
      );
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        middle: const Text('Settings'),
        padding: const EdgeInsetsDirectional.only(bottom: 10, start: 10, end: 10),
        backgroundColor: Colors.white,
      ),
      child: const Material(child: SafeArea(child: SettingsScreenOptions())),
    );
  }
}

class SettingsScreenOptions extends StatelessWidget {
  const SettingsScreenOptions({Key? key}) : super(key: key);

  _buildThemePicker(BuildContext context, int orignalValue) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        int myValue = orignalValue;

        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
                      style: TextButton.styleFrom(primary: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(SettingsChangeColorModeEvent(value: ColorMode.values[myValue]));
                        Navigator.of(context).pop();
                      },
                      child: Text('Done', style: TextStyle(color: Colors.black.withOpacity(0.7))),
                      style: TextButton.styleFrom(primary: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: orignalValue),
                  itemExtent: 45,
                  onSelectedItemChanged: (value) {
                    myValue = value;
                  },
                  children: const [
                    Padding(padding: EdgeInsets.all(10), child: Text('Always light', style: TextStyle(fontSize: 20))),
                    Padding(padding: EdgeInsets.all(10), child: Text('Always dark', style: TextStyle(fontSize: 20))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (_, state) {
        if (state is SettingsLoadedState) {
          return Column(
            children: [
              const SizedBox(height: 50),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              ListTile(
                leading: const Text("Sound", style: TextStyle(fontSize: 16)),
                tileColor: Colors.white,
                trailing: CupertinoSwitch(
                  value: state.settings.sound,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(SettingsChangeSoundEvent(value: value));
                  },
                  activeColor: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              ListTile(
                leading: const Text("Vibration", style: TextStyle(fontSize: 16)),
                tileColor: Colors.white,
                trailing: CupertinoSwitch(
                  value: state.settings.vibration,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(SettingsChangeVibrationEvent(value: value));
                  },
                  activeColor: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              ListTile(
                leading: const Text("Light or Dark", style: TextStyle(fontSize: 16)),
                tileColor: Colors.white,
                trailing: Text(
                  (state.settings.mode == ColorMode.light) ? "Always light" : "Always dark",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                onTap: () => _buildThemePicker(context, state.settings.mode.index),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const SizedBox(height: 30),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const ListTile(
                title: Text("Color and Graphics", style: TextStyle(fontSize: 16)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Choose color themes & graphical shapes"),
                ),
                tileColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                trailing: Icon(Icons.chevron_right, size: 30, color: Colors.grey),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const ListTile(
                title: Text("Intervals and Chimes", style: TextStyle(fontSize: 16)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Configure timer duration and controls"),
                ),
                tileColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                trailing: Icon(Icons.chevron_right, size: 30, color: Colors.grey),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const SizedBox(height: 30),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const ListTile(
                leading: Text("Feedback", style: TextStyle(fontSize: 16)),
                tileColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
              const ListTile(
                leading: Text("Privacy", style: TextStyle(fontSize: 16)),
                tileColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              const Divider(color: Colors.grey, thickness: 0.2, height: 0.2),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
