import 'package:carrinho_de_compra/container.dart';
import 'package:carrinho_de_compra/models/cart.dart';
import 'package:carrinho_de_compra/models/user.dart';
import 'package:carrinho_de_compra/pages/cart_page.dart';
import 'package:carrinho_de_compra/repositories/assets_repository.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:carrinho_de_compra/theme.dart';
import 'package:carrinho_de_compra/widgets/user_clip.dart';
import 'package:flutter/material.dart';

class NewCartPage extends StatefulWidget {
  final User user;
  const NewCartPage({super.key, required this.user});

  @override
  State<NewCartPage> createState() => _NewCartPageState();
}

class _NewCartPageState extends State<NewCartPage> {
  late DataRepository dataRepository;
  late AssetsRepository assetsRepository;
  late User user;

  String cartIconSelected = "assets/cart_icons/0.jpg";
  String cartName = "";
  bool inputError = false;

  @override
  void initState() {
    user = widget.user;
    dataRepository = sl();
    assetsRepository = sl();
    super.initState();
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
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 0.7, colors: [CColors.cerelean, CColors.blue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Select you icon and name to you Cart",
                style: TextStyle(
                    color: CColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                _buildSelectUserIcon();
              },
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: UserIconClip(iconpath: cartIconSelected)),
            ),
            TextField(
              textAlign: TextAlign.center,
              cursorColor: CColors.white,
              style: TextStyle(color: CColors.white),
              decoration: InputDecoration(
                  errorText: inputError ? "Name can't be empty" : null,
                  hintText: "Name",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(
                    color: CColors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CColors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CColors.white),
                  )),
              onChanged: (value) => cartName = value,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: TextButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: CColors.blue),
                  onPressed: () {
                    _createNewCart();
                  },
                  icon: Icon(
                    Icons.open_in_new_outlined,
                    color: CColors.white,
                  ),
                  label: Text(
                    "Save New Cart",
                    style: TextStyle(color: CColors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _buildSelectUserIcon() {
    List<String> iconsList = assetsRepository.cartIcons;

    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => StatefulBuilder(
          builder: (context, bottomSheetSetState) => Container(
            height: 250,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select a Cart Icon",
                      style: TextStyle(
                          color: CColors.blue, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(color: CColors.blue))),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            iconsList.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    cartIconSelected = iconsList[index];
                                    bottomSheetSetState(() {});
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: cartIconSelected ==
                                                      iconsList[index]
                                                  ? BoxDecoration(
                                                      boxShadow: const [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.green,
                                                              spreadRadius: 1)
                                                        ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              180))
                                                  : null,
                                              child: UserIconClip(
                                                  iconpath: iconsList[index]),
                                            ),
                                            cartIconSelected == iconsList[index]
                                                ? const Icon(
                                                    Icons.verified,
                                                    color: Colors.green,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Continue",
                        style: TextStyle(color: CColors.blue))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createNewCart() async {
    if (cartName.isEmpty) {
      setState(() {
        inputError = true;
      });
    } else {
      final newCart = await dataRepository.createNewCart(
          Cart(name: cartName, icon: cartIconSelected, userId: user.id));

      goToCartList(newCart);
    }
  }

  goToCartList(Cart newCart) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => CartPage(cart: newCart)));
}
