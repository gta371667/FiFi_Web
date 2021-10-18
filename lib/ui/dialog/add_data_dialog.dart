import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';

enum AddDataEnum {
  /// 主餐
  mainDish,

  /// 飲料
  beverage,

  /// 人員
  member,
}

class AddDataDialog extends StatefulWidget {
  const AddDataDialog({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  final String hintText;

  @override
  State<AddDataDialog> createState() => _AddDataDialogState();
}

class _AddDataDialogState extends State<AddDataDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: Material(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildButton(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 底部按鈕
  Widget _buildButton() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            child: Text(
              S.of(context).Button_Cancel,
              style: const TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton(
            child: Text(
              S.of(context).Button_Confirm,
              style: const TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop(_textEditingController.text);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
