import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/widgets/customAppBar.dart';
import 'package:while_app/presentation/widgets/myDivider.dart';

class TimerControlsScreen extends StatelessWidget {
  const TimerControlsScreen({Key? key}) : super(key: key);

  _buildTimePicker(BuildContext context, int orignalValue, ColorMode mode) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: (mode == ColorMode.light) ? Colors.black26 : Colors.black38,
      builder: (BuildContext context) {
        int myValue = orignalValue;

        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
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
                        context.read<SettingsBloc>().add(SettingsChangeTimerEvent(value: myValue));
                        Navigator.of(context).pop();
                      },
                      child: Text('Done', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black.withOpacity(0.7) : Colors.white70)),
                      style: TextButton.styleFrom(primary: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: orignalValue),
                  itemExtent: 40,
                  onSelectedItemChanged: (value) {
                    myValue = value;
                  },
                  children: [
                    for (int i = 0; i < 60; i++)
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text((i + 1).toString(), style: TextStyle(fontSize: 20, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
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
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFFAFAFA) : Color(0xFF2C2C2C),
            appBar: CustomAppBar(mode: mode, text: 'Timer Controls'),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 45),
                    MyDivider(mode: mode),
                    ListTile(
                      title: Text("Warmup", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Time before your actual session starts", style: TextStyle(fontSize: 13, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                      ),
                      tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                      trailing: CupertinoSwitch(
                        value: state.settings.warmup,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(SettingsChangeWarmupEvent(value: value));
                        },
                        activeColor: (mode == ColorMode.light) ? Colors.grey : Colors.black26,
                        trackColor: (mode == ColorMode.light) ? Colors.black12 : Colors.white10,
                      ),
                    ),
                    MyDivider(mode: mode),
                    if (state.settings.warmup)
                      Column(
                        children: [
                          ListTile(
                            leading: Text("Time", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                            tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                            trailing: Text(
                              state.settings.timer.toString() + ' secs',
                              style: const TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                            onTap: () => _buildTimePicker(context, state.settings.timer, mode),
                          ),
                          MyDivider(mode: mode),
                        ],
                      ),
                    ListTile(
                      leading: Text("Chime", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                      tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                      trailing: Text(
                        'Chime',
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                    ),
                    MyDivider(mode: mode),
                    const SizedBox(height: 35),
                    if (state.settings.warmup)
                      Column(
                        children: [
                          MyDivider(mode: mode),
                          ListTile(
                            leading: Text("End of session chime", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                            tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                            trailing: Text(
                              'Chime',
                              style: const TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                          ),
                          MyDivider(mode: mode),
                        ],
                      ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
