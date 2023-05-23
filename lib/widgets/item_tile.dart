import 'package:carrinho_de_compra/models/item.dart';
import 'package:carrinho_de_compra/theme.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final bool isShow;
  final int itemAmount;
  final Function(int)? onAmountItemChange;
  final Function()? onAddBottomTap;
  const ItemTile(
      {super.key,
      required this.item,
      this.isShow = false,
      this.itemAmount = 0,
      this.onAmountItemChange,
      this.onAddBottomTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: CColors.cerelean.withOpacity(.7),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(item.imageUrl ?? "")),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      item.name ?? "",
                      maxLines: 2,
                      style: TextStyle(
                        color: CColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$ ${item.price!.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: CColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Text(
                        "Items ${item.amount}",
                        style: TextStyle(
                          color: CColors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (isShow)
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: onAddBottomTap,
                          child: const Text("Add on cart")),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (onAmountItemChange != null) {
                                  onAmountItemChange!(-1);
                                }
                              },
                              child: Container(
                                width: 50,
                                color: CColors.white.withOpacity(0.4),
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 50, color: CColors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              color: CColors.white.withOpacity(0.4),
                              child: Center(
                                child: Text(
                                  itemAmount.toString(),
                                  style: TextStyle(
                                      fontSize: 30, color: CColors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (onAmountItemChange != null) {
                                  onAmountItemChange!(1);
                                }
                              },
                              child: Container(
                                width: 50,
                                color: CColors.white.withOpacity(0.4),
                                child: Center(
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        fontSize: 50, color: CColors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
