import 'package:flutter/material.dart';
import 'package:grouping_project/VM/mission_setting_view_model.dart';
import 'package:grouping_project/View/card_enlarge_view.dart';
import 'package:grouping_project/View/mission_setting_view.dart';
import 'package:grouping_project/components/card_view/enlarge_context_template.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/components/card_view/mission_information.dart';
import 'package:grouping_project/VM/mission_card_view_model.dart';


/*
* this file is used to create mission enlarge view
*/

class MissionInformationEnlarge extends StatefulWidget {
  const MissionInformationEnlarge({super.key, required this.missionModel});

  final MissionModel missionModel;

  @override
  State<MissionInformationEnlarge> createState() =>
      _MissionInformationEnlargeState();
}

class _MissionInformationEnlargeState extends State<MissionInformationEnlarge> {
  @override
  Widget build(BuildContext context) {
    MissionCardViewModel missionCardViewModel =
        MissionCardViewModel(widget.missionModel);

    String group = missionCardViewModel.group;
    String title = missionCardViewModel.title;
    String descript = missionCardViewModel.descript;
    DateTime deadline = missionCardViewModel.deadline;
    List<String> contributorIds = missionCardViewModel.contributorIds;
    // MissionStage missionStage = missionCardViewModel.missionStage;
    // String stateName = missionCardViewModel.stateName;
    Color color = missionCardViewModel.color;

    // TODO: use Padding
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                  )),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MissionSettingPageView(
                                  // TODO: do not use widget.missionModel instead use VM.display
                                    model: MissionSettingViewModel.edit(widget.missionModel),)));
                        // setState(() {});
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        // TODO: make notification
                        debugPrint('go to notification page');
                      },
                      icon: const Icon(
                        Icons.notifications,
                        size: 20,
                      )),
                ],
              )
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          // TitleDateOfMission(
          //     title: title,
          //     deadline: deadline,
          //     group: group,
          //     color: color,
          //     stage: missionStage,
          //     stateName: stateName,),
          CardViewTitle(
              title: '參與成員',
              child: Contributors(
                contributorIds: contributorIds,
              )),
          const SizedBox(
            height: 1,
          ),
          CardViewTitle(
              title: '敘述',
              child: Text(
                descript,
                style: const TextStyle(
                  fontSize: 15,
                ),
                softWrap: true,
                maxLines: 5,
              )),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(
            title: '相關任務',
            child: Container(),
            // child: CollabMissons(),
          ),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(title: '相關共筆',
            child: Container(),
          // child: CollabNotes(),
          ),
          const SizedBox(
            height: 2,
          ),
          CardViewTitle(
            title: '相關會議',
            child: Container(),
            // child: CollabMeetings(),
          ),
        ],
      ),
    );
  }
}
