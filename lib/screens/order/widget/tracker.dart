// ignore_for_file: prefer_const_constructors

import 'package:e_waste/constants/text_style.dart';
import 'package:flutter/material.dart';

class OrderTracker extends StatefulWidget {
  final OrderStatus? status;
  final List<TextDto>? orderTitleAndDateList;
  final List<TextDto>? shippedTitleAndDateList;
  final List<TextDto>? outOfDeliveryTitleAndDateList;
  final List<TextDto>? deliveredTitleAndDateList;
  final Color? activeColor;
  final Color? inActiveColor;
  final TextStyle? headingTitleStyle;
  final TextStyle? headingDateTextStyle;
  final TextStyle? subTitleTextStyle;
  final TextStyle? subDateTextStyle;

  final List<Map<String, dynamic>> dataList;

  const OrderTracker({
    super.key,
    required this.status,
    this.orderTitleAndDateList,
    this.shippedTitleAndDateList,
    this.outOfDeliveryTitleAndDateList,
    this.deliveredTitleAndDateList,
    this.activeColor,
    this.inActiveColor,
    this.headingTitleStyle,
    this.headingDateTextStyle,
    this.subTitleTextStyle,
    this.subDateTextStyle,
    required this.dataList,
  });

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  @override
  void initState() {
    super.initState();
  }

  int defineColor(OrderStatus status) {
    if (status == OrderStatus.address) {
      return 1;
    } else if (status == OrderStatus.ordered) {
      return 2;
    } else if (status == OrderStatus.accepted) {
      return 3;
    } else if (status == OrderStatus.outForDelivery) {
      return 4;
    } else if (status == OrderStatus.arrived) {
      return 5;
    } else if (status == OrderStatus.delivered) {
      return 6;
    }
    return 0;
  }

  double boxH = 330;
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Service TimeLine',
            style: interStyle18_600,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: boxH,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => trackSection(
                        thisIndex: index + 1,
                        data: widget.dataList[index],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: clicked,
                child: Positioned(
                  bottom: 0,
                  child: Container(
                    height: 60,
                    width: 400,
                    color: Colors.white.withOpacity(.7),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                clicked ? 'Show More' : 'Show Less',
                style: interStyle16_600,
              ),
              Icon(
                clicked ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              ),
            ],
          ),
          onTap: () async {
            setState(() {
              boxH = clicked ? 330 : 140;
              clicked = !clicked;
            });
          },
        ),
      ],
    );
  }

  Column trackSection({
    required int thisIndex,
    required Map<String, dynamic> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // defineColor(widget.status!) != thisIndex &&
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: defineColor(widget.status!) >= thisIndex
                        ? widget.activeColor ?? Colors.green
                        : widget.inActiveColor ?? Colors.grey[300],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:
                      thisIndex > 3 && defineColor(widget.status!) >= thisIndex
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : SizedBox.shrink(),
                ),
                thisIndex != 6
                    ? SizedBox(
                        width: 3.3,
                        height: 40,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: LinearProgressIndicator(
                            value: defineColor(widget.status!) > thisIndex
                                ? 1
                                : defineColor(widget.status!) == thisIndex
                                    ? 0.5
                                    : 0,
                            backgroundColor:
                                widget.inActiveColor ?? Colors.grey[300],
                            color: defineColor(widget.status!) >= thisIndex
                                ? widget.activeColor ?? Colors.green
                                : widget.inActiveColor ?? Colors.grey[300],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    data['title'],
                    style: interStyle16_600,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    data['subTitle'] ?? "",
                    style: widget.subTitleTextStyle ??
                        const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class TextDto {
  String? title;
  String? date;

  TextDto(this.title, this.date);
}

enum OrderStatus {
  address,
  ordered,
  accepted,
  outForDelivery,
  arrived,
  delivered,
}
