import 'package:flutter/material.dart';
import 'package:flutter_web_test/model/fifi.dart';

/// 點餐item
class HistoryOrderItemWidget extends StatelessWidget {
  const HistoryOrderItemWidget({
    Key? key,
    required this.fifiMenu,
    required this.mainDishList,
    required this.beverageList,
  }) : super(key: key);

  /// 當前訂單
  final FiFiMenu fifiMenu;

  /// 主餐列表
  final List<MainDish> mainDishList;

  /// 飲料列表
  final List<Beverage> beverageList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 55,
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: Text(fifiMenu.memberData.name),
          ),
          const SizedBox(width: 10),
          _buildMainDish(context),
          const SizedBox(width: 10),
          _buildBeverage(context),
        ],
      ),
    );
  }

  /// 下拉選單 - 主餐
  Widget _buildMainDish(BuildContext context) {
    return SizedBox(
      width: 160,
      child: DropdownButton<MainDish>(
        value: fifiMenu.mainDish,
        isExpanded: true,
        items: mainDishList
            .map(
              (e) => DropdownMenuItem<MainDish>(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(e.name),
                ),
                value: e,
              ),
            )
            .toList(),
      ),
    );
  }

  /// 下拉選單 - 飲料
  Widget _buildBeverage(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButton<Beverage>(
        isExpanded: true,
        value: fifiMenu.beverage,
        items: beverageList
            .map(
              (e) => DropdownMenuItem<Beverage>(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(e.name),
                ),
                value: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
