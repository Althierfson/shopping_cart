import 'dart:async';

import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/user.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  late Database _db;

  Database get instance => _db;

  Future<void> initDatabase() async {
    _db = await openDatabase(
      "${await getDatabasesPath()}/Wishlist.db",
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(_user);
    await db.execute(_wishlist);
    await db.execute(_item);
    await db.execute(_addOnWishlist);

    for (var n in _addUser) {
      await db.insert("User", n.toSQL(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    }

    for (var n in _addWishlist) {
      await db.insert("Wishlist", n.toSQL(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    }

    for (var n in _addItem) {
      await db.insert("Item", n.toSQL(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    }

    for (var n in _addAddOnWishlist) {
      await db.insert("AddOnWishlist", n,
          conflictAlgorithm: ConflictAlgorithm.abort);
    }
  }

  String get _user => """
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        icon TEXT,
        name TEXT UNIQUE
      );
    """;

  String get _wishlist => """
      CREATE TABLE Wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        icon TEXT,
        userId INTEGER,
        FOREIGN KEY(userId) REFERENCES User(id)
      );
    """;

  String get _item => """
      CREATE TABLE Item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imageUrl TEXT,
        price REAL
      );
    """;

  String get _addOnWishlist => """
      CREATE TABLE AddOnWishlist (
        idItem INTEGER REFERENCES Item(id),
        idWishlist INTEGER REFERENCES Wishlist(id),
        PRIMARY KEY (idItem, idWishlist)
      );
    """;

  List<User> get _addUser => [
        User(icon: 'assets/user_icons/4.jpg', name: 'João'),
        User(icon: 'assets/user_icons/2.jpg', name: 'Maria'),
        User(icon: 'assets/user_icons/24.jpg', name: 'Maki'),
        User(icon: 'assets/user_icons/19.jpg', name: 'Leon'),
        User(icon: 'assets/user_icons/21.jpg', name: 'Ada'),
      ];

  List<Wishlist> get _addWishlist => [
        Wishlist(name: "Games", icon: 'assets/wishlist_icons/1.jpg', userId: 1),
        Wishlist(
            name: "Clothes", icon: 'assets/wishlist_icons/15.jpg', userId: 1),
        Wishlist(name: "Games", icon: 'assets/wishlist_icons/1.jpg', userId: 2),
        Wishlist(
            name: "Clothes", icon: 'assets/wishlist_icons/15.jpg', userId: 3),
        Wishlist(name: "Games", icon: 'assets/wishlist_icons/1.jpg', userId: 4),
      ];

  List<Item> get _addItem => [
        Item(
            name: "Resident Evil 4 Remake",
            imageUrl:
                'https://image.api.playstation.com/vulcan/ap/rnd/202210/0706/EVWyZD63pahuh95eKloFaJuC.png',
            price: 59.99),
        Item(
            name: "Assassin's creed Black Flag",
            imageUrl:
                'https://store.ubisoft.com/dw/image/v2/ABBS_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw7f2b5ed1/images/large/56c4948088a7e300458b46b0.jpg?sw=341&sh=450&sm=fit',
            price: 39.99),
        Item(
            name: "God of War 3",
            imageUrl:
                'https://image.api.playstation.com/vulcan/img/rnd/202011/0711/p8JCvA8692BICXAPoyylh7ed.png',
            price: 9.99),
        Item(
            name: "Black T-Shit",
            imageUrl:
                'https://br.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-inside-out-t-shirt-ready-to-wear--HIY47WJYN900_PM2_Front%20view.jpg',
            price: 25.00),
        Item(
            name: "White T-Shit",
            imageUrl:
                'https://media.gq-magazine.co.uk/photos/62e3b0402385b75b995a47fc/master/w_1920,h_1280,c_limit/10COOL_WT_05.jpg',
            price: 25.00),
        Item(
            name: "Blue T-Shit",
            imageUrl:
                'https://m.media-amazon.com/images/I/51TvX5+KKyL._AC_UX679_.jpg',
            price: 25.00),
        Item(
            name: "Black Pants",
            imageUrl:
                'https://youridstore.com.br/media/catalog/product/cache/1/image/1200x/472321edac810f9b2465a359d8cdc0b5/d/q/dq7509-010-_2_.jpg',
            price: 120.00),
        Item(
            name: "White Pants",
            imageUrl:
                'https://images.express.com/is/image/expressfashion/0092_07452358_0001_f001?cache=on&wid=361&fmt=jpeg&qlt=75,1&resmode=sharp2&op_usm=1,1,5,0&defaultImage=Photo-Coming-Soon',
            price: 120.00),
        Item(
            name: "Blue Pants",
            imageUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMnirFjFkgXdbOZg62uEJXrJy9hul0edHp8w&usqp=CAU',
            price: 120.00),
        Item(
            name: "GeForce GTX 1050",
            imageUrl:
                'https://a-static.mlcdn.com.br/800x560/placa-de-video-gigabyte-geforce-gtx-1050-ti-4gb-gddr5-128-bits/magazineluiza/227765800/4d8ecea0f5cc3461e632841510b56c0d.jpg',
            price: 81.00),
        Item(
            name: "GeForce GTX 1050 TI",
            imageUrl:
                'https://a-static.mlcdn.com.br/800x560/placa-de-video-gigabyte-geforce-gtx-1050-ti-4gb-gddr5-128-bits/magazineluiza/227765800/4d8ecea0f5cc3461e632841510b56c0d.jpg',
            price: 81.00),
        Item(
            name: "Intel Core i5",
            imageUrl:
                'https://m.media-amazon.com/images/I/61SUV95NFiL._AC_SX466_.jpg',
            price: 136.12),
        Item(
            name: "Intel Core i7",
            imageUrl:
                'https://images.kabum.com.br/produtos/fotos/112996/processador-intel-core-i7-10700k-cache-16mb-3-8ghz-lga-1200-bx8070110700k_1589208569_g.jpg',
            price: 300.52),
        Item(
            name: "Black Boot",
            imageUrl:
                'https://media1.popsugar-assets.com/files/thumbor/DeUtGTPRaGh69zTBZlwsMwCG6Sk/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2022/10/04/910/n/1922564/b2ec92a3a15e4764_netimgPeQoZo/i/Heeled-Black-Boots-ASOS-DESIGN-Wide-Fit-Rescue-Mid-Heeled-Sock-Boots.webp',
            price: 99.99),
        Item(
            name: "Black Sneakers",
            imageUrl:
                'https://m.media-amazon.com/images/I/717aKXgCSJL._UY500_.jpg',
            price: 50.00),
        Item(
            name: "White Sneakers",
            imageUrl:
                'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1632340859-202102_ND_1000Fell_white_02_r_3_2048x.jpg?crop=0.817xw:0.817xh;0.103xw,0.159xh&resize=980:*',
            price: 300.00),
        Item(
            name: "Blue Sneakers",
            imageUrl:
                'https://n.nordstrommedia.com/id/sr3/c703257a-f1d3-4098-b2cd-04ec223d8b37.jpeg?h=365&w=240&dpr=2',
            price: 100.00),
      ];

  List<Map<String, Object?>> get _addAddOnWishlist => [
        {'idItem': 1, 'idWishlist': 1},
        {'idItem': 4, 'idWishlist': 2},
        {'idItem': 3, 'idWishlist': 3},
        {'idItem': 9, 'idWishlist': 4},
        {'idItem': 3, 'idWishlist': 5},
      ];
}
