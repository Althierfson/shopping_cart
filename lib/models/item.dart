class Item {
  int? id;
  String? name;
  String? imageUrl;
  double? price;
  int? amount;

  Item({this.id, this.name, this.imageUrl, this.price, this.amount});

  factory Item.fromSQL(Map<String, dynamic> json) => Item(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        price: json['price'],
        amount: json['amount'],
      );

  Map<String, dynamic> toSQL() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'amount': amount,
      };
}
