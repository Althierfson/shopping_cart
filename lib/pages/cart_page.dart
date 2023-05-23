import 'package:carrinho_de_compra/models/cart.dart';
import 'package:carrinho_de_compra/models/item.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:flutter/material.dart';

import '../container.dart';
import '../widgets/item_tile.dart';

class CartPage extends StatefulWidget {
  final Cart cart;
  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late DataRepository repository;
  Cart cart = Cart();
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
    final newcart = await repository.getCartItem(widget.cart);
    setState(() {
      cart = newcart;
    });
  }

  getAllItems() async {
    final list = await repository.getAllItems();
    setState(() {
      items = list;
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
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          repository.deleteAddOnCart(
              idItem: cart.items[index].id!,
              idCart: cart.id!,
              amount: cart.itemsAmount[index]);
        },
        child: ItemTile(
          item: cart.items[index],
        ),
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
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          repository.addOnCart(
              idItem: items[index].id!, idCart: cart.id!, amount: 1);
        },
        child: ItemTile(
          item: items[index],
        ),
      ),
    );
  }
}
