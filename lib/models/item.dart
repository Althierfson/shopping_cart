class Item {
  int? id;
  String? name;
  String? imageUrl;
  double? price;

  Item({this.id, this.name, this.imageUrl, this.price});

  factory Item.fromSQL(Map<String, dynamic> json) => Item(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price']);

  Map<String, dynamic> toSQL() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
      };
}
