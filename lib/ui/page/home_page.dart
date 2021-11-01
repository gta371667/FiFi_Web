import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/ui/bloc/home_page_bloc.dart';
import 'package:flutter_web_test/ui/dialog/add_data_dialog.dart';
import 'package:flutter_web_test/ui/dialog/user_prompt_dialog.dart';
import 'package:flutter_web_test/ui/page/history_page.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HistoryPage(),
              ),
            );
          },
          child: const Icon(Icons.history),
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBottom(),
                ),
                Expanded(
                  child: _buildMember(),
                ),
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
                beverageCallback: (type, menu, beverage) {
                  switch (type) {
                    case CallBackType.select:
                      bloc.selectBeverage(menu, beverage);
                      break;
                    case CallBackType.modify:
                      // TODO: Handle this case.
                      break;
                    case CallBackType.delete:
                      bloc.deleteBeverage(beverage);
                      break;
                  }
                },
                mainDishCallback: (type, menu, mainDish) {
                  switch (type) {
                    case CallBackType.select:
                      bloc.selectMainDish(menu, mainDish);
                      break;
                    case CallBackType.modify:
                      // TODO: Handle this case.
                      break;
                    case CallBackType.delete:
                      bloc.deleteMainDish(mainDish);
                      break;
                  }
                },
                memberCallback: (type, menu) {
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
          child: const Text('新增人員'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => _showAddDataDialog(
            AddDataEnum.mainDish,
            '請輸入主餐',
          ),
          child: const Text('新增主餐'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => _showAddDataDialog(
            AddDataEnum.beverage,
            '請輸入飲料',
          ),
          child: const Text('新增飲料'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () async {
            // Clipboard.setData(const ClipboardData(text: "_copy"));
            String copyText = bloc.getCopyText();

            showText(bloc.getCopyText());
            // FlutterClipboard.copy(copyText).then((value) => null);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Copied to Clipboard"),
            //   ),
            // );
          },
          child: const Text('確認菜單'),
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
            );
          },
        );
      },
    );
  }

  void showText(String copyText) {
    if (copyText.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const UserPromptDialog(
            promptEnum: UserPromptEnum.error,
            content: "未選擇任何餐點",
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return UserPromptDialog(
          promptEnum: UserPromptEnum.ok,
          buttonEnum: UserPromptButtonEnum.two,
          content: bloc.getCopyText(),
          okButtonText: "複製",
          onOkCallback: () {
            FlutterClipboard.copy(copyText).then((value) => null);
            Navigator.of(context).pop();
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
