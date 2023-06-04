import 'package:wishlist/models/user.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/pages/new_wishlist_page.dart';
import 'package:wishlist/pages/shopping_page.dart';
import 'package:wishlist/state_manege/wishlist_list_store/wishlist_list_store.dart';
import 'package:wishlist/theme.dart';
import 'package:wishlist/widgets/user_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../container.dart';

class WishlistListPage extends StatefulWidget {
  final User user;
  const WishlistListPage({super.key, required this.user});

  @override
  State<WishlistListPage> createState() => _WishlistListPageState();
}

class _WishlistListPageState extends State<WishlistListPage> {
  late WishlistListStore _cartListStore;
  late User _user;

  @override
  void initState() {
    _user = widget.user;
    _cartListStore = sl();
    _cartListStore.init(_user.id ?? 0);
    super.initState();
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
                        child: UserIconClip(iconpath: _user.icon ?? "")),
                  ),
                  Text(
                    _user.name ?? "",
                    style: TextStyle(
                        color: CColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Observer(builder: (context) {
                    return Text(
                      '\$ ${_cartListStore.amountOfAllCart}',
                      style: TextStyle(
                          color: CColors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    );
                  })
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
                      _cartListStore.getUserCart(_user.id ?? 0);
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
                              builder: (_) => NewWishlistPage(user: _user)));
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
            Observer(
              builder: (context) => _buildList(_cartListStore.userCartList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Wishlist> data) {
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
                                    wishlist: data[index],
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )));
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
