import 'package:flutter/material.dart';

class PartNoDropListModel {
  PartNoDropListModel(this.listOptionItems);

  final List<PartNo> listOptionItems;
}

class PartNo {
  final String id;

  PartNo({required this.id});
}