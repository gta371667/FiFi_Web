import 'package:flutter/material.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/ui/bloc/history_page_bloc.dart';
import 'package:flutter_web_test/ui/widget/history_order_item_widget.dart';

/// 歷史紀錄
class HistoryPage extends StatefulWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryPageBloc bloc = HistoryPageBloc();

  @override
  void initState() {
    bloc.initFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FiFi Menu 歷史紀錄"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSpinner(),
            ),
            Expanded(
              child: _buildMenuList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 下拉選單
  Widget _buildSpinner() {
    return StreamBuilder<List<String>>(
      stream: bloc.dateStream,
      initialData: const [],
      builder: (context, snapshot) {
        var dataList = snapshot.requireData;

        return DropdownButton<String>(
          value: bloc.currentDateKey,
          onChanged: (key) => bloc.selectDate(key),
          items: dataList
              .map(
                (e) => DropdownMenuItem<String>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(e),
                  ),
                  value: e,
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// 歷史菜單列表
  Widget _buildMenuList() {
    return StreamBuilder<List<FiFiMenu>>(
      stream: bloc.orderStream,
      initialData: const [],
      builder: (context, snapshot) {
        var dataList = snapshot.requireData;

        return ListView.builder(
          itemExtent: 64,
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var data = dataList[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: HistoryOrderItemWidget(
                fifiMenu: data,
                beverageList: bloc.currentBeverageList,
                mainDishList: bloc.currentMainDishList,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
