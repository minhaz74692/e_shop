import 'package:e_waste/cards/card2.dart';
import 'package:e_waste/config/config.dart';
import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/services/bookmark_service.dart';
import 'package:e_waste/utils/empty_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookMarkTab extends StatefulWidget {
  const BookMarkTab({Key? key}) : super(key: key);

  @override
  State<BookMarkTab> createState() => _BookMarkTabState();
}

class _BookMarkTabState extends State<BookMarkTab>
    with AutomaticKeepAliveClientMixin {
  void _openCLearAllDialog() {
    showModalBottomSheet(
        elevation: 2,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            height: 210,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'clear-bookmark-dialog',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      wordSpacing: 1),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        BookmarkService().clearBookmarkList();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkList = Hive.box(AppConstants.favouriteTag);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => _openCLearAllDialog(),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.only(right: 15, left: 15)),
            child: const Text('Clear-All'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: bookmarkList.listenable(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  if (bookmarkList.isEmpty) {
                    return const EmptyPageWithImage(
                      image: Config.bookmarkImage,
                      title: 'Bookmark is Empty',
                      description: 'Save Your Favourite E-Waste Here',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: bookmarkList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final keys = bookmarkList.keys;
                      final jsonList =
                          keys.map((e) => bookmarkList.get(e)).toList();
                      final List<Product> products =
                          jsonList.map((e) => Product.fromHive(e)).toList();
                      final Product product = products[index];
                      return Card2(product: product);
                      // return Container();
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
