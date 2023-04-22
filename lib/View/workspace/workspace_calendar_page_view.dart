import 'package:grouping_project/VM/workspace/calendar_view_model.dart';
import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late List<Widget> eventAndMissionCards = [];

  // CalendarViewModel model = CalendarViewModel();

  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: 'month'
  };
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<DateTime?> popupDatePicker(BuildContext context) {
    DateTime? selectedDate = DateTime.now();
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            // width: 200,
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.single,
              showActionButtons: true,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value;
              },
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (p0) {
                Navigator.pop(context, selectedDate);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> onDaySelected(
      {required DateTime selectedDay,
      required DateTime focusedDay,
      required CalendarViewModel model}) async {
    if ((selectedDay.month != _focusedDay.month) ||
        (selectedDay.year != _focusedDay.year)) {
      await model.getEventsAndMissionsByDate(selectedDay);
      await model.toMapAMonth(year: selectedDay.year, month: selectedDay.month);
    }
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    await showCards(
        eventAndMission: model.eventsMap[DateTime(
                _focusedDay.year, _focusedDay.month, _focusedDay.day)] ??
            []);
    setState(() {});
  }

  /// This is the function used for showing the event and mission cards
  Future<void> showCards({required List eventAndMission}) async {
    eventAndMissionCards = [];
    // debugPrint(eventAndMission.toString());
    for (int index = 0; index < eventAndMission.length; index++) {
      // debugPrint(index.toString());
      eventAndMissionCards.add(Container(
        // padding: const EdgeInsets.only(),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventAndMission[index].title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                eventAndMission[index].introduction,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Text(
                    eventAndMission[index].startTime != null
                        ? DateFormat('yyyy-MM-dd hh:mm')
                            .format(eventAndMission[index].startTime)
                        : DateFormat('yyyy-MM-dd hh:mm')
                            .format(eventAndMission[index].deadline),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_right_alt_rounded),
                  Text(
                    eventAndMission[index].endTime != null
                        ? DateFormat('yyyy-MM-dd hh:mm')
                            .format(eventAndMission[index].endTime)
                        : eventAndMission[index].state,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        )),
      ));
    }
    // debugPrint(
    //     'length of all the cards are: ${eventAndMissionCards.length.toString()}');
    // debugPrint('card content: ${eventAndMissionCards.toString()}');
  }

  /// refresh the page
  Future<void> onRefresh(CalendarViewModel model) async {
    await model.getEventsAndMissionsByDate(_focusedDay);
    await showCards(
        eventAndMission: model.eventsMap[DateTime(
                _focusedDay.year, _focusedDay.month, _focusedDay.day)] ??
            []);
    await model.toMapAMonth(year: _focusedDay.year, month: _focusedDay.month);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   model.initData().whenComplete(
    //     () {
    //       onRefresh();
    //     },
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceDashBoardViewModel>(
      builder: (context, workspaceVM, child) => Consumer<CalendarViewModel>(
        builder: (context, calenderVM, child) {
          return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => onRefresh(calenderVM),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TableCalendar(
                        onCalendarCreated: (pageController) {
                          calenderVM
                              .initData(
                                  eventsList: workspaceVM.events,
                                  missionsList: workspaceVM.missions)
                              .whenComplete(() => onRefresh(calenderVM));
                        },
                        // center Header Title,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        locale: 'zh_TW',
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        availableCalendarFormats: _calendarFormat,
                        daysOfWeekHeight: 20,
                        eventLoader: (day) {
                          // model.getEventsAndMissionsByDate(day);
                          return calenderVM.eventsMap[
                                  DateTime(day.year, day.month, day.day)] ??
                              [];
                        },
                        onHeaderTapped: (focusedDay) async {
                          DateTime? tempDate = await popupDatePicker(context);
                          if (tempDate != null) {
                            _focusedDay = tempDate;
                            _selectedDay = tempDate;
                            onDaySelected(
                                selectedDay: _selectedDay,
                                focusedDay: _focusedDay,
                                model: calenderVM);
                            setState(() {});
                          }
                        },
                        calendarStyle: CalendarStyle(
                          // Decoration for today
                          todayDecoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              width: 2,
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Decoration for weekend
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Decoration for outside days
                          outsideDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Decoration for default day
                          defaultDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Decoration for selected day
                          selectedDecoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          selectedTextStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                          todayTextStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) =>
                            onDaySelected(
                                model: calenderVM,
                                focusedDay: focusedDay,
                                selectedDay: selectedDay),
                        onPageChanged: (focusedDay) async {
                          _focusedDay = focusedDay;
                          await calenderVM.toMapAMonth(
                              year: _focusedDay.year, month: _focusedDay.month);
                        },
                      ),
                    ),
                    Expanded(
                      child: calenderVM.isMapping
                          ? Center(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Event and Mission Lists are still loading',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                      )),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: CircularProgressIndicator())
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: eventAndMissionCards.length,
                              itemBuilder: (context, index) {
                                return eventAndMissionCards[index];
                              },
                            ),
                    ),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       // await DatabaseService(
                    //       //         ownerUid: AuthService().getUid())
                    //       //     .setEvent(
                    //       //         event: EventModel(
                    //       //   title: 'test event title',
                    //       //   startTime: DateTime.now(),
                    //       //   endTime:
                    //       //       DateTime.now().add(const Duration(days: 7)),
                    //       //   introduction: 'test event introduction',
                    //       // ));
                    //       await DatabaseService(
                    //               ownerUid: AuthService().getUid())
                    //           .setMission(
                    //               mission: MissionModel(
                    //                   title: 'test mission title',
                    //                   deadline: DateTime.now()
                    //                       .add(const Duration(days: 7)),
                    //                   state: MissionStateModel
                    //                       .defaultProgressState,
                    //                   introduction:
                    //                       'test mission introduction'));
                    //     },
                    //     child: const Text('Test add'))
                  ],
                ),
              ));
        },
      ),
    );
  }
}