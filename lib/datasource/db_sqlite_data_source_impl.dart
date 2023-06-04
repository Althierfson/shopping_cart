import 'package:wishlist/datasource/database.dart';
import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/user.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/util/failures.dart';
import 'package:wishlist/util/sort_types.dart';

class DBSqliteDataSource {
  Db database;

  DBSqliteDataSource({required this.database});

  // create data
  Future<int> _saveData(String table, Map<String, dynamic> data) async {
    try {
      return await database.instance.insert(table, data);
    } catch (e) {
      throw SaveFailure();
    }
  }

  Future<void> createNewWishlist(Wishlist wishlist) async {
    try {
      await _saveData('User', wishlist.toSQL());
    } on Failure {
      rethrow;
    }
  }

  Future<User> createNewUser(User user) async {
    try {
      int id = await _saveData('User', user.toSQL());
      return _getUser(id);
    } on Failure {
      rethrow;
    }
  }

  Future<List<Item>> putItemOnWishlist(
      {required int idItem, required int idWishlist}) async {
    try {
      await _saveData(
          'AddOnWishlist', {'idItem': idItem, 'idWishlist': idWishlist});

      return await _getWishlistItems(idWishlist);
    } on Failure {
      rethrow;
    }
  }

  // updata
  Future<void> _updateData(String table, Map<String, dynamic> data) async {
    try {
      await database.instance
          .update(table, data, where: "id = ?", whereArgs: [data['id']]);
    } catch (e) {
      throw UpdateFailure();
    }
  }

  Future<void> updateWishlist(Wishlist wishlist) async {
    try {
      await _updateData('Wishlist', wishlist.toSQL());
    } on Failure {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _updateData('User', user.toSQL());
    } on Failure {
      rethrow;
    }
  }

  // delete data
  Future<void> _deleteData(String table, int id) async {
    try {
      await database.instance.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      throw DeleteFailure();
    }
  }

  Future<void> deleteWishlist(int id) async {
    try {
      await _deleteData('Wishlist', id);
    } on Failure {
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _deleteData('User', id);
    } on Failure {
      rethrow;
    }
  }

  Future<List<Item>> deleteItemFromWishlist(
      {required int idItem, required int idWishlist}) async {
    try {
      await database.instance.delete("AddOnWishlist",
          where: "idItem = ? AND idWishlist = ?",
          whereArgs: [idItem, idWishlist]);

      return await _getWishlistItems(idWishlist);
    } on Failure {
      throw DeleteFailure();
    }
  }

  // get and searchs
  Future<List<Wishlist>> fetchUserWishlist(int userId) async {
    try {
      final mapList =
          await _makeQuery("SELECT * FROM Wishlist WHERE userId = $userId");

      List<Wishlist> list = [];
      for (int i = 0; i < mapList.length; i++) {
        list.add(Wishlist.fromSQL(mapList[i]));
        list[i].items = await _getWishlistItems(list[i].id ?? -1);
      }
      return list;
    } on Failure {
      rethrow;
    }
  }

  Future<List<User>> fetchUsers() async {
    try {
      final mapList = await _makeQuery("SELECT * FROM User");
      return List.from(mapList.map((e) => User.fromSQL(e)));
    } on Failure {
      rethrow;
    }
  }

  Future<Item> _getItem(int id) async {
    try {
      final mapList = await _makeQuery("SELECT * FROM Item WHERE id = $id");
      return Item.fromSQL(mapList[0]);
    } on Failure {
      rethrow;
    }
  }

  Future<User> _getUser(int id) async {
    try {
      final mapList = await _makeQuery("SELECT * FROM User WHERE id = $id");
      return User.fromSQL(mapList[0]);
    } on Failure {
      rethrow;
    }
  }

  Future<List<Item>> _getWishlistItems(int idWishlist) async {
    try {
      final mapList = await _makeQuery(
          "SELECT * FROM AddOnWishlist WHERE idWishlist = $idWishlist");
      List<Item> itemList = [];
      for (var n in mapList) {
        itemList.add(await _getItem(n['idItem'] as int));
      }

      return itemList;
    } on Failure {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> makeCustomQuery(String table,
      {String? where,
      List? whereArgs,
      String nameTableToSort = "",
      SortType? orderBy}) async {
    try {
      return await database.instance.query(table,
          where: where,
          whereArgs: whereArgs,
          orderBy: "$nameTableToSort ${_getSortType(orderBy)}");
    } catch (e) {
      throw FetchFailure();
    }
  }

  Future<List<Map<String, dynamic>>> _makeQuery(String query) async {
    try {
      return await database.instance.rawQuery(query);
    } catch (e) {
      throw FetchFailure();
    }
  }

  String? _getSortType(SortType? sortType) {
    switch (sortType) {
      case SortType.ascending:
        return "ASC";
      case SortType.descending:
        return "DESC";
      default:
        return null;
    }
  }
}
