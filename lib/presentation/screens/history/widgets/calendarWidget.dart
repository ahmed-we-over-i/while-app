import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:while_app/logic/history/history_bloc.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final DateTime max;
  late final DateTime min;

  late DateTime current;

  late DateTime selected;

  onSelectedChanged(DateTime dateTime) {
    setState(() {
      selected = dateTime;
    });
    context.read<HistoryBloc>().add(HistoryLoadEvent(dateTime: dateTime));
  }

  _previous() {
    if (current.isAfter(min)) {
      setState(() {
        current = DateTime(current.year, current.month - 1);
      });
    }
  }

  _next() {
    if (current.isBefore(max)) {
      setState(() {
        current = DateTime(current.year, current.month + 1);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();

    max = DateTime(now.year, now.month, now.day);
    min = DateTime(now.year - 5, now.month, now.day);
    current = DateTime(now.year, now.month, now.day);

    onSelectedChanged(current);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.08), borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(child: Icon(Icons.chevron_left), onTap: _previous),
            ),
            Text(DateFormat('MMMM yyyy').format(current)),
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.08), borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(child: Icon(Icons.chevron_right), onTap: _next),
            ),
          ],
        ),
        const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 16, bottom: 14, left: 10, right: 10),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return TableCalendar(
                calendarBuilders: CalendarBuilders(),
                firstDay: min,
                lastDay: max,
                focusedDay: current,
                availableCalendarFormats: {CalendarFormat.month: 'month'},
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  headerPadding: EdgeInsets.symmetric(vertical: 4),
                  leftChevronIcon: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.04), borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.chevron_left, color: Colors.black54),
                  ),
                  rightChevronIcon: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.04), borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.chevron_right, color: Colors.black54),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat('EE').format(date)[0];
                  },
                  weekdayStyle: TextStyle(fontWeight: FontWeight.w500),
                  weekendStyle: TextStyle(fontWeight: FontWeight.w500),
                ),
                headerVisible: false,
                rowHeight: 50,
                daysOfWeekHeight: 45,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.black87)),
                  selectedDecoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle, border: Border.all(color: Colors.black87)),
                  todayTextStyle: TextStyle(color: Colors.black87),
                  withinRangeTextStyle: TextStyle(color: Colors.black87),
                  holidayTextStyle: TextStyle(color: Colors.black87),
                  outsideDaysVisible: false,
                  markerDecoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle, border: Border.all(color: Colors.black87)),
                  markerSizeScale: 0.15,
                  markersAnchor: 1,
                  markersMaxCount: 1,
                ),
                selectedDayPredicate: (datetime) => datetime.year == selected.year && datetime.month == selected.month && datetime.day == selected.day,
                onDaySelected: (_, datetime) {
                  onSelectedChanged(DateTime(datetime.year, datetime.month, datetime.day));
                },
                eventLoader: (datetime) {
                  if (state is HistoryLoadedState && state.history.containsKey(DateTime(datetime.year, datetime.month, datetime.day))) {
                    return state.history[DateTime(datetime.year, datetime.month, datetime.day)]!.values.toList();
                  }
                  return [];
                },
              );
            },
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.3, height: 0.3),
      ],
    );
  }
}
