import 'package:wishlist/container.dart';
import 'package:wishlist/models/user.dart';
import 'package:wishlist/models/wishlist.dart';
import 'package:wishlist/pages/wishlist_list_page.dart';
import 'package:wishlist/state_manege/new_wishlist_store/new_wishlist_store.dart';
import 'package:wishlist/theme.dart';
import 'package:wishlist/util/custom_assets.dart';
import 'package:wishlist/widgets/user_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class NewWishlistPage extends StatefulWidget {
  final User user;
  const NewWishlistPage({super.key, required this.user});

  @override
  State<NewWishlistPage> createState() => _NewWishlistPageState();
}

class _NewWishlistPageState extends State<NewWishlistPage> {
  late NewWishlistStore _newWishlistStore;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    getDependecies();
    super.initState();
  }

  getDependecies() async {
    _newWishlistStore = sl();
    _disposers = [
      reaction((_) => _newWishlistStore.inputError, (String? error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error ?? "")));
      }),
      reaction((_) => _newWishlistStore.wishlist, (Wishlist? cart) {
        if (cart != null) backToCartList();
      })
    ];
  }

  @override
  void dispose() {
    // ignore: avoid_function_literals_in_foreach_calls
    _disposers.forEach((r) => r());
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
                  child: UserIconClip(
                      iconpath: _newWishlistStore.wishlistIconSelected)),
            ),
            Observer(
              builder: (_) => TextField(
                controller:
                    TextEditingController(text: _newWishlistStore.wishlistName),
                textAlign: TextAlign.center,
                cursorColor: CColors.white,
                style: TextStyle(color: CColors.white),
                decoration: InputDecoration(
                    errorText: _newWishlistStore.inputError,
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
                onChanged: (value) => _newWishlistStore.wishlistName = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: TextButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: CColors.blue),
                  onPressed: () {
                    _newWishlistStore.createNewWishlist(widget.user.id ?? 0);
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
    List<String> iconsList = CustomAssets.cartIcons;

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
                                    _newWishlistStore.wishlistIconSelected =
                                        iconsList[index];
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
                                              decoration: _newWishlistStore
                                                          .wishlistIconSelected ==
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
                                            _newWishlistStore
                                                        .wishlistIconSelected ==
                                                    iconsList[index]
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

  backToCartList() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => WishlistListPage(user: widget.user)));
}
