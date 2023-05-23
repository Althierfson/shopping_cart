import 'package:carrinho_de_compra/models/cart.dart';
import 'package:carrinho_de_compra/models/user.dart';
import 'package:carrinho_de_compra/pages/new_cart_page.dart';
import 'package:carrinho_de_compra/pages/shopping_page.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:carrinho_de_compra/theme.dart';
import 'package:carrinho_de_compra/widgets/user_clip.dart';
import 'package:flutter/material.dart';

import '../container.dart';

class CartListPage extends StatefulWidget {
  final User user;
  const CartListPage({super.key, required this.user});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  late DataRepository repository;
  late User user;
  late Future<List<Cart>> _taskGetCart;

  String newCart = "";

  double amountOfAllCart = 0.0;

  @override
  void initState() {
    user = widget.user;
    repository = sl();
    _taskGetCart = getCarts();
    super.initState();
  }

  Future<List<Cart>> getCarts() {
    return repository.getAllUserCart('${widget.user.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CColors.cerelean,
      appBar: AppBar(
        backgroundColor: CColors.blue.withOpacity(0.0),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              decoration: BoxDecoration(
                color: CColors.blue,
                boxShadow: const [BoxShadow(blurRadius: 2.0)],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: UserIconClip(iconpath: user.icon ?? "")),
                  ),
                  Text(
                    user.name ?? "",
                    style: TextStyle(
                        color: CColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$ ${amountOfAllCart.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: CColors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _taskGetCart = getCarts();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: CColors.white,
                    ),
                    label: Text(
                      "Refresh",
                      style: TextStyle(color: CColors.white),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NewCartPage(user: user)));
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: CColors.white,
                    ),
                    label: Text(
                      "New Cart",
                      style: TextStyle(color: CColors.white),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Cart>>(
              future: _taskGetCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return _buildList(snapshot.data ?? []);
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Cart> data) {
    setAmountOfAllCart(data);

    if (data.isEmpty) {
      return _buildEmptyCart();
    }

    return Column(
        children: List.generate(
            data.length,
            (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ShoppingPage(
                                    cart: data[index],
                                  )));
                    },
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                      decoration: BoxDecoration(
                          color: CColors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [BoxShadow(blurRadius: 10.0)]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(data[index].icon ?? ""),
                          Text(
                            data[index].name ?? "",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  '\$ ${data[index].cartAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  '${data[index].itemsAmount.length} Items',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }

  void setAmountOfAllCart(List<Cart> data) {
    double value = 0.0;
    for (var n in data) {
      value = value + n.cartAmount;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        amountOfAllCart = value;
      });
    });
  }

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
      ),
      child: Column(
        children: [
          Icon(
            Icons.remove_shopping_cart,
            size: 100,
            color: CColors.white,
          ),
          Text(
            "You not create any cart yet",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CColors.white,
                fontSize: 22),
          ),
          Text(
            "Go to add cart botton on then top right of screen",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: CColors.white,
                fontSize: 14),
          ),
          Text("And create a new cart",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CColors.white,
                  fontSize: 14)),
        ],
      ),
    );
  }
}
