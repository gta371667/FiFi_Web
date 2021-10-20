/// 菜單
class FiFiMenu {
  FiFiMenu({
    required this.memberName,
    this.mainDish,
    this.beverage,
  });

  final String memberName;
  MainDish? mainDish;
  Beverage? beverage;

  factory FiFiMenu.fromJson(Map<dynamic, dynamic> json) {
    return FiFiMenu(
      memberName: json['memberName'] ?? "",
      mainDish: json['memberName'],
      beverage: json['beverage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberName': memberName,
      'mainDish': mainDish?.name,
      'beverage': beverage?.name,
    };
  }
}

/// 主餐
class MainDish {
  MainDish({
    required this.name,
    required this.addDateTime,
    this.sort = 0,
  });

  /// 名稱
  final String name;

  /// 新增時間
  final int addDateTime;

  /// 排序
  int sort;

  factory MainDish.fromJson(Map<dynamic, dynamic> json) {
    return MainDish(
      name: json['name'],
      addDateTime: json['addDateTime'],
      sort: json['sort'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addDateTime': addDateTime,
      'sort': sort,
    };
  }
}

/// 飲料
class Beverage {
  Beverage({
    required this.name,
    required this.addDateTime,
    this.sort = 0,
  });

  /// 名稱
  final String name;

  /// 新增時間
  final int addDateTime;

  /// 排序
  int sort;

  factory Beverage.fromJson(Map<dynamic, dynamic> json) {
    return Beverage(
      name: json['name'],
      addDateTime: json['addDateTime'],
      sort: json['sort'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addDateTime': addDateTime,
      'sort': sort,
    };
  }
}

class MemberData {
  MemberData({
    required this.name,
    required this.addDateTime,
    this.sort = 0,
  });

  /// 名稱
  final String name;

  /// 新增時間
  final int addDateTime;

  /// 排序
  int sort;

  factory MemberData.fromJson(Map<dynamic, dynamic> json) {
    return MemberData(
      name: json['name'],
      addDateTime: json['addDateTime'],
      sort: json['sort'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addDateTime': addDateTime,
      'sort': sort,
    };
  }
}

/// 輸入回傳
class InputData {
  /// 名稱
  final String name;

  /// 排序
  final int sort;

  InputData({
    required this.name,
    required this.sort,
  });
}
