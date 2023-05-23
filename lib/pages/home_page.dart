import 'package:carrinho_de_compra/models/user.dart';
import 'package:carrinho_de_compra/pages/cart_list_page.dart';
import 'package:carrinho_de_compra/pages/new_user_page.dart';
import 'package:carrinho_de_compra/repositories/assets_repository.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:carrinho_de_compra/theme.dart';
import 'package:carrinho_de_compra/util/icons.dart';
import 'package:carrinho_de_compra/widgets/user_clip.dart';
import 'package:flutter/material.dart';

import '../container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DataRepository dataRepository;
  late AssetsRepository assetsRepository;

  String newUser = "";

  Future<List<User>> getUsers() async {
    return dataRepository.getAllUser();
  }

  @override
  void initState() {
    dataRepository = sl();
    assetsRepository = sl();
    super.initState();
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
    final userList = await dataRepository.getAllUser();

    _buildBottomSheet(userList);
  }

  void _buildBottomSheet(List<User> list) {
    int? userSelectIndex;

    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
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
                                color: CColors.blue,
                                fontWeight: FontWeight.bold),
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
                                                builder: (_) =>
                                                    const NewUserPage()));
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                                color: Colors
                                                                    .green,
                                                                spreadRadius: 1)
                                                          ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(180))
                                                    : null,
                                                child: UserIconClip(
                                                    iconpath:
                                                        list[i].icon ?? ""),
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
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
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
                                    builder: (_) => CartListPage(
                                          user: list[userSelectIndex ?? 0],
                                        )));
                          },
                          child: Text("Continue",
                              style: TextStyle(color: CColors.blue))),
                    ],
                  ),
                ),
              )),
    );
  }
}
