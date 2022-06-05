import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:while_app/logic/history/history_bloc.dart';
import 'package:collection/collection.dart';

class SessionsListWidget extends StatelessWidget {
  const SessionsListWidget({Key? key}) : super(key: key);

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
                  const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('EEE, d MMM').format(state.dateTime)),
                        Text('${hours}h ${minutes}m', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
                  if (state.sessions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 12),
                          child: Text('Sessions'),
                        ),
                        const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
                        ...state.sessions.keys.map((key) {
                          final int wTotal = state.sessions[key] ?? 0;
                          final int wHours = (wTotal / 60).floor();
                          final int wMinutes = wTotal % 60;

                          return Column(
                            children: [
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('hh : mm').format(key)),
                                    Text('${wHours}h ${wMinutes}m', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
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
