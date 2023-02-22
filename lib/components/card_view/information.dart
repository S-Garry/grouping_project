import 'package:flutter/material.dart';

Map monthDigitToLetter = <int, String>{
  1: "JAN",
  2: "FEB",
  3: "MAR",
  4: "APR",
  5: "MAY",
  6: "JUN",
  7: "JUL",
  8: "AUG",
  9: "SEP",
  10: "OCT",
  11: "NOV",
  12: "DEC"
};

String intFixed(int n, int count) => n.toString().padLeft(count, "0");

// anti-label pass color data?
// this is for shrink card
class Information extends StatelessWidget {
  const Information(
      {super.key,
      required this.group,
      required this.title,
      required this.descript,
      required this.startTime,
      required this.endTime,
      this.state = -1});

  final String group;
  final String title;
  final String descript;
  final DateTime startTime;
  final DateTime endTime;
  // when state = -1, it's mean null, and it's for upcoming
  final int state;

  @override
  Widget build(BuildContext context) {
    String date1 =
      '${intFixed(startTime.hour >= 12 ? startTime.hour - 12 : startTime.hour, 2)}:${intFixed(startTime.minute, 2)} ${startTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[startTime.month]} ${startTime.day}, ${startTime.year}';
    String date2 =
      '${intFixed(endTime.hour >= 12 ? endTime.hour - 12 : endTime.hour, 2)}:${intFixed(endTime.minute, 2)} ${endTime.hour >= 12 ? "PM" : "AM"}, ${monthDigitToLetter[endTime.month]} ${endTime.day}, ${endTime.year}';

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 84,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(group: group),
          const SizedBox(height: 1,),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(date1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                  const Icon(
                    Icons.arrow_right_alt,
                    size: 20,
                    color: Colors.amber,
                  ),
                  Text(date2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
              ],),
              EventState(state: state,)
          ])
        ],
      ),
    );
  }
}

class AntiLabel extends StatelessWidget {
  const AntiLabel({super.key, required this.group});
  final String group;
  final Color usingColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: usingColor, borderRadius: BorderRadius.circular(10)),
      child: 
        Text(' •${group} ', style: const TextStyle(color: Colors.white, fontSize: 10),)
    );
  }
}

class EventState extends StatelessWidget{
  const EventState({super.key, required this.state});
  final int state;

  @override
  Widget build(BuildContext context){
    if(state == -1){
      return const SizedBox.shrink();
    }

    // 帶修改
    Color stateColor = (state == 0
      ? Colors.grey
      : state == 1
          ? Colors.lightBlueAccent
          : Colors.greenAccent);
    String stateName = (state == 0
      ? 'Upcoming 未開始'
      : state == 1
          ? 'In progress 進行中'
          : 'Finish 完成');
    return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: stateColor.withOpacity(0.3)),
    child: Text(' •${stateName} ', style: TextStyle(color: stateColor, fontSize: 10),)
  );
  }
}