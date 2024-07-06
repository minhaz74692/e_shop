import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:hive/hive.dart';
import 'package:e_waste/constants/constants.dart';

class BookmarkService {
  final bookmarkedList = Hive.box(AppConstants.favouriteTag);

  Future handleBookmarkIconPressed(Product product, context) async {
    if (bookmarkedList.keys.contains(product.id)) {
      removeFromBookmarkList(product);
      showMessage('Removed from your bookamrk list');
    } else {
      addToBookmarkList(product);
      showMessage('Added to your favourite list');
    }
  }

  Future getBookmarkList() async {
    return bookmarkedList;
  }

  Future addToBookmarkList(Product product) async {
    Map<String, dynamic> data = {
      'id': product.id,
      'productName': product.productName,
      'description': product.description,
      'image': product.image,
      'price': product.price,
      'sellerName': product.sellerName,
      'category': product.category,
    };
    await bookmarkedList.put(product.id, data);
  }

  Future removeFromBookmarkList(Product product) async {
    await bookmarkedList.delete(product.id);
  }

  Future clearBookmarkList() async {
    await bookmarkedList.clear();
  }
}
