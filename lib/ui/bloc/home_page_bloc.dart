import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/res/firebase_path.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final DatabaseReference db = FirebaseDatabase().reference();

  /// 菜單流
  BehaviorSubject<List<FiFiMenu>> _orderSubject = BehaviorSubject.seeded([]);

  Stream<List<FiFiMenu>> get orderStream => _orderSubject.stream;

  List<FiFiMenu> get currentOrderList => _orderSubject.value;

  /// 主餐列表
  List<MainDish> currentMainDishList = [];

  /// 飲料列表
  List<Beverage> currentBeverageList = [];

  /// 人員列表
  List<MemberData> currentMemberList = [];

  void testF() {
    Map<String, dynamic> map = {};

    List<FiFiMenu> sss = [];

    List.generate(
      5,
      (index) => sss.add(
        FiFiMenu(addDateTime: index, memberName: 'name_$index'),
      ),
    );

    map['sss'] = sss.map((e) => e.toMap()).toList();
    db.child('testF').update(map).then((value) => null);
  }

  /// 更新主餐
  void _updateMainDish(List<dynamic> data) {
    currentMainDishList = data.map((e) => MainDish.fromJson(e)).toList();
    currentMainDishList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a1.sort.compareTo(a2.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
  }

  /// 更新飲料
  void _updateBeverage(List<dynamic> data) {
    currentBeverageList = data.map((e) => Beverage.fromJson(e)).toList();
    currentBeverageList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a1.sort.compareTo(a2.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
  }

  /// 更新人員
  void _updateMember(List<dynamic> data) {
    currentMemberList = data.map((e) => MemberData.fromJson(e)).toList();
    currentMemberList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a2.sort.compareTo(a1.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
  }

  /// 監聽資料變化
  void initFirebase() {
    db.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      List<dynamic> mainDishMap = event.snapshot.value[FirebasePath.mainDish] ?? [];
      List<dynamic> beverageMap = event.snapshot.value[FirebasePath.beverage] ?? [];
      List<dynamic> memberMap = event.snapshot.value[FirebasePath.member] ?? [];

      /// 主餐
      _updateMainDish(mainDishMap);

      /// 飲料
      _updateBeverage(beverageMap);

      /// 人員
      _updateMember(memberMap);

      /// 訂單
      _updateOrder();
    });
  }

  /// 更新訂單
  void _updateOrder() {
    var data = currentMemberList
        .map(
          (e) => FiFiMenu(
            addDateTime: DateTime.now().millisecondsSinceEpoch,
            memberName: e.name,
          ),
        )
        .toList();
    _orderSubject.add(data);
  }

  /// 新增人員
  Stream<void> addMember(InputData inputData) {
    return Stream.value(currentMemberList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == inputData.name);
      if (index != -1) {
        throw S.current.existed_member;
      }

      var memberData = MemberData(
        addDateTime: DateTime.now().millisecondsSinceEpoch,
        name: inputData.name,
        sort: inputData.sort,
      );

      currentMemberList.add(memberData);

      return Stream.value(currentMemberList);
    }).flatMap((value) {
      Map<String, dynamic> map = {};
      map[FirebasePath.member] = value.map((e) => e.toMap()).toList();
      return db.update(map).asStream();
    });
  }

  /// 新增主餐
  Stream<void> addMainDish(InputData mainDish) {
    return Stream.value(currentMainDishList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == mainDish.name);
      if (index != -1) {
        throw S.current.existed_member;
      }

      var memberData = MainDish(
        addDateTime: DateTime.now().millisecondsSinceEpoch,
        name: mainDish.name,
        sort: mainDish.sort,
      );

      currentMainDishList.add(memberData);

      return Stream.value(currentMainDishList);
    }).flatMap((value) {
      Map<String, dynamic> map = {};
      map[FirebasePath.mainDish] = value.map((e) => e.toMap()).toList();
      return db.update(map).asStream();
    });
  }

  /// 新增飲料
  Stream<void> addBeverage(InputData beverage) {
    return Stream.value(currentBeverageList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == beverage.name);
      if (index != -1) {
        throw S.current.existed_member;
      }

      var memberData = Beverage(
        addDateTime: DateTime.now().millisecondsSinceEpoch,
        name: beverage.name,
        sort: beverage.sort,
      );
      currentBeverageList.add(memberData);

      return Stream.value(currentBeverageList);
    }).flatMap((value) {
      Map<String, dynamic> map = {};
      map[FirebasePath.beverage] = value.map((e) => e.toMap()).toList();
      return db.update(map).asStream();
    });
  }

  /// 選擇主餐事件
  void selectMainDish(FiFiMenu memberData, MainDish mainDish) {
    if (memberData.mainDish == mainDish) return;

    memberData.mainDish = mainDish;
    _orderSubject.add(_orderSubject.value);
  }

  /// 選擇飲料事件
  void selectBeverage(FiFiMenu memberData, Beverage beverage) {
    if (memberData.beverage == beverage) return;

    memberData.beverage = beverage;
    _orderSubject.add(_orderSubject.value);
  }

  /// 清除某節點下所有資料
  void cleanByPath(String path) {
    db.child(path).set(null).then((value) => null);
  }
}
