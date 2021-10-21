import "package:collection/collection.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/res/firebase_path.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc {
  final DatabaseReference db = FirebaseDatabase().reference();

  /// 菜單流
  final BehaviorSubject<List<FiFiMenu>> _orderSubject = BehaviorSubject.seeded([]);

  Stream<List<FiFiMenu>> get orderStream => _orderSubject.stream;

  List<FiFiMenu> get currentOrderList => _orderSubject.value;

  /// loading流
  final BehaviorSubject<bool> _loadingSubject = BehaviorSubject.seeded(false);

  Stream<bool> get loadingStream => _loadingSubject.stream;

  /// 主餐列表
  List<MainDish> currentMainDishList = [];

  /// 飲料列表
  List<Beverage> currentBeverageList = [];

  /// 人員列表
  List<MemberData> currentMemberList = [];

  /// 監聽資料變化
  void initFirebase() {
    db.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      Map<dynamic, dynamic> mainDishMap = event.snapshot.value[FirebasePath.mainDish] ?? {};
      Map<dynamic, dynamic> beverageMap = event.snapshot.value[FirebasePath.beverage] ?? {};
      Map<dynamic, dynamic> memberMap = event.snapshot.value[FirebasePath.member] ?? {};
      List<dynamic> todayOrder = event.snapshot.value[FirebasePath.order]?[_todayKey] ?? [];

      /// 主餐
      _updateMainDish(mainDishMap);

      /// 飲料
      _updateBeverage(beverageMap);

      /// 人員
      _updateMember(memberMap);

      /// 訂單
      _updateOrder(todayOrder.map((e) => FiFiMenu.fromJson(e)).toList());
    });
  }

  /// 新增人員
  Stream<void> addMember(InputData inputData) {
    return Stream.value(currentMemberList)
        .flatMap((value) {
          int index = value.indexWhere((element) => element.name == inputData.name);
          if (index != -1) {
            throw S.current.existed_member;
          }

          var memberData = MemberData(
            addDateTime: DateTime.now().millisecondsSinceEpoch,
            name: inputData.name,
            sort: inputData.sort,
          );

          return Stream.value(memberData);
        })
        .flatMap((value) {
          return db
              .child(FirebasePath.member)
              .child(value.addDateTime.toString())
              .update(value.toMap())
              .asStream();
        })
        .doOnListen(() => _loadingSubject.add(true))
        .doOnDone(() => _loadingSubject.add(false));
  }

  /// 刪除人員
  void deleteMember(String memberName) {
    int mIdx = currentMemberList.indexWhere((element) => element.name == memberName);

    if (mIdx != -1) {
      db
          .child(FirebasePath.member)
          .child(currentMemberList[mIdx].addDateTime.toString())
          .remove()
          .asStream()
          .doOnListen(() => _loadingSubject.add(true))
          .doOnDone(() => _loadingSubject.add(false))
          .listen((value) => {});
    }
  }

  /// 新增主餐
  Stream<void> addMainDish(InputData inputData) {
    return Stream.value(currentMainDishList)
        .flatMap((value) {
          int index = value.indexWhere((element) => element.name == inputData.name);
          if (index != -1) {
            throw S.current.existed_member;
          }

          var data = MainDish(
            addDateTime: DateTime.now().millisecondsSinceEpoch,
            name: inputData.name,
            sort: inputData.sort,
          );

          return Stream.value(data);
        })
        .flatMap((value) {
          return db
              .child(FirebasePath.mainDish)
              .child(value.addDateTime.toString())
              .update(value.toMap())
              .asStream();
        })
        .doOnListen(() => _loadingSubject.add(true))
        .doOnDone(() => _loadingSubject.add(false));

    // return Stream.value(currentMainDishList)
    //     .flatMap((value) {
    //       int index = value.indexWhere((element) => element.name == mainDish.name);
    //       if (index != -1) {
    //         throw S.current.existed_member;
    //       }
    //
    //       var memberData = MainDish(
    //         addDateTime: DateTime.now().millisecondsSinceEpoch,
    //         name: mainDish.name,
    //         sort: mainDish.sort,
    //       );
    //
    //       currentMainDishList.add(memberData);
    //
    //       return Stream.value(currentMainDishList);
    //     })
    //     .flatMap((value) {
    //       Map<String, dynamic> map = {};
    //       map[FirebasePath.mainDish] = value.map((e) => e.toMap()).toList();
    //       return db.update(map).asStream();
    //     })
    //     .doOnListen(() => _loadingSubject.add(true))
    //     .doOnDone(() => _loadingSubject.add(false));
  }

  /// 新增飲料
  Stream<void> addBeverage(InputData beverage) {
    return Stream.value(currentBeverageList)
        .flatMap((value) {
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
        })
        .flatMap((value) {
          Map<String, dynamic> map = {};
          map[FirebasePath.beverage] = value.map((e) => e.toMap()).toList();
          return db.update(map).asStream();
        })
        .doOnListen(() => _loadingSubject.add(true))
        .doOnDone(() => _loadingSubject.add(false));
  }

  /// 選擇主餐事件
  void selectMainDish(FiFiMenu memberData, MainDish mainDish) {
    if (memberData.mainDish == mainDish) return;

    memberData.mainDish = mainDish;
    // _orderSubject.add(_orderSubject.value);
    saveOrder();
  }

  /// 選擇飲料事件
  void selectBeverage(FiFiMenu memberData, Beverage beverage) {
    if (memberData.beverage == beverage) return;

    memberData.beverage = beverage;
    // _orderSubject.add(_orderSubject.value);

    saveOrder();
  }

  /// 清除某節點下所有資料
  void cleanByPath(String path) {
    db
        .child(path)
        .set(null)
        .asStream()
        .doOnListen(() => _loadingSubject.add(true))
        .doOnDone(() => _loadingSubject.add(false))
        .listen((value) => {});
  }

  /// 更新主餐
  void _updateMainDish(Map<dynamic, dynamic> data) {
    currentMainDishList = data.entries.map((e) => MainDish.fromJson(e.value)).toList();
    currentMainDishList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a1.sort.compareTo(a2.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
    currentMainDishList.insert(0, MainDish.fromJson({}));
  }

  /// 更新飲料
  void _updateBeverage(Map<dynamic, dynamic> data) {
    currentBeverageList = data.entries.map((e) => Beverage.fromJson(e.value)).toList();
    currentBeverageList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a1.sort.compareTo(a2.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
    currentBeverageList.insert(0, Beverage.fromJson({}));
  }

  /// 更新人員
  void _updateMember(Map<dynamic, dynamic> data) {
    currentMemberList = data.entries.map((e) => MemberData.fromJson(e.value)).toList();
    currentMemberList.sort((a1, a2) {
      if (a1.sort != a2.sort) {
        return a1.sort.compareTo(a2.sort);
      }
      return a1.addDateTime.compareTo(a2.addDateTime);
    });
  }

  /// 更新訂單
  void _updateOrder(List<FiFiMenu> todayOrder) {
    var data = currentMemberList.map(
      (e) {
        MainDish? mainDish;
        Beverage? beverage;
        int index = todayOrder.indexWhere((element) => e.name == element.memberName);
        if (index != -1) {
          int mIdx = currentMainDishList.indexWhere(
            (element) => element.name == todayOrder[index].mainDish?.name,
          );
          if (mIdx != -1) {
            mainDish = currentMainDishList[mIdx];
          }

          int bIdx = currentBeverageList.indexWhere(
            (element) => element.name == todayOrder[index].beverage?.name,
          );
          if (bIdx != -1) {
            beverage = currentBeverageList[bIdx];
          }
        }

        return FiFiMenu(
          memberName: e.name,
          mainDish: mainDish,
          beverage: beverage,
        );
      },
    ).toList();
    _orderSubject.add(data);
  }

  /// 儲存訂單
  void saveOrder() {
    Map<String, dynamic> map = {};
    map[_todayKey] = currentOrderList.map((e) => e.toMap()).toList();

    db.child(FirebasePath.order).update(map).then((value) => null);
  }

  /// 今日時間 yyyy-MM-dd
  String get _todayKey => DateFormat("yyyy-MM-dd").format(DateTime.now());

  /// 複製文字
  /// ex：
  /// 打拋雞丁 x 3 (賢、維、彭)
  /// 塔香蛤蜊 x 2 (冠、William)
  ///
  /// 冰綠 x 1 (賢)
  /// 溫綠 x 2 (維、William)
  /// 冰紅 x 1 (彭)
  /// 溫紅 x 1 (冠)
  String getCopyText() {
    var mainDishMap = groupBy<FiFiMenu, String>(currentOrderList, (obj) => obj.mainDish?.name ?? "")
      ..remove("");

    String text = "";
    mainDishMap.forEach((key, value) {
      text += "$key x ${value.length} (";
      text += value.map((e) => e.memberName).join("、");
      text += ")\n";
    });

    text += "\n";
    var beverageMap = groupBy<FiFiMenu, String>(currentOrderList, (obj) => obj.beverage?.name ?? "")
      ..remove("");
    beverageMap.forEach((key, value) {
      text += "$key x ${value.length} (";
      text += value.map((e) => e.memberName).join("、");
      text += ")\n";
    });

    return text.substring(0, text.length - 1);
  }

  void dispose() {
    _orderSubject.close();
    _loadingSubject.close();
  }
}
