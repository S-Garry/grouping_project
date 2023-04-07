import 'package:flutter/material.dart';
import 'dart:math';

import 'package:grouping_project/components/card_view/event_information.dart';

List<Color> randomColor = const [
  /// 顏色固定用色碼
  Color(0xFFFCBF49),
  Color(0xFFFF5252),
  Color(0xFF03A9F4),
  Color(0xFF69F0AE),
  Color(0xFFFFAB40),
  Color(0xFFFF4081),
  Color(0xFF972CB0)
];

// class CardViewTemplate extends StatefulWidget {
//   /// 這個 class 將會創立一個點擊能放大的 card view template，再點擊則能縮小
//   /// 因此要使用這個 widget 必須要給予實現縮小的 widget (也就是 shrink)
//   /// 以及放大的 widget (也就是 enlarge)
//   ///
//   const CardViewTemplate({super.key, required this.detailShrink, required this.detailEnlarge});

//   final StatelessWidget detailShrink;
//   final StatelessWidget detailEnlarge;

//   @override
//   State<CardViewTemplate> createState() => _CardViewTemplateState();
// }

class EventCardViewTemplate extends StatelessWidget {
  EventCardViewTemplate(
      {super.key, required this.detailShrink, required this.detailEnlarge});

  final EventInformationShrink detailShrink;
  final EventInformationEnlarge detailEnlarge;

  /// 隨機選擇使用的顏色
  final Color usingColor = randomColor[Random().nextInt(randomColor.length)];

  @override
  Widget build(BuildContext context) {
    // StatelessWidget detail = detailShrink;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 700),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    pageBuilder: (_, __, ___) => _enlarge(
                        detail: detailEnlarge, usingColor: usingColor)));
          },
          child: Hero(
            tag: 'change${detailShrink.eventModel.id}',
            child: Material(
              type: MaterialType.transparency,
              child: _shrink(
                detail: detailShrink,
                usingColor: usingColor,
                height: 84,
              ),
            ),
          )),
    );
  }
}

class _shrink extends StatelessWidget {
  _shrink(
      {super.key,
      required this.detail,
      required this.usingColor,
      required this.height});

  final EventInformationShrink detail;
  final Color usingColor;

  // height should vary according to detailed of differet card(Upcoming, mission, message)
  final double height;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is shrink');
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 0.5,
                blurRadius: 2,
              )
            ]),
        child: Stack(
          children: [
            // 左方的矩形方塊
            Positioned(
              child: Container(
                width: 8,
                height: height,
                decoration: BoxDecoration(
                    color: usingColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
            ),
            Positioned(
              left: 15,
              top: 3,
              // 放入各個 card view descript
              child: detail,
            )
          ],
        ));
  }
}

class _enlarge extends StatelessWidget {
  _enlarge({super.key, required this.detail, required this.usingColor});

  final EventInformationEnlarge detail;
  final Color usingColor;

  @override
  Widget build(BuildContext context) {
    //debugPrint('it is enlarge');
    return Scaffold(
      body: Hero(
        tag: 'change${detail.eventModel.id}',
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 0.5,
                    blurRadius: 2,
                  )
                ]),
            child: Stack(
              children: [
                // 上方的矩形方塊
                Positioned(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        color: usingColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 18,
                  // 放入各個 card view descript
                  child: detail,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
