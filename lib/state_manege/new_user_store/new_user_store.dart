import 'package:wishlist/models/user.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:wishlist/validate_data/validate_data.dart';
import 'package:mobx/mobx.dart';

part 'new_user_store.g.dart';

class NewUserStore = _NewUserStore with _$NewUserStore;

abstract class _NewUserStore with Store {
  final Repository repository;
  final ValidateData validateData;

  _NewUserStore({required this.repository, required this.validateData});

  @observable
  String? inputError;

  @observable
  String userIconSelected = "assets/user_icons/1.jpg";

  String userName = "";

  @observable
  User? user;

  @action
  void createNewUser() {
    String? error = validateData.validateUserName(userName);

    if (error == null) {
      repository
          .createNewUser(User(icon: userIconSelected, name: userName))
          .then((value) => value.fold(
              (failure) => inputError.toString(), (success) => user = success));
    }
  }
}
