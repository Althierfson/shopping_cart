import 'package:wishlist/models/item.dart';
import 'package:wishlist/theme.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final Function(bool) onAddBottomTap;
  final bool onWishlist;
  final bool isLoading;
  const ItemTile(
      {super.key,
      required this.item,
      required this.onAddBottomTap,
      this.onWishlist = false,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: CColors.cerelean.withOpacity(.7),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            SizedBox(
                width: 80,
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
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$ ${item.price!.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: CColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  isLoading ? const CircularProgressIndicator() : getButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getButton() {
    if (onWishlist) {
      return ElevatedButton.icon(
          icon: const Icon(
            Icons.remove,
            size: 15,
          ),
          onPressed: () {
            onAddBottomTap(false);
          },
          label: const Text(
            "Remove",
            style: TextStyle(fontSize: 10),
          ));
    } else {
      return ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
            size: 15,
          ),
          onPressed: () {
            onAddBottomTap(true);
          },
          label: const Text(
            "Add",
            style: TextStyle(fontSize: 10),
          ));
    }
  }
}
