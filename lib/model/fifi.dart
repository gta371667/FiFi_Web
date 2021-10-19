/// 菜單
class FiFiMenu {
  FiFiMenu({
    required this.addDateTime,
    required this.name,
    this.mainDish,
    this.beverage,
  });

  final String addDateTime;
  final String name;
  MainDish? mainDish;
  Beverage? beverage;

  Map<String, dynamic> toMap() {
    // var test = MainDish(name: '10254', addDateTime: '10254').toMap();
    // test['tada'] = name;

    return {
      'addDateTime': addDateTime,
      'name': name,
      'mainDish': mainDish,
      'beverage': beverage,
    };
  }
}

/// 主餐
class MainDish {
  MainDish({
    required this.addDateTime,
    required this.name,
  });

  final String addDateTime;
  final String name;

  Map<String, dynamic> toMap() {
    return {addDateTime: name};
  }
}

/// 飲料
class Beverage {
  Beverage({
    required this.addDateTime,
    required this.name,
  });

  final String addDateTime;
  final String name;

  Map<String, dynamic> toMap() {
    return {addDateTime: name};
  }
}

class MemberData {
  MemberData({
    required this.addDateTime,
    required this.name,
    this.mainDish,
    this.beverage,
  });

  final String addDateTime;
  final String name;
  MainDish? mainDish;
  Beverage? beverage;

  Map<String, dynamic> toMap() {
    // var test = MainDish(name: '10254', addDateTime: '10254').toMap();
    // test['tada'] = name;

    return {
      'addDateTime': addDateTime,
      'name': name,
      'mainDish': mainDish,
      'beverage': beverage,
    };
  }
}
