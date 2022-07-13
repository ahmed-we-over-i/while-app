import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/misc/enums.dart';
import 'package:while_app/presentation/misc/extensions.dart';
import 'package:while_app/presentation/widgets/MyCustomDivider.dart';
import 'package:while_app/presentation/widgets/customAppBar.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  final ValueNotifier isFilled = ValueNotifier(false);
  final ValueNotifier switchValue = ValueNotifier(true);

  final TextEditingController _email = TextEditingController();
  final TextEditingController _feedback = TextEditingController();

  void checkChange() {
    if (_email.text.isNotEmpty && _feedback.text.isNotEmpty) {
      isFilled.value = true;
    } else {
      isFilled.value = false;
    }
  }

  void submit(BuildContext context) {
    final email = _email.text;

    if (email.isValidEmail()) {
      Fluttertoast.showToast(msg: "Feedback submitted", toastLength: Toast.LENGTH_SHORT);
      Navigator.of(context).pop();
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text('Please enter correct email address', style: TextStyle(fontSize: 16, height: 1.5)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ok'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFF4F4F4) : Color(0xFF1C1C1C),
            appBar: CustomAppBar(mode: mode, text: 'Feedback'),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CupertinoTextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 0.2, color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60),
                          ),
                          placeholder: 'Your email address',
                          placeholderStyle: TextStyle(color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60),
                          style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white),
                          cursorColor: (mode == ColorMode.light) ? Colors.black38 : Colors.white38,
                          onChanged: (_) => checkChange(),
                        ),
                        SizedBox(height: 30),
                        CupertinoTextField(
                          controller: _feedback,
                          keyboardType: TextInputType.emailAddress,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 0.2, color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60),
                          ),
                          placeholder: 'Share your experience with us. Let us know what went well and what can be improved?',
                          placeholderStyle: TextStyle(color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60, height: 1.6),
                          style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, height: 1.6),
                          cursorColor: (mode == ColorMode.light) ? Colors.black38 : Colors.white38,
                          maxLines: 10,
                          onChanged: (_) => checkChange(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  MyCustomDivider(mode: mode),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Keep me updated', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, fontSize: 20)),
                            ValueListenableBuilder(
                              valueListenable: switchValue,
                              builder: (context, _, __) {
                                return CupertinoSwitch(
                                  value: switchValue.value,
                                  onChanged: (value) {
                                    switchValue.value = value;
                                  },
                                  activeColor: (mode == ColorMode.light) ? Colors.grey : Colors.white,
                                  trackColor: (mode == ColorMode.light) ? Colors.black12 : Colors.white54,
                                  thumbColor: (mode == ColorMode.light) ? Colors.white : Colors.black87,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'We will send a reply to your feedback and include you in future product announcements. You can unsubscribe anytime.',
                          style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white70, height: 1.5),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  MyCustomDivider(mode: mode),
                  SizedBox(height: 40),
                  ValueListenableBuilder(
                    valueListenable: isFilled,
                    builder: (context, _, __) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                          onPressed: isFilled.value ? () => submit(context) : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'SEND FEEDBACK',
                              style: TextStyle(
                                fontSize: 16,
                                color: (mode == ColorMode.light) ? (isFilled.value ? Colors.white : Colors.black26) : (isFilled.value ? Colors.black87 : Colors.white24),
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: (mode == ColorMode.light)
                                ? (isFilled.value ? Colors.black87 : Colors.black.withOpacity(0.07))
                                : (isFilled.value ? Colors.white : Colors.white.withOpacity(0.07)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
