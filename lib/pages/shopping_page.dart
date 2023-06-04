import 'package:mobx/mobx.dart';
import 'package:wishlist/container.dart';
import 'package:wishlist/models/item.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/state_manege/shopping_store/shopping_store.dart';
import 'package:wishlist/theme.dart';
import 'package:wishlist/util/store_state.dart';
import 'package:wishlist/widgets/item_tile.dart';
import 'package:wishlist/widgets/user_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ShoppingPage extends StatefulWidget {
  final Wishlist wishlist;
  const ShoppingPage({super.key, required this.wishlist});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late ShoppingStore _shoppingStore;
  late Wishlist wishlist;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    getDependicies();
    makeReaction();
    super.initState();
  }

  void getDependicies() {
    _shoppingStore = sl();
    _shoppingStore.wishlist = widget.wishlist;
    wishlist = widget.wishlist;
    _shoppingStore.getItems();
  }

  void makeReaction() {
    _disposers = [
      reaction((_) => _shoppingStore.snackMsg, (String? error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error ?? "")));
      }),
    ];
  }

  @override
  void dispose() {
    for (var n in _disposers) {
      n();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.blue.withOpacity(0.0),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 0.7, colors: [CColors.cerelean, CColors.blue])),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                          onTap: () {
                            _shoppingStore.goToWishlist();
                          },
                          child: UserIconClip(iconpath: wishlist.icon ?? ""))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      wishlist.name ?? "",
                      style: TextStyle(color: CColors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search),
                          hintText: "Search",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                      onChanged: (value) {
                        setState(() {
                          _shoppingStore.query = value;
                          _shoppingStore.getItems();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextButton.icon(
                        onPressed: () {
                          _showSortOpctions();
                        },
                        label: Icon(
                          Icons.keyboard_arrow_down,
                          color: CColors.white,
                        ),
                        icon: Text(
                          "Sort",
                          style: TextStyle(color: CColors.white),
                        )),
                  )
                ],
              ),
            ),
            Observer(builder: (context) {
              if (_shoppingStore.state == StoreState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (_shoppingStore.state == StoreState.loaded) {
                return _buildItemList(_shoppingStore.itemList);
              }

              return Container();
            })
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(List<Item> items) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Observer(builder: (context) {
            return ItemTile(
              item: items[index],
              onWishlist: _shoppingStore.isInWishlist(items[index].id ?? -1),
              isLoading: _shoppingStore.itemState == items[index].id,
              onAddBottomTap: (value) {
                _shoppingStore.updateWishlist(items[index].id ?? -1, value);
              },
            );
          }),
        ),
      ),
    );
  }

  void _showSortOpctions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, sheetSetState) => BottomSheet(
          onClosing: () {},
          builder: (context) => Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort by",
                      style: TextStyle(color: CColors.blue),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                      children: List.generate(
                    _shoppingStore.sortOptionsKeys.length,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  sheetSetState(
                                    () {
                                      _shoppingStore.sortSelected =
                                          _shoppingStore.sortOptionsKeys[index];
                                    },
                                  );
                                },
                                child: Text(
                                    _shoppingStore.sortOptionsKeys[index]))),
                        Radio(
                            value: _shoppingStore.sortOptionsKeys[index],
                            groupValue: _shoppingStore.sortSelected,
                            onChanged: (value) {
                              sheetSetState(
                                () {
                                  _shoppingStore.sortSelected = value;
                                },
                              );
                            }),
                      ],
                    ),
                  )),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Sort"))
              ],
            ),
          ),
        ),
      ),
    ).then((value) {
      setState(() {
        _shoppingStore.getItems();
      });
    });
  }
}
