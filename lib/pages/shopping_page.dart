import 'package:carrinho_de_compra/container.dart';
import 'package:carrinho_de_compra/models/cart.dart';
import 'package:carrinho_de_compra/models/item.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:carrinho_de_compra/theme.dart';
import 'package:carrinho_de_compra/widgets/item_tile.dart';
import 'package:carrinho_de_compra/widgets/user_clip.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  final Cart cart;
  const ShoppingPage({super.key, required this.cart});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  late DataRepository dataRepository;
  late Future<List<Item>> _taskGetItems;
  late Cart cart;

  String _query = "";
  int? _sortSelected = 0;

  List<String> options = ["Standard", "Expensive", "Cheaper"];
  Map<int, String> sortToString = {1: 'DESC', 2: 'ASC'};
  Map<int, int> amountCached = {};
  int itemSelected = -1;

  @override
  void initState() {
    cart = widget.cart;
    dataRepository = sl();
    getItems();
    super.initState();
  }

  getItems() {
    amountCached = {};
    itemSelected = -1;
    _taskGetItems = dataRepository.getAllItems(
        contains: _query, sort: sortToString[_sortSelected]);
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
                      child: UserIconClip(iconpath: cart.icon ?? "")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cart.name ?? "",
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
                          _query = value;
                          getItems();
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
            FutureBuilder(
                future: _taskGetItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildItemList(snapshot.data ?? []);
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
          child: GestureDetector(
              onTap: () {
                setState(() {
                  itemSelected = index;
                });
              },
              child: Column(
                children: [
                  ItemTile(
                    item: items[index],
                    isShow: itemSelected == index,
                    itemAmount: amountCached[index] ?? 0,
                    onAmountItemChange: (value) {
                      changeamountCached(index, value);
                    },
                    onAddBottomTap: () {
                      addOnCart(items, index);
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void addOnCart(List<Item> items, int index) {
    if (amountCached[index] == null || amountCached[index] == 0) return;

    dataRepository.addOnCart(
        idItem: items[index].id ?? 0,
        idCart: cart.id ?? 0,
        amount: amountCached[index]!);

    amountCached[index] = 0;
    itemSelected = -1;
    setState(() {});
  }

  void changeamountCached(int index, int value) {
    if (amountCached[index] != null) {
      amountCached[index] = amountCached[index]! + value;
    } else {
      amountCached[index] = value;
    }

    if (amountCached[index]! < 0) amountCached[index] = 0;
    setState(() {});
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
                    options.length,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  sheetSetState(
                                    () {
                                      _sortSelected = index;
                                    },
                                  );
                                },
                                child: Text(options[index]))),
                        Radio(
                            value: index,
                            groupValue: _sortSelected,
                            onChanged: (value) {
                              sheetSetState(
                                () {
                                  _sortSelected = value;
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
        getItems();
      });
    });
  }
}
