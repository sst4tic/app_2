import 'package:yiwumart/util/cart_list.dart';

abstract class AbstractBag {
  Future<CartItem> getBagList();
  Future changeQuantity(int id, int quantity);
  Future deleteSelected(Set<int> ids);
}
