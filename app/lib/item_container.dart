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
  ItemContainer(14.0, 43.0, 154.0, 235.0, 'ตู้อุปกรณ์'),
  ItemContainer(141.0, 171.0, 135.0, 198.0, 'ตู้ซัพพลาย'),
  ItemContainer(205.0, 235.0, 135.0, 198.0, 'ตู้ยา'),
  ItemContainer(260.0, 299.0, 135.0, 198.0, 'ตู้เก็บสารละลาย'),
  ItemContainer(238.0, 266.0, 135.0, 198.0, 'ตู้เย็น'),
  ItemContainer(333.0, 362.0, 217.0, 300.0, 'ตู้ผ้า'),
  ItemContainer(14.0, 43.0, 215.0, 294.0, 'รถเจาะเลือด'),
  ItemContainer(14.0, 43.0, 319.0, 356.0, 'รถฉุกเฉิน'),
  ItemContainer(109.0, 139.0, 215.0, 294.0, 'โต๊ะข้างเตียง'),
  ItemContainer(204.0, 235.0, 215.0, 294.0, 'โต๊ะข้างเตียง'),
  ItemContainer(109.0, 139.0, 359.0, 388.0, 'โต๊ะข้างเตียง'),
  ItemContainer(204.0, 235.0, 359.0, 388.0, 'โต๊ะข้างเตียง'),
  ItemContainer(333.0, 372.0, 349.0, 388.0, 'รถชำระ'),
  ItemContainer(14.0, 43.0, 385.0, 420.0, 'รถชำระ'),
  ItemContainer(77.0, 138.0, 423.0, 452.0, 'รถ feed'),
  ItemContainer(269.0, 330.0, 412.0, 457.0, 'ห้องน้ำ'),
];