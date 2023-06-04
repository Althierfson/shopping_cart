import 'package:wishlist/container.dart';
import 'package:wishlist/models/user.dart';
import 'package:wishlist/pages/wishlist_list_page.dart';
import 'package:wishlist/pages/new_user_page.dart';
import 'package:wishlist/state_manege/home_store/home_store.dart';
import 'package:wishlist/theme.dart';
import 'package:wishlist/util/icons.dart';
import 'package:wishlist/util/store_state.dart';
import 'package:wishlist/widgets/user_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeStore _homeStore;

  @override
  void initState() {
    getDependecies();
    super.initState();
  }

  void getDependecies() async {
    _homeStore = sl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 0.7, colors: [CColors.cerelean, CColors.blue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: const [
                    BoxShadow(offset: Offset(5, 5), blurRadius: 10)
                  ]),
              child: ClipRRect(
                child: Image.asset(
                  "assets/icon.png",
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                _buildUserSelect();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: CColors.blue,
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(color: CColors.white),
                    boxShadow: const [
                      BoxShadow(offset: Offset(5, 5), blurRadius: 10)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                      color: CColors.white,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Chosse a User",
                      style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: CColors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildUserSelect() async {
    _homeStore.getUser();

    showModalBottomSheet(
      context: context,
      builder: (context) => Observer(builder: (_) {
        switch (_homeStore.state) {
          case StoreState.loading:
            return _buildLoading();
          case StoreState.loaded:
            return _buildBottomSheet(_homeStore.userList);
          case StoreState.init:
            return _buildLoading();
        }
      }),
    );
  }

  Widget _buildBottomSheet(List<User> list) {
    int? userSelectIndex;

    return BottomSheet(
      onClosing: () {},
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select User",
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const NewUserPage()));
                              },
                              child: CIcons.addNewUser),
                        ),
                        for (int i = 0; i < list.length; i++)
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  userSelectIndex = i;
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: userSelectIndex == i
                                            ? BoxDecoration(
                                                boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.green,
                                                        spreadRadius: 1)
                                                  ],
                                                borderRadius:
                                                    BorderRadius.circular(180))
                                            : null,
                                        child: UserIconClip(
                                            iconpath: list[i].icon ?? ""),
                                      ),
                                      userSelectIndex == i
                                          ? const Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                            )
                                          : Container()
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(list[i].name ?? ""),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    )),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => WishlistListPage(
                                  user: list[userSelectIndex ?? 0],
                                )));
                  },
                  child:
                      Text("Continue", style: TextStyle(color: CColors.blue))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
