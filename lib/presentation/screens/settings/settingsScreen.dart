import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/settings/widgets/settingsScreenOption.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/widgets/customAppBar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFF4F4F4) : Color(0xFF1C1C1C),
            appBar: CustomAppBar(mode: mode, text: 'Settings'),
            body: const SafeArea(child: SingleChildScrollView(child: SettingsScreenOptions())),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
