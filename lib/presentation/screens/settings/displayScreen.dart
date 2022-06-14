import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/settings/widgets/displayAppearances.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/widgets/customAppBar.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;
          final theme = state.settings.theme;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFFAFAFA) : Color(0xFF2C2C2C),
            appBar: CustomAppBar(mode: mode, text: 'Display'),
            body: Column(
              children: [
                DisplayAppearances(mode: mode, theme: theme),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
