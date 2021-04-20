
import 'package:adrus/utils/extensions/disable_focus.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';


class MyTextField extends StatefulWidget {
  final String hint;
  final Color borderColor;
  final Color defaultBorderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final String prefixIcon;
  final String suffixIcon;
  final Color iconColor;
  final double iconSize;
  final int maxLines;
  final TextInputType inputType;
  final bool secureText;
  final double textSize;
  final Color fillColor;
  final Color hitColor;
  final bool linearBottomBorder;
  final Color textColor;
  final double elevation;
  final TextAlign textAlign;
  final TextEditingController controller;
  final bool disableFocus;
final TextDirection textDirection;
  final Function(String) onValueChanged;
  final Function(String) onIconTapped;

  MyTextField(
      {Key key,
      this.hint,
      this.borderColor,
      this.defaultBorderColor,
      this.borderRadius,
      this.padding,
      this.prefixIcon,
      this.suffixIcon,
      this.iconColor,
      this.iconSize,
      this.maxLines,
      this.inputType,
      this.secureText,
      this.textSize,
      this.fillColor,
      this.hitColor,
      this.textColor,
      this.textAlign,
      this.linearBottomBorder,
      this.elevation,
      this.controller,
      this.disableFocus,
        this.textDirection,
      this.onValueChanged,
      this.onIconTapped})
      : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<MyTextField> {
  var _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.

    // if (null != widget.controller) {
    //   widget.controller.dispose();
    // }
    // if(null != _controller){
    //   _controller.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    return Directionality(
      textDirection: (null != widget.textDirection) ? widget.textDirection : TextDirection.rtl,
      child: TextField(
          focusNode: (null != widget.disableFocus && widget.disableFocus)
              ? AlwaysDisabledFocusNode()
              : null,
          controller:
          (null != widget.controller) ? widget.controller : _controller,
          textAlignVertical: TextAlignVertical.center,
          textAlign:
          (null != widget.textAlign) ? widget.textAlign : TextAlign.start,
          maxLengthEnforced: false,
          maxLines: (null != widget.maxLines) ? widget.maxLines : 1,
          keyboardType: (null != widget.inputType)
              ? widget.inputType
              : TextInputType.text,
          obscureText:
          (null != widget.secureText) ? widget.secureText : false,
          style: AppTextStyles.textStyle(
              (null != widget.textSize) ? widget.textSize : 16,
              (null != widget.textColor) ? widget.textColor : Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor:
            (null != widget.fillColor) ? widget.fillColor : Colors.white,
            isDense: true,
            //decrease padding
            contentPadding: (null != widget.padding)
                ? widget.padding
                : AppStyles.paddingSymmetric(3, 2.2),
            prefixIcon: (null != widget.prefixIcon)
                ? IconButton(
              icon: Image.asset(widget.prefixIcon,
                color: (null != widget.iconColor)
                    ? widget.iconColor
                    : null,
                width: (null != widget.iconSize) ? widget.iconSize : 2* SizeConfig.heightMultiplier,
                height: (null != widget.iconSize) ? widget.iconSize : 2* SizeConfig.heightMultiplier,
              ),
              onPressed: () {
                print("prefix tapped");
                widget.onIconTapped((null != widget.controller)
                    ? widget.controller.text
                    : _controller.text);
              },
            )
                : null,
            suffixIcon: (null != widget.suffixIcon)
                ? IconButton(
              icon: Image.asset(widget.suffixIcon,
                color: (null != widget.iconColor)
                    ? widget.iconColor
                    : null,
                width: (null != widget.iconSize) ? widget.iconSize : 2* SizeConfig.heightMultiplier,
                height: (null != widget.iconSize) ? widget.iconSize : 2* SizeConfig.heightMultiplier,
              ),
              onPressed: () {
                print("suffix tapped");
                widget.onIconTapped((null != widget.controller)
                    ? widget.controller.text
                    : _controller.text);
              },
            )
                : null,
            hintText: (null != widget.hint && widget.hint.isNotEmpty)
                ? widget.hint
                : "",
            hintStyle: AppTextStyles.textStyle(
                (null != widget.textSize) ? widget.textSize : 16,
                (null != widget.hitColor)? widget.hitColor : AppColors.GRAY_HINT),
            enabledBorder: (null != widget.linearBottomBorder &&
                widget.linearBottomBorder)
                ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: (null != widget.borderColor)
                      ? widget.borderColor
                      : (null != widget.defaultBorderColor)
                      ? widget.defaultBorderColor
                      : AppColors.GRAY_LIGHT,
                  width: 1),
            )
                : OutlineInputBorder(
              borderSide: BorderSide(
                  color: (null != widget.borderColor)
                      ? widget.borderColor
                      : (null != widget.defaultBorderColor)
                      ? widget.defaultBorderColor
                      : AppColors.GRAY_LIGHT,
                  width: 1),
              borderRadius: BorderRadius.circular((null !=
                  widget.borderRadius)
                  ? widget.borderRadius * SizeConfig.heightMultiplier
                  : 5.0 * SizeConfig.heightMultiplier),
            ),
            focusedBorder: (null != widget.linearBottomBorder &&
                widget.linearBottomBorder)
                ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: (null != widget.borderColor)
                      ? widget.borderColor
                      : AppColors.PRIMARY,
                  width: 1),
            )
                : OutlineInputBorder(
              borderSide: BorderSide(
                  color: (null != widget.borderColor)
                      ? widget.borderColor
                      : AppColors.PRIMARY,
                  width: 1),
              borderRadius: BorderRadius.circular((null !=
                  widget.borderRadius)
                  ? widget.borderRadius * SizeConfig.heightMultiplier
                  : 5.0 * SizeConfig.heightMultiplier),
            ),
          ),
          onChanged: (text) {
            widget.onValueChanged(text);
          }
      ),
    );
  }
}
