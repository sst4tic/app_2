import 'package:yiwumart/util/cart_list.dart';

abstract class AbstractBag {
  Future<CartItem> getBagList();
}
