import 'package:flutter/services.dart';

class ItemContainer {
  double x1;
  double x2;
  double y1;
  double y2;
  String label;
  String id;
  ItemContainer(this.x1, this.x2, this.y1, this.y2, this.label, this.id);
}


List<ItemContainer> itemContainers = [
  ItemContainer(0.0, 31.0, 67.0, 150.0, 'ตู้อุปกรณ์', 'Js3ELPDo66Ms82EnTVLn'),
  ItemContainer(128.0, 160.0, 52.0, 112.0, 'ตู้ซัพพลาย', ''),
  ItemContainer(192.0, 223.0, 52.0, 112.0, 'ตู้ยา', ''),
  ItemContainer(224.0, 255.0, 52.0, 112.0, 'ตู้เย็น', ''),
  ItemContainer(256.0, 287.0, 52.0, 112.0, 'ตู้เก็บสารละลาย', ''),
  ItemContainer(320.0, 352.0, 130.0, 214.0, 'ตู้ผ้า', ''),
  ItemContainer(0.0, 31.0, 177.0, 207.0, 'รถเจาะเลือด', ''),
  ItemContainer(0.0, 31.0, 241.0, 272.0, 'รถฉุกเฉิน', ''),
  ItemContainer(0.0, 31.0, 305.0, 335.0, 'รถทำแผล', ''),
  ItemContainer(96.0, 159.0, 177.0, 207.0, 'โต๊ะข้างเตียง A', ''),
  ItemContainer(192.0, 223.0, 177.0, 207.0, 'โต๊ะข้างเตียง B', ''),
  ItemContainer(96.0, 159.0, 274.0, 304.0, 'โต๊ะข้างเตียง C', ''),
  ItemContainer(192.0, 223.0, 274.0, 304.0, 'โต๊ะข้างเตียง D', ''),
  ItemContainer(320.0, 352.0, 264.0, 304.0, 'รถชำระ', ''),
  ItemContainer(64.0, 128.0, 337.0, 367.0, 'รถ feed', ''),
  ItemContainer(256.0, 319.0, 325.0, 372.0, 'ห้องน้ำ', ''),
];