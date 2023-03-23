import 'package:googleapis/mybusinessbusinessinformation/v1.dart';
import 'package:grouping_project/model/data_controller.dart';
import 'package:grouping_project/model/model_lib.dart';
import 'package:grouping_project/model/user_model.dart';
import 'package:grouping_project/pages/auth/user.dart';
import 'package:grouping_project/pages/home/card_edit_page.dart';
import 'package:grouping_project/pages/home/navigation_bar.dart';
import 'package:grouping_project/service/auth_service.dart';
import 'package:grouping_project/components/message.dart';
import 'package:grouping_project/pages/auth/login.dart';

// progress card
import 'package:grouping_project/components/card_view/progress.dart';
import 'package:grouping_project/pages/home/home_page/over_view.dart';

// show frame of widget
// import 'package:flutter/rendering.dart';

// 測試新功能用，尚未完工，請勿使用或刪除
import 'package:grouping_project/components/card_view/card_view_template.dart';
import 'package:grouping_project/pages/home/home_page/empty.dart';
import 'package:grouping_project/components/card_view/event_information.dart';

import 'package:flutter/material.dart';

class PeronalDashboardPage extends StatefulWidget {
  const PeronalDashboardPage({super.key});
  @override
  State<PeronalDashboardPage> createState() => _TestPageState();
}

class _TestPageState extends State<PeronalDashboardPage> {
  final AuthService _authService = AuthService();
  ProfileModel profile = ProfileModel();
  var funtionSelect = 0;

  // var addNewEventHeight = -300.0;
  @override
  void initState() {
    super.initState();
    DataController()
        .download(dataTypeToGet: ProfileModel(), dataId: ProfileModel().id!)
        .then((value) {
      setState(() {
        profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // show the from of widget
    // debugPaintSizeEnabled = true;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            // TODO: Get User Name from data package
            profile.name ?? "Unknown",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CardEditDone()));
                },
                // 改變成使用者或團體的頭像 !!!!!!!!!!!
                icon: const Icon(Icons.circle)),
            IconButton(
                //temp remove async for quick test
                onPressed: () async {
                  _authService.signOut();
                  _authService.googleSignOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: const Icon(Icons.logout_outlined)),
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 120,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(
                  flex: 2,
                  child: Progress(),
                ),
                // Progress 位置
                SizedBox(
                  height: 3,
                ),
                Expanded(flex: 5, child: OverView()),
                // const SizedBox(
                //   height: 3,
                // ),
                // Expanded(
                //   flex: 5,
                //   child: differentFunctionPage[funtionSelect],
                // )
              ]),
        ),
        // 利用 extendBody: true 以及 BottomAppBar 的 shape, clipBehavior
        // 可以使得 bottom navigation bar 給 FAB 空間
        // ps. https://stackoverflow.com/questions/59455684/how-to-make-bottomnavigationbar-notch-transparent
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // addNewEventHeight = (addNewEventHeight == 0 ? -300 : 0);
            // setState(() {});
            debugPrint('add new event');
          },
          child: const Icon(
            Icons.add,
            color: Color(0xFFFFFFFF),
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // Fix: the navigatorAppBar is wrapped by pannding which can't be find at SG source code, we should fix that problem
        // Notify: I remove the outter Material App Bar and finally padding is gone.
        // Notify: 如果需要在
        bottomNavigationBar: const NavigationAppBar());
  }
}

// // this is test, don't delete it
// EventInformationShrink shrink = EventInformationShrink(
//   group: "personal",
//   title: "test title",
//   descript: "test information",
//   color: Color(0xFFFFc953),
//   contributors: [],
//   startTime: DateTime(0),
//   endTime: DateTime.now(),
// );

// EventInformationEnlarge enlarge = EventInformationEnlarge(
//   group: "personal",
//   title: "test title",
//   descript: "test information",
//   color: Color(0xFFFFc953),
//   contributors: [],
//   eventId: "123456",
//   startTime: DateTime(0),
//   endTime: DateTime.now(),
// );

// List<Widget> differentFunctionPage = [
//   Expanded(
//       child: ListView(
//     // children: const [
//     children: [
//       //GroupPage()

//       CardViewTemplate(detailShrink: shrink, detailEnlarge: enlarge)
//     ],
//   )),
//   Expanded(
//       child: ListView(
//     children: const [
//       // UpcomingExpand(
//       //     group: 'personal',
//       //     title: 'P+ 籃球會',
//       //     descript: '領航員 vs 富邦勇士',
//       //     date1: '9:00 PM, FEB 2, 2023',
//       //     date2: '11:00 PM, FEB 2, 2023'),
//       //UpcomingPage()
//       const Placeholder()
//     ],
//   )),
//   Expanded(
//       child: ListView(
//     // children: const [TrackedPage()],
//     children: [const Placeholder()],
//   )),
//   Expanded(
//       child: ListView(
//     children: [Message(messageNumber: 1)],
//   ))
// ];
