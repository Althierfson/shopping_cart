import 'package:carrinho_de_compra/models/item.dart';

List<Item> quickSortItem(List<Item> list) =>
    quickSort(list, 0, list.length-1);

List<Item> quickSort(List<Item> list, int low, int high) {
  if (low < high) {
    int pi = partition(list, low, high);

    quickSort(list, low, pi - 1);
    quickSort(list, pi + 1, high);
  }
  return list;
}

int partition(List<Item> list, low, high) {
  if (list.isEmpty) {
    return 0;
  }

  double pivot = list[high].price ?? 0.0;

  int i = low - 1;
  for (int j = low; j < high; j++) {
    if (list[j].price! < pivot) {
      i++;
      swap(list, i, j);
    }
  }
  swap(list, i + 1, high);
  return i + 1;
}

void swap(List<Item> list, int i, int j) {
  Item temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
