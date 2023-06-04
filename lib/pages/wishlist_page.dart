import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:flutter/material.dart';

import '../container.dart';
import '../widgets/item_tile.dart';

class WishlistPage extends StatefulWidget {
  final Wishlist cart;
  const WishlistPage({super.key, required this.cart});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Repository repository;
  Wishlist cart = Wishlist();
  List<Item> items = [];
  bool onCart = false;

  @override
  void initState() {
    repository = sl();
    getCartItem();
    getAllItems();
    super.initState();
  }

  getCartItem() async {
    setState(() {
      cart = Wishlist();
    });
  }

  getAllItems() async {
    final list = await repository.fetchItemsWithQuery();
    setState(() {
      items = list.sucess ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      onCart = !onCart;
                    });
                  },
                  icon: const Icon(Icons.shopping_cart)),
              Text(cart.items.length.toString())
            ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: onCart ? _buildListCartList() : _buildItemsList(),
      ),
    );
  }

  Widget _buildListCartList() {
    if (cart.items.isEmpty) {
      return const Center(
        child: Text("No Items add yet on Cart"),
      );
    }
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ItemTile(
        item: cart.items[index],
        onAddBottomTap: (value) {},
      ),
    );
  }

  Widget _buildItemsList() {
    if (items.isEmpty) {
      return const Center(
        child: Text("No Items add yet on Shopping"),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemTile(
        item: items[index],
        onAddBottomTap: (value) {},
      ),
    );
  }
}
