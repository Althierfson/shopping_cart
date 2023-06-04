import 'package:wishlist/datasource/db_sqlite_data_source_impl.dart';
import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/user.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/util/failures.dart';
import 'package:wishlist/util/sort_types.dart';
import 'package:wishlist/util/which.dart';

class Repository {
  final DBSqliteDataSource dataSource;

  Repository({required this.dataSource});

  Future<Which<Failure, User>> createNewUser(User user) async {
    try {
      return Which.sucesss(await dataSource.createNewUser(user));
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, bool>> createNewWishlist(Wishlist wishlist) async {
    try {
      await dataSource.createNewWishlist(wishlist);
      return Which.sucesss(true);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, bool>> updateUser(User user) async {
    try {
      await dataSource.updateUser(user);
      return Which.sucesss(true);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, bool>> updateWishlist(Wishlist wishlist) async {
    try {
      await dataSource.updateWishlist(wishlist);
      return Which.sucesss(true);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, List<Item>>> addItemOnWishlist(
      {required int idItem, required int idWishlist}) async {
    try {
      return Which.sucesss(await dataSource.putItemOnWishlist(
          idItem: idItem, idWishlist: idWishlist));
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, bool>> deleteUser(User user) async {
    try {
      await dataSource.deleteUser(user.id ?? 0);
      return Which.sucesss(true);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, List<Item>>> deleteItemFromWishlist(
      {required int idItem, required int idWishlist}) async {
    try {
      final list = await dataSource.deleteItemFromWishlist(
          idItem: idItem, idWishlist: idWishlist);
      return Which.sucesss(list);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, bool>> deleteWishlist(Wishlist wishlist) async {
    try {
      await dataSource.deleteWishlist(wishlist.id ?? 0);
      return Which.sucesss(true);
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, List<User>>> getAllUser() async {
    try {
      return Which.sucesss(await dataSource.fetchUsers());
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, List<Wishlist>>> getAllUserWishlist(int userId) async {
    try {
      return Which.sucesss(await dataSource.fetchUserWishlist(userId));
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }

  Future<Which<Failure, List<Item>>> fetchItemsWithQuery(
      {String? contains, SortType? sort}) async {
    try {
      final list = await dataSource.makeCustomQuery('Item',
          where: contains == null ? null : "Name LIKE '%$contains%'",
          nameTableToSort: sort != null ? "Price" : "",
          orderBy: sort);

      return Which.sucesss(List.from(list.map((e) => Item.fromSQL(e))));
    } on Failure catch (e) {
      return Which.failure(e);
    }
  }
}
