import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/settings/displayScreen.dart';
import 'package:while_app/presentation/misc/enums.dart';
import 'package:while_app/presentation/screens/settings/feedbackScreen.dart';
import 'package:while_app/presentation/screens/settings/timerControlsScreen.dart';
import 'package:while_app/presentation/widgets/myCustomDivider.dart';

class SettingsScreenOptions extends StatelessWidget {
  const SettingsScreenOptions({Key? key}) : super(key: key);

  _buildModePicker(BuildContext context, int orignalValue, ColorMode mode) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: (mode == ColorMode.light) ? Colors.black26 : Colors.black38,
      builder: (BuildContext context) {
        int myValue = orignalValue;

        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          color: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: (mode == ColorMode.light) ? Colors.black.withOpacity(0.6) : Colors.white60),
                      ),
                      style: TextButton.styleFrom(primary: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(SettingsChangeColorModeEvent(value: ColorMode.values[myValue]));
                        Navigator.of(context).pop();
                      },
                      child: Text('Done', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black.withOpacity(0.7) : Colors.white70)),
                      style: TextButton.styleFrom(primary: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: orignalValue),
                  itemExtent: 45,
                  onSelectedItemChanged: (value) {
                    myValue = value;
                  },
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Always light', style: TextStyle(fontSize: 20, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Always dark', style: TextStyle(fontSize: 20, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                    ),
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
          final mode = state.settings.mode;

          return Column(
            children: [
              const SizedBox(height: 45),
              MyCustomDivider(mode: mode),
              ListTile(
                leading: Text("Sound", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                trailing: CupertinoSwitch(
                  value: state.settings.sound,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(SettingsChangeSoundEvent(value: value));
                  },
                  activeColor: (mode == ColorMode.light) ? Colors.grey : Colors.white,
                  trackColor: (mode == ColorMode.light) ? Colors.black12 : Colors.white54,
                  thumbColor: (mode == ColorMode.light) ? Colors.white : Colors.black87,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              MyCustomDivider(mode: mode),
              ListTile(
                leading: Text("Vibration", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                trailing: CupertinoSwitch(
                  value: state.settings.vibration,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(SettingsChangeVibrationEvent(value: value));
                  },
                  activeColor: (mode == ColorMode.light) ? Colors.grey : Colors.white,
                  trackColor: (mode == ColorMode.light) ? Colors.black12 : Colors.white54,
                  thumbColor: (mode == ColorMode.light) ? Colors.white : Colors.black87,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              MyCustomDivider(mode: mode),
              ListTile(
                leading: Text("Light or Dark", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                trailing: Text(
                  (state.settings.mode == ColorMode.light) ? "Always light" : "Always dark",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                onTap: () => _buildModePicker(context, state.settings.mode.index, mode),
              ),
              MyCustomDivider(mode: mode),
              const SizedBox(height: 35),
              MyCustomDivider(mode: mode),
              ListTile(
                title: Text("Color and Graphics", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Choose color themes & graphical shapes", style: TextStyle(fontSize: 13, color: (mode == ColorMode.light) ? Colors.black54 : Colors.white70)),
                ),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                trailing: Icon(Icons.chevron_right, size: 30, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => const DisplayScreen()));
                },
              ),
              MyCustomDivider(mode: mode),
              ListTile(
                title: Text("Intervals and Chimes", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Configure timer durations and controls", style: TextStyle(fontSize: 13, color: (mode == ColorMode.light) ? Colors.black54 : Colors.white70)),
                ),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                trailing: Icon(Icons.chevron_right, size: 30, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => const TimerControlsScreen()));
                },
              ),
              MyCustomDivider(mode: mode),
              const SizedBox(height: 35),
              MyCustomDivider(mode: mode),
              ListTile(
                leading: Text("Feedback", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => FeedbackScreen()));
                },
              ),
              MyCustomDivider(mode: mode),
              ListTile(
                leading: Text("Privacy", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              ),
              MyCustomDivider(mode: mode),
              const SizedBox(height: 45),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
