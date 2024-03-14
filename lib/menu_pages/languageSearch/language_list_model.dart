

class LanguageListModel {
  LanguageListModel(this.listOptionItems);

  final List<LanguageItem> listOptionItems;
}

class LanguageItem {
  final String name;
  final int count;

  LanguageItem({required this.name, required this.count});
}