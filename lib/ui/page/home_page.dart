import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/model/fifi.dart';
import 'package:flutter_web_test/ui/bloc/home_page_bloc.dart';
import 'package:flutter_web_test/ui/dialog/add_data_dialog.dart';
import 'package:flutter_web_test/ui/dialog/user_prompt_dialog.dart';
import 'package:flutter_web_test/ui/page/history_page.dart';
import 'package:flutter_web_test/ui/style/style.dart';
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
          title: Text(
            "FiFi Menu (${bloc.todayKey})",
            style: appBarTextStyle,
          ),
        ),
        floatingActionButton: SpeedDial(
          heroTag: HeroTags.toHistoryPage,
          spaceBetweenChildren: 6,
          icon: Icons.menu,
          activeChild: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(Icons.close),
          ),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.history),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'History',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const HistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
        // floatingActionButton: ExpandableFab(
        //   distance: 100,
        //   children: [
        //     ActionButton(
        //       onPressed: () => {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (ctx) => const HistoryPage(),
        //           ),
        //         )
        //       },
        //       icon: const Icon(Icons.format_size),
        //     ),
        //     ActionButton(
        //       onPressed: () => {},
        //       icon: const Icon(Icons.insert_photo),
        //     ),
        //     ActionButton(
        //       onPressed: () => {},
        //       icon: const Icon(Icons.videocam),
        //     ),
        //   ],
        // ),
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

  /// ?????????
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

  /// ????????????
  Widget _buildMember() {
    return StreamBuilder<List<FiFiMenu>>(
      stream: bloc.orderStream,
      builder: (context, snapshot) {
        var dataList = snapshot.data ?? [];

        return ListView.builder(
          itemExtent: 64,
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

  /// ????????????
  Widget _buildBottom() {
    return Row(
      children: [
        TextButton(
          onPressed: () => _showAddDataDialog(
            AddDataEnum.member,
            S.of(context).add_member_hint,
          ),
          child: const Text('????????????'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => _showAddDataDialog(
            AddDataEnum.mainDish,
            '???????????????',
          ),
          child: const Text('????????????'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => _showAddDataDialog(
            AddDataEnum.beverage,
            '???????????????',
          ),
          child: const Text('????????????'),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () async {
            // Clipboard.setData(const ClipboardData(text: "_copy"));
            // String copyText = bloc.getCopyText();

            showText(bloc.getCopyText());
            // FlutterClipboard.copy(copyText).then((value) => null);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Copied to Clipboard"),
            //   ),
            // );
          },
          child: const Text('????????????'),
        ),
      ],
    );
  }

  /// ????????????Dialog
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

  /// ??????????????????
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

  /// ??????????????????
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

  /// ??????????????????
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
            content: "?????????????????????",
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
          okButtonText: "??????",
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
