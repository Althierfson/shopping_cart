import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:mobx/mobx.dart';

part 'wishlist_list_store.g.dart';

class WishlistListStore = _WishlistListStore with _$WishlistListStore;

abstract class _WishlistListStore with Store {
  final Repository repository;

  _WishlistListStore({required this.repository});

  @observable
  List<Wishlist> userCartList = [];

  @computed
  String get amountOfAllCart => _calculeterAllCartValue().toStringAsFixed(2);

  @action
  Future<void> getUserCart(int userId) async {
    repository.getAllUserWishlist(userId).then((value) =>
        value.fold((failure) {}, (success) => userCartList = success));
  }

  @action
  Future<void> init(int userId) async => getUserCart(userId);

  double _calculeterAllCartValue() {
    double value = 0.0;
    for (var n in userCartList) {
      value = value + n.cartAmount;
    }

    return value;
  }
}
