import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:while_app/logic/history/history_bloc.dart';
import 'package:while_app/presentation/misc/enums.dart';
import 'package:while_app/presentation/widgets/myCustomDivider.dart';

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
        MyCustomDivider(mode: widget.mode),
        Container(
          color: (widget.mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
          padding: EdgeInsets.only(top: 16, bottom: 14, left: 10, right: 10),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return TableCalendar(
                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                          fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: (widget.mode == ColorMode.light) ? Colors.white : Colors.black87,
                          fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  holidayBuilder: (context, day, focusedDay) {
                    final _oneAfter = DateTime(day.year, day.month, day.day).add(Duration(days: 1));
                    final _oneBefore = DateTime(day.year, day.month, day.day).subtract(Duration(days: 1));

                    if (state is HistoryLoadedState && (state.history.containsKey(_oneAfter) || state.history.containsKey(_oneBefore))) {
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 4, bottom: 4, right: state.history.containsKey(_oneAfter) ? 0 : 8, left: state.history.containsKey(_oneBefore) ? 0 : 8),
                        padding: EdgeInsets.only(left: state.history.containsKey(_oneAfter) ? 0 : 8, right: state.history.containsKey(_oneBefore) ? 0 : 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(width: 2.5, color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white),
                            top: BorderSide(width: 2.5, color: Colors.transparent),
                          ),
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                            fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                              fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          Positioned(
                            bottom: -12,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
                    fontSize: 14,
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400,
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontSize: 14,
                  ),
                ),
                headerVisible: false,
                rowHeight: 50,
                daysOfWeekHeight: 45,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                  ),
                  weekendTextStyle: TextStyle(
                    color: (widget.mode == ColorMode.light) ? Colors.black87 : Colors.white,
                    fontWeight: (widget.mode == ColorMode.light) ? FontWeight.w400 : FontWeight.w300,
                  ),
                  outsideDaysVisible: false,
                ),
                onDaySelected: (_, datetime) {
                  onSelectedChanged(DateTime(datetime.year, datetime.month, datetime.day));
                },
                onPageChanged: _pageChange,
                selectedDayPredicate: (datetime) => datetime.year == selected.year && datetime.month == selected.month && datetime.day == selected.day,
                holidayPredicate: (datetime) {
                  final _datetime = DateTime(datetime.year, datetime.month, datetime.day);

                  if (_datetime != current && state is HistoryLoadedState && state.history.containsKey(_datetime)) {
                    return true;
                  }

                  return false;
                },
              );
            },
          ),
        ),
        MyCustomDivider(mode: widget.mode),
      ],
    );
  }
}
