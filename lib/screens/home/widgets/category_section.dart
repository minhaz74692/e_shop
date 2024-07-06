import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var eWasteProvider = context.watch<EWasteProvider>();
    return SizedBox(
      // alignment: Alignment.center,
      // padding: EdgeInsets.symmetric(horizontal: 20),
      height: 90,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: eWasteProvider.categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            bool isClicked = eWasteProvider.categoryClicked &&
                eWasteProvider.activeCategory == index;
            return InkWell(
              onTap: () async {
                await eWasteProvider.handleCategoryClick(index);

                debugPrint(
                    'Clicked: ${eWasteProvider.categoryClicked}, & Index: ${eWasteProvider.activeCategory}');
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  width: 2,
                  color: isClicked
                      ? const Color.fromARGB(255, 24, 134, 224)
                      : Colors.transparent,
                ))),
                margin: EdgeInsets.only(
                    left: index == 0 ? 20 : 5,
                    right: index == eWasteProvider.categoryList.length - 1
                        ? 20
                        : 5),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: eWasteProvider.categoryList[index].image,
                        ),
                        // child: Image(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage(
                        //     AppConstants.images[index],
                        //   ),
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      eWasteProvider.categoryList[index].name,
                      // style: isClicked
                      //     ? headline1
                      //     : headline3,
                      style: headline3.copyWith(
                          fontSize: 14,
                          fontWeight:
                              isClicked ? FontWeight.w600 : FontWeight.w400,
                          color: isClicked ? Colors.blue[700] : Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
