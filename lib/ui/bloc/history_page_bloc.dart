import 'dart:async';

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

  /// 當前日期
  String? currentDateKey;

  /// Firebase監聽
  StreamSubscription<Event>? databaseListener;

  /// 監聽資料變化
  void initFirebase() {
    databaseListener = db.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      Map<dynamic, dynamic> memberMap = event.snapshot.value[FirebasePath.member] ?? {};
      Map<dynamic, dynamic> historyOrder = event.snapshot.value[FirebasePath.order] ?? {};

      /// 人員
      _updateMember(memberMap);

      /// 不顯示當日菜單
      historyOrder.remove(todayKey);
      historyMap = _mapToHistoryList(historyOrder);
      if (historyMap.isEmpty) {
        return;
      }

      /// 日期
      currentDateKey ??= historyMap.keys.first;
      _dateSubject.add(historyMap.keys.toList());

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

  /// 轉換至歷史訂單
  Map<String, List<FiFiMenu>> _mapToHistoryList(Map<dynamic, dynamic> historyOrder) {
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

    Map<String, List<FiFiMenu>> map = {};
    for (var element in sortedKeys) {
      map[element] = temp[element] ?? [];
    }
    return map;
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

  /// 取得該日主餐 - 過濾重複
  void _filterMainDish(List<FiFiMenu> orders) {
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

  /// 取得該日飲料 - 過濾重複
  void _filterBeverage(List<FiFiMenu> orders) {
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
    _filterMainDish(orders);
    _filterBeverage(orders);

    var data = orders.map(
      (e) {
        MainDish? mainDish = e.mainDish;
        Beverage? beverage = e.beverage;

        /// 人員排序
        int memberIndex = currentMemberList.indexWhere((element) => element.name == e.memberData.name);
        if (memberIndex != -1) {
          int sort = currentMemberList[memberIndex].sort;
          if (e.memberData.sort == 0 && e.memberData.sort != sort) {
            e.memberData.sort = sort;
          }
        }

        /// 當前主餐
        int mIdx = currentMainDishList.indexWhere((element) => element.name == mainDish?.name);
        if (mIdx != -1) {
          mainDish = currentMainDishList[mIdx];
        }

        /// 當前飲料
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

  /// 關閉
  void dispose() {
    _orderSubject.close();
    _loadingSubject.close();
    databaseListener?.cancel();
  }
}
