// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WishlistListStore on _WishlistListStore, Store {
  Computed<String>? _$amountOfAllCartComputed;

  @override
  String get amountOfAllCart => (_$amountOfAllCartComputed ??= Computed<String>(
          () => super.amountOfAllCart,
          name: '_WishlistListStore.amountOfAllCart'))
      .value;

  late final _$userCartListAtom =
      Atom(name: '_WishlistListStore.userCartList', context: context);

  @override
  List<Wishlist> get userCartList {
    _$userCartListAtom.reportRead();
    return super.userCartList;
  }

  @override
  set userCartList(List<Wishlist> value) {
    _$userCartListAtom.reportWrite(value, super.userCartList, () {
      super.userCartList = value;
    });
  }

  late final _$getUserCartAsyncAction =
      AsyncAction('_WishlistListStore.getUserCart', context: context);

  @override
  Future<void> getUserCart(int userId) {
    return _$getUserCartAsyncAction.run(() => super.getUserCart(userId));
  }

  late final _$initAsyncAction =
      AsyncAction('_WishlistListStore.init', context: context);

  @override
  Future<void> init(int userId) {
    return _$initAsyncAction.run(() => super.init(userId));
  }

  @override
  String toString() {
    return '''
userCartList: ${userCartList},
amountOfAllCart: ${amountOfAllCart}
    ''';
  }
}
