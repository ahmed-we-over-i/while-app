import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:while_app/logic/history/history_bloc.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/widgets/myDivider.dart';

class CalendarWidget extends StatefulWidget {
  final ColorMode mode;

  const CalendarWidget({Key? key, required this.mode}) : super(key: key);

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

  _pageChange(DateTime dateTime) {
    dateTime = DateTime(dateTime.year, dateTime.month);

    if (dateTime.isAfter(current)) {
      _next();
    } else if (dateTime.isBefore(current)) {
      _previous();
    }
  }

  _previous() {
    if (current.isAfter(DateTime(min.year, min.month))) {
      setState(() {
        current = DateTime(current.year, current.month - 1);
      });
    }
  }

  _next() {
    if (current.isBefore(DateTime(max.year, max.month))) {
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _previous,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Icon(Icons.chevron_left, color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.6) : Colors.white70),
                ),
              ),
            ),
            Text(
              DateFormat('MMMM yyyy').format(current),
              style: TextStyle(color: (widget.mode) == ColorMode.light ? Colors.black87 : Colors.white),
            ),
            GestureDetector(
              onTap: _next,
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Icon(Icons.chevron_right, color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.6) : Colors.white70),
                ),
              ),
            ),
          ],
        ),
        MyDivider(mode: widget.mode),
        Container(
          color: (widget.mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
          padding: EdgeInsets.only(top: 16, bottom: 14, left: 10, right: 10),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return TableCalendar(
                calendarBuilders: CalendarBuilders(),
                firstDay: min,
                lastDay: max,
                focusedDay: current,
                availableCalendarFormats: {CalendarFormat.month: 'month'},
                availableGestures: AvailableGestures.horizontalSwipe,
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat('EE').format(date)[0];
                  },
                  weekdayStyle: TextStyle(
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w500,
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400,
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                  ),
                ),
                headerVisible: false,
                rowHeight: 50,
                daysOfWeekHeight: 45,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white),
                  ),
                  todayTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                  ),
                  defaultTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                  ),
                  weekendTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                  ),
                  selectedTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.white : Colors.black87,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w500,
                  ),
                  outsideDaysVisible: false,
                  markerDecoration: BoxDecoration(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  markerSizeScale: 0.15,
                  markersAnchor: 1,
                  markersMaxCount: 1,
                ),
                selectedDayPredicate: (datetime) => datetime.year == selected.year && datetime.month == selected.month && datetime.day == selected.day,
                onDaySelected: (_, datetime) {
                  onSelectedChanged(DateTime(datetime.year, datetime.month, datetime.day));
                },
                onPageChanged: _pageChange,
                eventLoader: (datetime) {
                  final _datetime = DateTime(datetime.year, datetime.month, datetime.day);

                  if (_datetime != current && state is HistoryLoadedState && state.history.containsKey(_datetime)) {
                    return state.history[_datetime]!.values.toList();
                  }
                  return [];
                },
              );
            },
          ),
        ),
        MyDivider(mode: widget.mode),
      ],
    );
  }
}
