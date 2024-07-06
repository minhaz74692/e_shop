import 'package:e_waste/cards/card5.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourOrders extends StatefulWidget {
  const YourOrders({super.key});

  @override
  State<YourOrders> createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  getData() async {
    var ewp = context.read<EWasteProvider>();
    ewp.getOrderList(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var ewp = context.watch<EWasteProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
          style: interStyle18_600,
        ),
        centerTitle: true,
      ),
      body: ewp.orderList.isNotEmpty
          ? ListView.builder(
              itemCount: ewp.orderList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                Product product =
                    Product.fromFirestore(ewp.orderList[index].product);
                return Card5(
                  product: product,
                  order: ewp.orderList[index],
                );
              })
          : Center(child: Text('No orders found')),
    );
  }
}
