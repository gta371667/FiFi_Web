import 'package:flutter/material.dart';
import 'package:flutter_web_test/model/fifi.dart';

typedef MainDishCallback = void Function(FiFiMenu memberData, MainDish mainDish);

typedef BeverageCallback = void Function(FiFiMenu memberData, Beverage beverage);

/// 點餐item
class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    Key? key,
    required this.memberData,
    required this.mainDishList,
    required this.beverageList,
    required this.mainDishCallback,
    required this.beverageCallback,
  }) : super(key: key);

  final FiFiMenu memberData;

  /// 主餐列表
  final List<MainDish> mainDishList;

  /// 飲料列表
  final List<Beverage> beverageList;

  /// 選擇主餐事件
  final MainDishCallback mainDishCallback;

  /// 選擇飲料事件
  final BeverageCallback beverageCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(memberData.name),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildMainDish(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildBeverage(),
          ),
        ],
      ),
    );
  }

  /// 下拉選單 - 主餐
  Widget _buildMainDish() {
    return DropdownButton<MainDish>(
      isExpanded: true,
      value: memberData.mainDish,
      items: mainDishList
          .map((e) => DropdownMenuItem<MainDish>(
                child: Text(e.name),
                value: e,
              ))
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        mainDishCallback.call(memberData, value);
      },
    );
  }

  /// 下拉選單 - 飲料
  Widget _buildBeverage() {
    return DropdownButton<Beverage>(
      isExpanded: true,
      value: memberData.beverage,
      items: beverageList
          .map((e) => DropdownMenuItem<Beverage>(
                child: Text(e.name),
                value: e,
              ))
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        beverageCallback.call(memberData, value);
      },
    );
  }
}
