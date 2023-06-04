import 'package:wishlist/models/item.dart';

class Wishlist {
  int? id;
  String? name;
  String? icon;
  int? userId;
  List<Item> items = [];

  Wishlist({this.id, this.name, this.icon, this.userId, items = const []});

  factory Wishlist.fromSQL(Map<String, dynamic> map) => Wishlist(
      id: map['id'],
      icon: map['icon'],
      name: map['name'],
      userId: map['userId']);

  Map<String, dynamic> toSQL() =>
      {'id': id, 'icon': icon, 'name': name, 'userId': userId};

  double get cartAmount => _getCartAmount();

  double _getCartAmount() {
    double cartValor = 0.0;
    for (int i = 0; i < items.length; i++) {
      cartValor = cartValor + items[i].price!;
    }
    return cartValor;
  }

  void setItemsList(List<Item> newItems) {}
}
