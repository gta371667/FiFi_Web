import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/ui/bloc/home_page_bloc.dart';
import 'package:flutter_web_test/ui/dialog/add_data_dialog.dart';
import 'package:flutter_web_test/ui/dialog/user_prompt_dialog.dart';
import 'package:flutter_web_test/ui/widget/order_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageBloc bloc = HomePageBloc();

  @override
  void initState() {
    super.initState();
    // bloc.initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("aaaa"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildMember(),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => _showAddDataDialog(
                  AddDataEnum.member,
                  S.of(context).add_member_hint,
                ),
                child: const Text('addMember'),
              ),
              TextButton(
                onPressed: () => _showAddDataDialog(
                  AddDataEnum.mainDish,
                  'mainDish',
                ),
                child: const Text('mainDish'),
              ),
              TextButton(
                onPressed: () => _showAddDataDialog(
                  AddDataEnum.beverage,
                  'beverage',
                ),
                child: const Text('beverage'),
              ),
              TextButton(
                onPressed: () => bloc.testF(),
                child: const Text('test'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 人員列表
  Widget _buildMember() {
    return StreamBuilder<List<FiFiMenu>>(
      stream: bloc.orderStream,
      builder: (context, snapshot) {
        var dataList = snapshot.data ?? [];

        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var data = dataList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: OrderItemWidget(
                memberData: data,
                beverageList: bloc.currentBeverageList,
                mainDishList: bloc.currentMainDishList,
                beverageCallback: (memberData, beverage) {
                  bloc.selectBeverage(memberData, beverage);
                },
                mainDishCallback: (memberData, mainDish) {
                  bloc.selectMainDish(memberData, mainDish);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// 新增人員Dialog
  void _showAddDataDialog(
    AddDataEnum addDataEnum,
    String hintText,
  ) {
    showDialog<String>(
      context: context,
      builder: (context) => AddDataDialog(
        hintText: hintText,
      ),
    ).then((value) {
      if (value == null || value.isEmpty) return;

      switch (addDataEnum) {
        case AddDataEnum.mainDish:
          _addMainDish(value);
          break;
        case AddDataEnum.beverage:
          _addBeverage(value);
          break;
        case AddDataEnum.member:
          _addMember(value);
          break;
      }
    });
  }

  /// 執行新增人員
  void _addMember(String name) {
    bloc.addMember(name).listen(
      (event) => {},
      onError: (err, stack) {
        showDialog(
          context: context,
          builder: (context) {
            return UserPromptDialog(
              promptEnum: UserPromptEnum.error,
              buttonEnum: UserPromptButtonEnum.one,
              content: err.toString(),
              cancelable: false,
            );
          },
        );
      },
    );
  }

  /// 執行新增主餐
  void _addMainDish(String name) {
    bloc.addMainDish(name).listen(
      (event) => {},
      onError: (err, stack) {
        showDialog(
          context: context,
          builder: (context) {
            return UserPromptDialog(
              promptEnum: UserPromptEnum.error,
              buttonEnum: UserPromptButtonEnum.one,
              content: err.toString(),
              cancelable: false,
            );
          },
        );
      },
    );
  }

  /// 執行新增飲料
  void _addBeverage(String name) {
    bloc.addBeverage(name).listen(
      (event) => {},
      onError: (err, stack) {
        showDialog(
          context: context,
          builder: (context) {
            return UserPromptDialog(
              promptEnum: UserPromptEnum.error,
              buttonEnum: UserPromptButtonEnum.one,
              content: err.toString(),
              cancelable: false,
            );
          },
        );
      },
    );
  }
}