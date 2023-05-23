import 'package:carrinho_de_compra/datasource/database.dart';
import 'package:carrinho_de_compra/models/cart.dart';
import 'package:carrinho_de_compra/models/item.dart';
import 'package:carrinho_de_compra/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sql.dart';

class DataRepository {
  final Db db;

  DataRepository({required this.db});

  Future<int> _createNewRow(String table, Map<String, dynamic> sql) async {
    try {
      final id = await db.instance
          .insert(table, sql, conflictAlgorithm: ConflictAlgorithm.abort);
      return id;
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return -1;
    }
  }

  Future<User> createNewUser(User user) async {
    final id = await _createNewRow('User', user.toSQL());

    return await getUser(id);
  }

  Future<int> createNewItem(Item item) async =>
      _createNewRow('Item', item.toSQL());

  Future<Cart> createNewCart(Cart cart) async {
    final id = await _createNewRow('Cart', cart.toSQL());

    return await getCart(id);
  }

  Future<int> addOnCart(
          {required int idItem,
          required int idCart,
          required int amount}) async =>
      _createNewRow(
          'addOnCart', {'idItem': idItem, 'idCart': idCart, 'amount': amount});

  Future<bool> _updateRow(
      String table, String columnId, Map<String, dynamic> sql) async {
    try {
      await db.instance.update(table, sql,
          where: "$columnId = ?",
          whereArgs: [sql[columnId]],
          conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateUser(User user) async =>
      _updateRow('User', 'userId', user.toSQL());

  Future<bool> updateItem(Item item) async =>
      _updateRow('Item', 'itemId', item.toSQL());

  Future<bool> updateCart(Cart cart, {required userId}) async {
    Map<String, dynamic> value = cart.toSQL();
    value['userId'] = userId;
    return _updateRow('Cart', 'cartId', value);
  }

  Future<bool> updateAddOnCart(
      {required int idItem, required int idCart, required int amount}) async {
    try {
      await db.instance.update('addOnCart', {'amount': amount},
          where: "idItem = ? AND idCart = ?",
          whereArgs: [idItem, idItem],
          conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return false;
    }
  }

  Future<bool> _deleteRow(String table, String id) async {
    try {
      await db.instance.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteUser(User user) async =>
      _deleteRow('User', user.id.toString());

  Future<bool> deleteItem(Item item) async =>
      _deleteRow('Item', item.id.toString());

  Future<bool> deleteCart(Cart cart) async =>
      _deleteRow('Cart', cart.id.toString());

  Future<bool> deleteAddOnCart(
      {required int idItem, required int idCart, required int amount}) async {
    try {
      await db.instance.delete(
        'addOnCart',
        where: "idItem = ? AND idCart = ?",
        whereArgs: [idItem, idCart],
      );
      return true;
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return false;
    }
  }

  Future<List<Map<String, Object?>>> _makeQuery(String query) async {
    try {
      return await db.instance.rawQuery(query);
    } catch (e) {
      debugPrint("APP: Repository ${e.toString()}");
      return [];
    }
  }

  Future<List<User>> getAllUser() async {
    final list = await _makeQuery("SELECT * FROM User");

    return List.from(list.map((e) => User.fromSQL(e)));
  }

  Future<List<Cart>> getAllUserCart(String userId) async {
    final list = await _makeQuery("SELECT * FROM Cart WHERE userId = $userId");

    List<Cart> cartList = [];
    for (var n in list) {
      final cart = await getCartItem(Cart.fromSQL(n));
      cartList.add(cart);
    }

    return cartList;
  }

  Future<Cart> getCartItem(Cart cart) async {
    final listIdItems =
        await _makeQuery("SELECT * FROM AddOnCart WHERE idCart = ${cart.id}");

    List<Map<String, Object?>> itemList = [];
    for (var item in listIdItems) {
      itemList.addAll(
          await _makeQuery("SELECT * FROM Item WHERE id = ${item['idItem']}"));
    }

    cart.items = List.from(itemList.map((e) => Item.fromSQL(e)));
    cart.itemsAmount = List.from(listIdItems.map((e) => e['amount']));

    return cart;
  }

  /// ORDER BY ASC OR DESC
  Future<List<Item>> getAllItems({String? contains, String? sort}) async {
    String query = "SELECT * FROM Item";

    if (contains != null) {
      query = "$query WHERE Name LIKE '%$contains%'";
    }

    if (sort != null) {
      query = "$query ORDER BY Price $sort";
    }

    final list = await _makeQuery(query);

    return List.from(list.map((e) => Item.fromSQL(e)));
  }

  Future<User> getUser(int id) async {
    final list = await _makeQuery("SELECT * FROM User WHERE id = $id");

    return User.fromSQL(list[0]);
  }

  Future<Cart> getCart(int id) async {
    final list = await _makeQuery("SELECT * FROM Cart WHERE id = $id");

    return Cart.fromSQL(list[0]);
  }
}
