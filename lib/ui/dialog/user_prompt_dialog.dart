import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/res/colors.dart';
import 'package:flutter_web_test/res/images.dart';

/// 單顆按鈕：error、ok、warning
/// 雙按鈕：delete、favor、cancelFavor
enum UserPromptEnum {
  error,
  ok,
  warning,
  delete,
  none,
  remind,
}

enum UserPromptButtonEnum {
  /// 單顆button
  one,

  /// 兩顆button
  two,
}

/// 共用使用者提示Dialog
class UserPromptDialog extends StatelessWidget {
  const UserPromptDialog({
    Key? key,
    required this.promptEnum,
    this.buttonEnum,
    this.title,
    this.content,
    this.iconPath,
    this.onOkCallback,
    this.onCancelCallback,
    this.onSingleCallback,
    this.cancelable = true,
    this.singleButtonText,
    this.okButtonText,
    this.cancelButtonText,
  }) : super(key: key);

  /// 是否可返回關閉
  final bool cancelable;

  /// type
  final UserPromptEnum promptEnum;

  /// buttonType
  final UserPromptButtonEnum? buttonEnum;

  /// 自訂圖片(assets路徑)
  final String? iconPath;

  /// 標題
  final String? title;

  /// 內文
  final String? content;

  /// 單一按鈕文字
  final String? singleButtonText;

  /// 確定按鈕文字
  final String? okButtonText;

  /// 取消按鈕文字
  final String? cancelButtonText;

  /// 點擊事件 - 確定
  final VoidCallback? onOkCallback;

  /// 點擊事件 - 取消
  final VoidCallback? onCancelCallback;

  /// 點擊事件 - 單顆確定
  final VoidCallback? onSingleCallback;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(cancelable),
      child: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightForFinite(width: 300),
            child: Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: _isTypeNone() ? 0 : 30),
                  _buildIcon(),
                  _buildTitle(context),
                  _buildContent(context),
                  const SizedBox(height: 20),
                  _buildButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon
  Widget _buildIcon() {
    if (_isTypeNone()) {
      return const SizedBox(height: 0);
    }
    return Image.asset(
      iconPath ?? getDefaultIconPath,
      width: 80,
      height: 80,
    );
  }

  /// 標題
  Widget _buildTitle(BuildContext context) {
    String defaultTitle = getDefaultTitle(context);
    String? useTitle = title;

    if (title == null) {
      useTitle = defaultTitle;
    }

    return useTitle == null
        ? Container()
        : Container(
            margin: EdgeInsets.only(
              top: (title == "") ? 0 : 20,
              left: 20,
              right: 20,
            ),
            child: Text(
              useTitle,
              style: const TextStyle(
                color: ColorRes.G_promptFontColor,
                fontSize: 20,
              ),
            ),
          );
  }

  /// 內文
  Widget _buildContent(BuildContext context) {
    if (content == null || content!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
      ),
      child: Text(
        content!,
        style: const TextStyle(
          color: ColorRes.G_promptExplainFontColor,
        ),
      ),
    );
  }

  /// 按鈕
  Widget _buildButton(BuildContext context) {
    Widget buttonWidget = Container();

    if (getButtonEnum == UserPromptButtonEnum.one) {
      buttonWidget = _buildSingleButton(context);
    } else {
      buttonWidget = _buildTwoButton(context);
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 6,
      ),
      child: buttonWidget,
    );
  }

  /// 單顆按鈕
  Widget _buildSingleButton(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Ink(
        color: ColorRes.Pop_btnBgColor,
        child: InkWell(
          splashColor: Colors.white.withOpacity(0.5),
          highlightColor: Colors.white.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              singleButtonText ?? S.of(context).Button_Confirm,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            if (onSingleCallback != null) {
              onSingleCallback?.call();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  /// 兩顆按鈕
  Widget _buildTwoButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Ink(
            color: ColorRes.Pop_btnBgColor,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.5),
              highlightColor: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  cancelButtonText ?? S.of(context).Button_Cancel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                if (onCancelCallback != null) {
                  onCancelCallback?.call();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Ink(
            color: ColorRes.G_button1Color,
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.5),
              highlightColor: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  okButtonText ?? S.of(context).Button_Confirm,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                if (onOkCallback != null) {
                  onOkCallback?.call();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _isTypeNone() => promptEnum == UserPromptEnum.none;

  /// 取得Icon預設圖片位置
  String get getDefaultIconPath {
    switch (promptEnum) {
      case UserPromptEnum.error:
        return ImageRes.notice_error;
      case UserPromptEnum.ok:
        return ImageRes.notice_ok;
      case UserPromptEnum.warning:
        return ImageRes.notice_warning;
      case UserPromptEnum.delete:
        return ImageRes.notice_delete;
      case UserPromptEnum.remind:
        return ImageRes.notice_warning;
      case UserPromptEnum.none:
        return "";
      default:
        return ImageRes.notice_error;
    }
  }

  /// 過濾ButtonEnum
  UserPromptButtonEnum? get getButtonEnum {
    if (buttonEnum == null) {
      switch (promptEnum) {
        case UserPromptEnum.error:
          return UserPromptButtonEnum.one;
        case UserPromptEnum.ok:
          return UserPromptButtonEnum.one;
        case UserPromptEnum.warning:
          return UserPromptButtonEnum.one;
        case UserPromptEnum.delete:
          return UserPromptButtonEnum.two;
        case UserPromptEnum.remind:
          return UserPromptButtonEnum.one;
        case UserPromptEnum.none:
          return UserPromptButtonEnum.two;
        default:
          return UserPromptButtonEnum.two;
      }
    } else {
      return buttonEnum;
    }
  }

  /// 取得預設enum的標題
  String getDefaultTitle(BuildContext context) {
    switch (promptEnum) {
      case UserPromptEnum.error:
        return S.of(context).Alert_Error;
      case UserPromptEnum.ok:
        return S.of(context).Alert_Finish;
      case UserPromptEnum.warning:
        return S.of(context).Alert_Warning;
      case UserPromptEnum.delete:
        return S.of(context).Alert_Delete;
      case UserPromptEnum.remind:
        return S.of(context).Alert_Remind;
      default:
        return "";
    }
  }
}
