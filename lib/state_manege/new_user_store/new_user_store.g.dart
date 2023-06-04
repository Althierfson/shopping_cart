// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewUserStore on _NewUserStore, Store {
  late final _$inputErrorAtom =
      Atom(name: '_NewUserStore.inputError', context: context);

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

  late final _$userIconSelectedAtom =
      Atom(name: '_NewUserStore.userIconSelected', context: context);

  @override
  String get userIconSelected {
    _$userIconSelectedAtom.reportRead();
    return super.userIconSelected;
  }

  @override
  set userIconSelected(String value) {
    _$userIconSelectedAtom.reportWrite(value, super.userIconSelected, () {
      super.userIconSelected = value;
    });
  }

  late final _$userAtom = Atom(name: '_NewUserStore.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$_NewUserStoreActionController =
      ActionController(name: '_NewUserStore', context: context);

  @override
  void createNewUser() {
    final _$actionInfo = _$_NewUserStoreActionController.startAction(
        name: '_NewUserStore.createNewUser');
    try {
      return super.createNewUser();
    } finally {
      _$_NewUserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
inputError: ${inputError},
userIconSelected: ${userIconSelected},
user: ${user}
    ''';
  }
}
