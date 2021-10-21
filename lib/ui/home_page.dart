import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/ui/bloc/home_page_bloc.dart';
import 'package:flutter_web_test/ui/dialog/add_data_dialog.dart';
import 'package:flutter_web_test/ui/dialog/user_prompt_dialog.dart';
import 'package:flutter_web_test/ui/widget/first_loading_widget.dart';
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
    bloc.initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FiFi Menu (${bloc.todayKey})"),
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: _buildMember(),
                ),
                _buildBottom(),
              ],
            ),
            _buildLoading(),
          ],
        ),
      ),
    );
  }

  /// 載入中
  Widget _buildLoading() {
    return StreamBuilder<bool>(
      stream: bloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {
        bool isLoading = snapshot.requireData;

        return isLoading ? const FirstLoadingWidget() : const SizedBox();
      },
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
                beverageCallback: (menu, beverage) {
                  bloc.selectBeverage(menu, beverage);
                },
                mainDishCallback: (menu, mainDish) {
                  bloc.selectMainDish(menu, mainDish);
                },
                deleteCallback: (menu) {
                  bloc.deleteMember(menu.memberData.name);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// 底部功能
  Widget _buildBottom() {
    return Row(
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
          onPressed: () async {
            // Clipboard.setData(const ClipboardData(text: "_copy"));
            String copyText = bloc.getCopyText();
            if (copyText.isEmpty) return;
            showText();
            FlutterClipboard.copy(copyText).then((value) => null);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Copied to Clipboard"),
              ),
            );
          },
          child: const Text('copy'),
        ),
      ],
    );
  }

  /// 新增人員Dialog
  void _showAddDataDialog(
    AddDataEnum addDataEnum,
    String hintText,
  ) {
    showDialog<InputData>(
      context: context,
      builder: (context) => AddDataDialog(
        hintText: hintText,
      ),
    ).then((value) {
      if (value == null || value.name.isEmpty) return;

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
  void _addMember(InputData inputData) {
    bloc.addMember(inputData).listen(
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
  void _addMainDish(InputData inputData) {
    bloc.addMainDish(inputData).listen(
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
  void _addBeverage(InputData inputData) {
    bloc.addBeverage(inputData).listen(
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

  void showText() {
    showDialog(
      context: context,
      builder: (context) {
        return UserPromptDialog(
          promptEnum: UserPromptEnum.error,
          buttonEnum: UserPromptButtonEnum.one,
          content: bloc.getCopyText(),
          cancelable: false,
        );
      },
    );
  }
}
