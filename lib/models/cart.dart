import 'package:carrinho_de_compra/models/item.dart';

class Cart {
  int? id;
  String? name;
  String? icon;
  int? userId;
  List<Item> items;
  List<int> itemsAmount;

  Cart(
      {this.id,
      this.name,
      this.icon,
      this.userId,
      this.items = const [],
      this.itemsAmount = const []});

  factory Cart.fromSQL(Map<String, dynamic> map) => Cart(
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
      double valor = items[i].price! * itemsAmount[i];
      cartValor = cartValor + valor;
    }
    return cartValor;
  }
}
