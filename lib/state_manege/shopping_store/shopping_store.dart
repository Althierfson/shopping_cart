import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:wishlist/util/failures.dart';
import 'package:wishlist/util/sort_types.dart';
import 'package:wishlist/util/store_state.dart';
import 'package:wishlist/util/which.dart';
import 'package:mobx/mobx.dart';

part 'shopping_store.g.dart';

class ShoppingStore = _ShoppingStore with _$ShoppingStore;

abstract class _ShoppingStore with Store {
  final Repository repository;

  _ShoppingStore({required this.repository});

  ObservableFuture<Which<Failure, List<Item>>>? _futureItemList;

  @observable
  List<Item> itemList = [];

  @observable
  Wishlist? wishlist;

  @observable
  String snackMsg = "";

  @computed
  StoreState get state => _getStoreState();

  @observable
  int itemState = -1;

  List<String> get sortOptionsKeys => sortOptions.keys.toList();

  Map<String, SortType?> sortOptions = {
    "Standard": null,
    "Expensive": SortType.descending,
    "Cheaper": SortType.ascending
  };

  String query = "";
  String? sortSelected = "Standard";
  int itemAmount = 0;

  StoreState _getStoreState() {
    if (_futureItemList == null ||
        _futureItemList!.status == FutureStatus.rejected) {
      return StoreState.init;
    }

    if (_futureItemList!.status == FutureStatus.pending) {
      return StoreState.loading;
    } else {
      return StoreState.loaded;
    }
  }

  @action
  void getItems() {
    _futureItemList = ObservableFuture(repository.fetchItemsWithQuery(
        contains: query, sort: sortOptions[sortSelected]));
    _futureItemList!.then((value) => value.fold(
        (failure) => snackMsg = failure.toString(),
        (success) => itemList = success));
  }

  /// Update the Wishlist list an save
  @action
  Future<void> addItemOnWishlist(int itemId) async {
    itemState = itemId;
    final value = await repository.addItemOnWishlist(
        idItem: itemId, idWishlist: wishlist!.id ?? -1);

    value.fold((failure) => snackMsg = failure.toString(), (success) {
      wishlist!.items = success;
    });
    itemState = -1;
  }

  Future<void> removeItemOnWishlist(int itemId) async {
    itemState = itemId;
    final value = await repository.deleteItemFromWishlist(
        idItem: itemId, idWishlist: wishlist!.id ?? -1);

    value.fold((failure) => snackMsg = failure.toString(), (success) {
      wishlist!.items = success;
    });
    itemState = -1;
  }

  @action
  bool isInWishlist(int itemId) {
    for (var n in wishlist!.items) {
      if (n.id == itemId) {
        return true;
      }
    }
    return false;
  }

  @action
  void updateWishlist(int idItem, bool onWishlist) {
    if (onWishlist) {
      addItemOnWishlist(idItem);
    } else {
      removeItemOnWishlist(idItem);
    }
  }

  @action
  void goToWishlist() {
    _futureItemList = ObservableFuture(Future.delayed(
        const Duration(milliseconds: 100),
        () => Which.sucesss(wishlist!.items)));
    _futureItemList!.then((value) => value.fold(
        (failure) => snackMsg = failure.toString(),
        (success) => itemList = success));
  }

  @action
  void goToItemList() {
    getItems();
  }
}
