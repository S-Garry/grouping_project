import 'package:flutter/material.dart';
import 'package:grouping_project/components/card_view/enlarge_viewModel.dart';
import 'package:grouping_project/model/model_lib.dart';

import 'package:intl/intl.dart';

// anti-label pass color data?
// this is for shrink card
class MissionInformationShrink extends StatelessWidget {
  /// 這個 class 實現了 mission 縮小時要展現的資訊
  /// 藉由創建時得到的資料來回傳一個 Container 回去
  /// ps. 需與 cardViewTemplate 一起使用
  const MissionInformationShrink({super.key, required this.missionModel});

  final MissionModel missionModel;

  @override
  Widget build(BuildContext context) {
    String group = missionModel.ownerName;
    String title = missionModel.title ?? 'unknown';
    String descript = missionModel.introduction ?? 'unknown';
    String missionStage =
        stageToString(missionModel.stage ?? MissionStage.progress);
    String stateName = missionModel.stateName ?? 'progress';
    DateTime deadline = missionModel.deadline ?? DateTime(0);

    Color color = Color(missionModel.color);

    DateFormat parseDate = DateFormat('h:mm a, MMM d, yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      // height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntiLabel(
            group: group,
            color: color,
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            descript.split('\n').length > 1
                ? '${descript.split('\n')[0]}...'
                : descript,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('deadline: ${parseDate.format(deadline)}', style: const TextStyle(fontWeight: FontWeight.bold),),
            StateOfMission(
              stage: missionStage,
              stateName: stateName,
            )
          ])
        ],
      ),
    );
  }
}
