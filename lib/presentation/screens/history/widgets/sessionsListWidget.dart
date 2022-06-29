import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:while_app/logic/history/history_bloc.dart';
import 'package:collection/collection.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/widgets/myDivider.dart';

class SessionsListWidget extends StatelessWidget {
  final ColorMode mode;

  SessionsListWidget({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoadedState) {
              final int total = state.sessions.values.toList().sum;
              final int hours = (total / 60).floor();
              final int minutes = total % 60;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyDivider(mode: mode),
                  Container(
                    color: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('EEE, d MMM').format(state.dateTime), style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                        Text('${hours}h ${minutes}m', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60)),
                      ],
                    ),
                  ),
                  MyDivider(mode: mode),
                  if (state.sessions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 25, bottom: 14),
                          child: Text('Sessions', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                        ),
                        MyDivider(mode: mode),
                        ...state.sessions.keys.map((key) {
                          final int wTotal = state.sessions[key] ?? 0;
                          final int wHours = (wTotal / 60).floor();
                          final int wMinutes = wTotal % 60;

                          return Column(
                            children: [
                              Container(
                                color: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('hh : mm').format(key), style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                                    Text('${wHours}h ${wMinutes}m', style: TextStyle(color: (mode == ColorMode.light) ? Colors.black54 : Colors.white60)),
                                  ],
                                ),
                              ),
                              MyDivider(mode: mode),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
