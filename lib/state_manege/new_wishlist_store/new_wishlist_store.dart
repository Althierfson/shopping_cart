import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:wishlist/validate_data/validate_data.dart';
import 'package:mobx/mobx.dart';

part 'new_wishlist_store.g.dart';

class NewWishlistStore = _NewWishlistStore with _$NewWishlistStore;

abstract class _NewWishlistStore with Store {
  final Repository repository;
  final ValidateData validateData;

  _NewWishlistStore({required this.repository, required this.validateData});

  @observable
  String? inputError;

  @observable
  String wishlistIconSelected = "assets/wishlist_icons/0.jpg";

  String wishlistName = "";

  @observable
  Wishlist? wishlist;

  @observable
  bool? goBack;

  void createNewWishlist(int userId) {
    String? error = validateData.validateWishlistName(wishlistName);

    if (error == null) {
      repository
          .createNewWishlist(Wishlist(
              name: wishlistName, icon: wishlistIconSelected, userId: userId))
          .then((value) => value.fold((failure) => inputError.toString(),
              (success) => goBack = success));
    }
  }
}
