import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/colors.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  customTheme.backgroundColor,
                  customTheme.backgroundColor,
                  customTheme.bottomColor,
                  customTheme.bottomColor,
                ],
                stops: [0, 0.5, 0.5, 1],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
