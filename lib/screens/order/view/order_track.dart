// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/constants/app_colors.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/order_model.dart';
import 'package:e_waste/screens/order/widget/map_section.dart';
import 'package:e_waste/screens/order/widget/tracker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OrderTrackerScreen extends StatelessWidget {
  const OrderTrackerScreen({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Track Your Order',
          style: interStyle18_600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MapSection(
              latitude: order.latitude.toString(),
              longitude: order.longitude.toString(),
            ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: order.product['image'],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 170,
                        child: Text(
                          order.product['productName'] ?? '',
                          style: interStyle16_600,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          order.timeStamp.toDate(),
                        ),
                        // widget.orderInfo.scheduleDate != null
                        //     ? AppServices.getFullDateTime(
                        //         widget.orderInfo.scheduleDate!,
                        //       )
                        //     : '',
                        style: interStyle14_600.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF767676,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: 'Need to configure messaging system',
                      );
                    },
                    icon: Icon(Icons.message),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: AppColors.borderColor,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OrderTracker(
                status: OrderStatus.ordered,
                activeColor: AppColors.primaryColor,
                dataList: [
                  {'title': 'Address', 'subTitle': '${order.address}'},
                  {
                    'title': 'Order Placed',
                    'subTitle': DateFormat('dd MMM yyyy, hh:mm a').format(
                      order.timeStamp.toDate(),
                    )
                    // AppServices.getFullDateTime(widget.order.orderDate!)
                  },
                  {
                    'title': 'Accepted the Order',
                    'subTitle': order.status == "pending"
                        ? "Not accepted yet"
                        : order.status == "confirmed"
                            ? "Accepted"
                            : ''
                  },
                  {'title': 'Out for Delivery', 'subTitle': ''},
                  {'title': 'Arrived at Location', 'subTitle': ''},
                  {'title': 'Delivered', 'subTitle': ''},
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
