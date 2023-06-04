import 'package:wishlist/models/user.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:wishlist/util/failures.dart';
import 'package:wishlist/util/store_state.dart';
import 'package:wishlist/util/which.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final Repository repository;

  _HomeStore({required this.repository});

  ObservableFuture<Which<Failure, List<User>>>? _futureUserList;

  @observable
  List<User> userList = [];

  @observable
  String? errorMsg;

  @computed
  StoreState get state => _getState();
  
  StoreState _getState() {
    if (_futureUserList == null ||
        _futureUserList!.status == FutureStatus.rejected) {
      return StoreState.init;
    }

    if (_futureUserList!.status == FutureStatus.pending) {
      return StoreState.loading;
    } else {
      return StoreState.loaded;
    }
  }

  @action
  Future<void> getUser() async {
    errorMsg = null;
    _futureUserList = ObservableFuture(repository.getAllUser());
    _futureUserList!.then((value) => value.fold(
        (failure) => errorMsg = failure.toString(),
        (success) => userList = success));
  }
}
