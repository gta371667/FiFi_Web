import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/res/firebase_path.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final DatabaseReference db = FirebaseDatabase().reference();

  /// 人員流
  BehaviorSubject<List<MemberData>> _memberSubject = BehaviorSubject.seeded([]);

  Stream<List<MemberData>> get memberStream => _memberSubject.stream;

  List<MemberData> get currentMemberList => _memberSubject.value;

  /// 主餐列表
  List<MainDish> currentMainDishList = [];

  /// 飲料列表
  List<Beverage> currentBeverageList = [];

  /// 監聽資料變化
  void initFirebase() {
    db.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      Map<dynamic, dynamic> mainDishMap = event.snapshot.value[FirebasePath.mainDish] ?? {};
      Map<dynamic, dynamic> beverageMap = event.snapshot.value[FirebasePath.beverage] ?? {};
      Map<dynamic, dynamic> memberMap = event.snapshot.value[FirebasePath.member] ?? {};

      /// 主餐
      var mainDishList = _mapToMainDishList(mainDishMap);
      currentMainDishList.clear();
      currentMainDishList.addAll(mainDishList);
      currentMainDishList.sort((a1, a2) {
        return num.parse(a2.addDateTime).compareTo(num.parse(a1.addDateTime));
      });

      /// 飲料
      var beverageList = _mapToBeverageList(beverageMap);
      currentBeverageList.clear();
      currentBeverageList.addAll(beverageList);
      currentBeverageList.sort((a1, a2) {
        return num.parse(a2.addDateTime).compareTo(num.parse(a1.addDateTime));
      });

      /// 人員
      var memberList = _mapToMemberList(memberMap);
      _memberSubject.add(memberList);
    });
  }

  /// 新增人員
  Stream<void> addMember(String memberName) {
    return Stream.value(currentMemberList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == memberName);
      if (index != -1) {
        throw S.current.existed_member;
      }

      return Stream.value(
        MemberData(
          addDateTime: DateTime.now().millisecondsSinceEpoch.toString(),
          name: memberName,
        ),
      );
    }).flatMap((value) => db.child(FirebasePath.member).update(value.toMap()).asStream());
  }

  /// 新增主餐
  Stream<void> addMainDish(String mainDish) {
    return Stream.value(currentMainDishList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == mainDish);
      if (index != -1) {
        throw S.current.existed_mainDish;
      }

      return Stream.value(
        MainDish(
          addDateTime: DateTime.now().millisecondsSinceEpoch.toString(),
          name: mainDish,
        ),
      );
    }).flatMap((value) => db.child(FirebasePath.mainDish).update(value.toMap()).asStream());
  }

  /// 新增飲料
  Stream<void> addBeverage(String beverage) {
    return Stream.value(currentBeverageList).flatMap((value) {
      int index = value.indexWhere((element) => element.name == beverage);
      if (index != -1) {
        throw S.current.existed_beverage;
      }

      return Stream.value(
        Beverage(
          addDateTime: DateTime.now().millisecondsSinceEpoch.toString(),
          name: beverage,
        ),
      );
    }).flatMap((value) => db.child(FirebasePath.beverage).update(value.toMap()).asStream());
  }

  /// 選擇主餐事件
  void selectMainDish(MemberData memberData, MainDish mainDish) {
    if (memberData.mainDish == mainDish) return;

    memberData.mainDish = mainDish;
    _memberSubject.add(_memberSubject.value);
  }

  /// 選擇飲料事件
  void selectBeverage(MemberData memberData, Beverage beverage) {
    if (memberData.beverage == beverage) return;

    memberData.beverage = beverage;
    _memberSubject.add(_memberSubject.value);
  }

  /// 清除某節點下所有資料
  void cleanByPath(String path) {
    db.child(path).set(null).then((value) => null);
  }

  /// 轉換為人員列表
  List<MemberData> _mapToMemberList(Map<dynamic, dynamic> map) {
    return map.entries
        .map(
          (entry) => MemberData(addDateTime: entry.key, name: entry.value),
        )
        .toList();
  }

  /// 轉換為主餐列表
  List<MainDish> _mapToMainDishList(Map<dynamic, dynamic> map) {
    return map.entries
        .map(
          (entry) => MainDish(addDateTime: entry.key, name: entry.value),
        )
        .toList();
  }

  /// 轉換為飲料列表
  List<Beverage> _mapToBeverageList(Map<dynamic, dynamic> map) {
    return map.entries
        .map(
          (entry) => Beverage(addDateTime: entry.key, name: entry.value),
        )
        .toList();
  }
}
