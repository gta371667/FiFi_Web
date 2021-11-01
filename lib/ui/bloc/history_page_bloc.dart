import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/res/firebase_path.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class HistoryPageBloc {
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

  /// 今日時間 yyyy-MM-dd
  String get todayKey => DateFormat("yyyy-MM-dd").format(DateTime.now());

  /// 歷史日期流
  final BehaviorSubject<List<String>> _dateSubject = BehaviorSubject.seeded([]);

  Stream<List<String>> get dateStream => _dateSubject.stream;

  /// 所有歷史菜單
  Map<String, List<FiFiMenu>> historyMap = {};

  String? currentDateKey;

  /// 監聽資料變化
  void initFirebase() {
    db.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      Map<dynamic, dynamic> historyOrder = event.snapshot.value[FirebasePath.order] ?? {};

      /// 不顯示當日菜單
      // historyOrder.remove(todayKey);

      var temp = historyOrder.map(
        (key, value) {
          List<FiFiMenu> data = [];
          if (value is Map) {
            data = value.entries.map((e) => FiFiMenu.fromJson(e.value)).toList();
          }
          return MapEntry<String, List<FiFiMenu>>(key, data);
        },
      );

      var sortedKeys = temp.keys.toList(growable: false)
        ..sort((k1, k2) {
          final dateFormat = DateFormat("yyyy-MM-dd");
          var format1 = dateFormat.parse(k1).millisecondsSinceEpoch;
          var format2 = dateFormat.parse(k2).millisecondsSinceEpoch;
          return format2.compareTo(format1);
        });

      historyMap.clear();
      for (var element in sortedKeys) {
        historyMap[element] = temp[element] ?? [];
      }

      if (historyMap.isEmpty) {
        return;
      }

      /// 日期
      currentDateKey ??= historyMap.keys.first;
      _dateSubject.add(sortedKeys);

      /// 歷史主餐
      // _updateMainDish();

      /// 歷史飲料
      // _updateBeverage();

      /// 歷史訂單
      _setOrderList(historyMap[currentDateKey] ?? []);
    });
  }

  /// 選擇日期
  void selectDate(String? key) {
    if (key == null || key == currentDateKey) return;

    currentDateKey = key;
    _dateSubject.add(_dateSubject.value);

    var data = historyMap[key] ?? [];
    _setOrderList(data);
  }

  /// 過濾重複 - 主餐
  void _updateMainDish(List<FiFiMenu> orders) {
    var dataList = orders
        .map(
          (e) => e.mainDish,
        )
        .toSet()
        .toList()
      ..removeWhere((element) => element == null);

    final ids = dataList.map((e) => e?.name ?? "").toSet();
    dataList.retainWhere((x) => ids.remove(x?.name ?? ""));

    currentMainDishList.clear();
    for (var element in dataList) {
      if (element != null) {
        currentMainDishList.add(element);
      }
    }
  }

  /// 過濾重複 - 飲料
  void _updateBeverage(List<FiFiMenu> orders) {
    var dataList = orders
        .map(
          (e) => e.beverage,
        )
        .toSet()
        .toList()
      ..removeWhere((element) => element == null);

    final ids = dataList.map((e) => e?.name ?? "").toSet();
    dataList.retainWhere((x) => ids.remove(x?.name ?? ""));

    currentBeverageList.clear();
    for (var element in dataList) {
      if (element != null) {
        currentBeverageList.add(element);
      }
    }
  }

  /// 更新訂單列表
  void _setOrderList(List<FiFiMenu> orders) {
    _updateMainDish(orders);
    _updateBeverage(orders);

    // var data = orders
    //   ..sort((a1, a2) {
    //     if (a1.memberData.sort != a2.memberData.sort) {
    //       return a1.memberData.sort.compareTo(a2.memberData.sort);
    //     }
    //     return a1.memberData.addDateTime.compareTo(a2.memberData.addDateTime);
    //   });

    var data = orders.map(
      (e) {
        MainDish? mainDish = e.mainDish;
        Beverage? beverage = e.beverage;

        int mIdx = currentMainDishList.indexWhere((element) => element.name == mainDish?.name);
        if (mIdx != -1) {
          mainDish = currentMainDishList[mIdx];
        }

        int bIdx = currentBeverageList.indexWhere((element) => element.name == beverage?.name);
        if (bIdx != -1) {
          beverage = currentBeverageList[bIdx];
        }

        return FiFiMenu(
          memberData: e.memberData,
          mainDish: mainDish,
          beverage: beverage,
        );
      },
    ).toList()
      ..sort((a1, a2) {
        if (a1.memberData.sort != a2.memberData.sort) {
          return a1.memberData.sort.compareTo(a2.memberData.sort);
        }
        return a1.memberData.addDateTime.compareTo(a2.memberData.addDateTime);
      });
    _orderSubject.add(data);
  }

  void dispose() {
    _orderSubject.close();
    _loadingSubject.close();
  }
}
