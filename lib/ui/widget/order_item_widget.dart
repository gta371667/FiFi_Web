import 'package:flutter/material.dart';
import 'package:flutter_web_test/model/fifi.dart';

///
typedef MainDishCallback = void Function(CallBackType type, FiFiMenu fiFiMenu, MainDish mainDish);

typedef BeverageCallback = void Function(CallBackType type, FiFiMenu fiFiMenu, Beverage beverage);

typedef MemberCallback = void Function(CallBackType type, FiFiMenu fiFiMenu);

enum CallBackType {
  /// 選擇
  select,

  /// 修改
  modify,

  /// 刪除
  delete,
}

/// 點餐item
class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    Key? key,
    required this.memberData,
    required this.mainDishList,
    required this.beverageList,
    required this.mainDishCallback,
    required this.beverageCallback,
    required this.memberCallback,
  }) : super(key: key);

  /// 當前訂單
  final FiFiMenu memberData;

  /// 主餐列表
  final List<MainDish> mainDishList;

  /// 飲料列表
  final List<Beverage> beverageList;

  /// 選擇主餐事件
  final MainDishCallback mainDishCallback;

  /// 選擇飲料事件
  final BeverageCallback beverageCallback;

  /// 選擇人員事件
  final MemberCallback memberCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Container(
              color: Colors.yellow,
              child: Text(memberData.memberData.name),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildMainDish(context),
          ),
          const SizedBox(width: 10),
          _buildBeverage(context),
          IconButton(
            onPressed: () => memberCallback.call(CallBackType.delete, memberData),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  /// 下拉選單 - 主餐
  Widget _buildMainDish(BuildContext context) {
    return DropdownButton<MainDish>(
      isExpanded: true,
      value: memberData.mainDish,
      selectedItemBuilder: (context) => mainDishList
          .map(
            (e) => Center(child: Text(e.name)),
          )
          .toList(),
      items: mainDishList
          .map(
            (e) => DropdownMenuItem<MainDish>(
              child: GestureDetector(
                onLongPress: () {
                  Navigator.of(context).pop();
                  mainDishCallback.call(CallBackType.modify, memberData, e);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(child: Text(e.name)),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          mainDishCallback.call(CallBackType.delete, memberData, e);
                        },
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                ),
              ),
              value: e,
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        mainDishCallback.call(CallBackType.select, memberData, value);
      },
    );
  }

  /// 下拉選單 - 飲料
  Widget _buildBeverage(BuildContext context) {
    return SizedBox(
      width: 90,
      child: DropdownButton<Beverage>(
        isExpanded: true,
        value: memberData.beverage,
        selectedItemBuilder: (context) => beverageList
            .map(
              (e) => Center(child: Text(e.name)),
            )
            .toList(),
        items: beverageList
            .map(
              (e) => DropdownMenuItem<Beverage>(
                child: Row(
                  children: [
                    Expanded(child: Text(e.name)),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        beverageCallback.call(CallBackType.delete, memberData, e);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
                value: e,
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          beverageCallback.call(CallBackType.select, memberData, value);
        },
      ),
    );

    return DropdownButton<Beverage>(
      value: memberData.beverage,
      items: beverageList
          .map((e) => DropdownMenuItem<Beverage>(
                child: Text(e.name),
                value: e,
              ))
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        beverageCallback.call(CallBackType.select, memberData, value);
      },
    );
  }
}
