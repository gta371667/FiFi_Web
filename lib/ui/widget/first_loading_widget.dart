import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 第一次加載資料時顯示元件
class FirstLoadingWidget extends StatelessWidget {
  const FirstLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      child: const RefreshProgressIndicator(),
    );
  }
}
