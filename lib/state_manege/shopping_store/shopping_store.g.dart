// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShoppingStore on _ShoppingStore, Store {
  Computed<StoreState>? _$stateComputed;

  @override
  StoreState get state => (_$stateComputed ??=
          Computed<StoreState>(() => super.state, name: '_ShoppingStore.state'))
      .value;

  late final _$itemListAtom =
      Atom(name: '_ShoppingStore.itemList', context: context);

  @override
  List<Item> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(List<Item> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  late final _$wishlistAtom =
      Atom(name: '_ShoppingStore.wishlist', context: context);

  @override
  Wishlist? get wishlist {
    _$wishlistAtom.reportRead();
    return super.wishlist;
  }

  @override
  set wishlist(Wishlist? value) {
    _$wishlistAtom.reportWrite(value, super.wishlist, () {
      super.wishlist = value;
    });
  }

  late final _$snackMsgAtom =
      Atom(name: '_ShoppingStore.snackMsg', context: context);

  @override
  String get snackMsg {
    _$snackMsgAtom.reportRead();
    return super.snackMsg;
  }

  @override
  set snackMsg(String value) {
    _$snackMsgAtom.reportWrite(value, super.snackMsg, () {
      super.snackMsg = value;
    });
  }

  late final _$itemStateAtom =
      Atom(name: '_ShoppingStore.itemState', context: context);

  @override
  int get itemState {
    _$itemStateAtom.reportRead();
    return super.itemState;
  }

  @override
  set itemState(int value) {
    _$itemStateAtom.reportWrite(value, super.itemState, () {
      super.itemState = value;
    });
  }

  late final _$addItemOnWishlistAsyncAction =
      AsyncAction('_ShoppingStore.addItemOnWishlist', context: context);

  @override
  Future<void> addItemOnWishlist(int itemId) {
    return _$addItemOnWishlistAsyncAction
        .run(() => super.addItemOnWishlist(itemId));
  }

  late final _$_ShoppingStoreActionController =
      ActionController(name: '_ShoppingStore', context: context);

  @override
  void getItems() {
    final _$actionInfo = _$_ShoppingStoreActionController.startAction(
        name: '_ShoppingStore.getItems');
    try {
      return super.getItems();
    } finally {
      _$_ShoppingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isInWishlist(int itemId) {
    final _$actionInfo = _$_ShoppingStoreActionController.startAction(
        name: '_ShoppingStore.isInWishlist');
    try {
      return super.isInWishlist(itemId);
    } finally {
      _$_ShoppingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateWishlist(int idItem, bool onWishlist) {
    final _$actionInfo = _$_ShoppingStoreActionController.startAction(
        name: '_ShoppingStore.updateWishlist');
    try {
      return super.updateWishlist(idItem, onWishlist);
    } finally {
      _$_ShoppingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToWishlist() {
    final _$actionInfo = _$_ShoppingStoreActionController.startAction(
        name: '_ShoppingStore.goToWishlist');
    try {
      return super.goToWishlist();
    } finally {
      _$_ShoppingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemList: ${itemList},
wishlist: ${wishlist},
snackMsg: ${snackMsg},
itemState: ${itemState},
state: ${state}
    ''';
  }
}
