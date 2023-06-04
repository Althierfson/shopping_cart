// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_wishlist_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewWishlistStore on _NewWishlistStore, Store {
  late final _$inputErrorAtom =
      Atom(name: '_NewWishlistStore.inputError', context: context);

  @override
  String? get inputError {
    _$inputErrorAtom.reportRead();
    return super.inputError;
  }

  @override
  set inputError(String? value) {
    _$inputErrorAtom.reportWrite(value, super.inputError, () {
      super.inputError = value;
    });
  }

  late final _$wishlistIconSelectedAtom =
      Atom(name: '_NewWishlistStore.wishlistIconSelected', context: context);

  @override
  String get wishlistIconSelected {
    _$wishlistIconSelectedAtom.reportRead();
    return super.wishlistIconSelected;
  }

  @override
  set wishlistIconSelected(String value) {
    _$wishlistIconSelectedAtom.reportWrite(value, super.wishlistIconSelected,
        () {
      super.wishlistIconSelected = value;
    });
  }

  late final _$wishlistAtom =
      Atom(name: '_NewWishlistStore.wishlist', context: context);

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

  late final _$goBackAtom =
      Atom(name: '_NewWishlistStore.goBack', context: context);

  @override
  bool? get goBack {
    _$goBackAtom.reportRead();
    return super.goBack;
  }

  @override
  set goBack(bool? value) {
    _$goBackAtom.reportWrite(value, super.goBack, () {
      super.goBack = value;
    });
  }

  @override
  String toString() {
    return '''
inputError: ${inputError},
wishlistIconSelected: ${wishlistIconSelected},
wishlist: ${wishlist},
goBack: ${goBack}
    ''';
  }
}
