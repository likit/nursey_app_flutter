import 'package:flutter/services.dart';

class ItemContainer {
  double x1;
  double x2;
  double y1;
  double y2;
  String label;
  ItemContainer(this.x1, this.x2, this.y1, this.y2, this.label);
}


List<ItemContainer> itemContainers = [
  ItemContainer(260.0, 299.0, 135.0, 198.0, 'ตู้ยา'),
  ItemContainer(238.0, 266.0, 135.0, 198.0, 'ตู้เย็น'),
  ItemContainer(109.0, 139.0, 215.0, 294.0, 'โต๊ะข้างเตียง'),
  ItemContainer(204.0, 235.0, 215.0, 294.0, 'โต๊ะข้างเตียง'),
  ItemContainer(109.0, 139.0, 359.0, 388.0, 'โต๊ะข้างเตียง'),
  ItemContainer(204.0, 235.0, 359.0, 388.0, 'โต๊ะข้างเตียง'),
];