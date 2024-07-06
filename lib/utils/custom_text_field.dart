import 'package:e_waste/constants/app_colors.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final Color? textColor;
  final String? Function(String?)? validation;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onSubmited;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final Color? enabledBorderColor;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowSuffixWidget;
  final Widget? suffixWidget;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final IconData? prefixIconUrl;
  final double? prifixIconSize;
  final bool? isSearch;
  final VoidCallback? onSubmit;
  final bool? isEnabled;
  final double? hintFontSize;
  final TextCapitalization? capitalization;
  final double? horizontalSize;
  final double? verticalSize;
  final double? borderRadius;
  final bool? autoFocus;
  final bool? isSaveAutoFillData;
  final bool? isCancelShadow;
  final String autoFillHints;
  final String autoFillHints2;
  final String? errorText;
  final double? suffixSize;
  final double? fontSize;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField(
      {this.hintText = 'Write something...',
      this.controller,
      this.labelText,
      this.focusNode,
      this.errorText,
      this.inputFormatters,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.hintFontSize = 15,
      this.onSuffixTap,
      this.enabledBorderColor,
      this.fillColor,
      this.textColor = colorText,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isCancelShadow = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.isShowSuffixWidget = false,
      this.suffixWidget,
      this.prefixIconUrl,
      this.prifixIconSize,
      this.autoFillHints = '',
      this.autoFillHints2 = '',
      this.isSearch = false,
      this.autoFocus = false,
      this.isSaveAutoFillData = false,
      this.horizontalSize = 22,
      this.verticalSize = 14,
      this.borderRadius = 20,
      this.onSubmited,
      this.validation,
      this.suffixSize,
      this.fontSize,
      this.onFieldSubmitted,
      Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor ?? textFieldFillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius!),
      ),
      child: TextFormField(
        
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,

        onEditingComplete: () {
          if (widget.isSaveAutoFillData!) TextInput.finishAutofillContext();
        },
        autofillHints: [(widget.autoFillHints), (widget.autoFillHints2)],
        style: headline4.copyWith(
            fontSize:widget.fontSize?? 16,
            color: widget.textColor ?? AppColors.primaryColorLight),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: AppColors.primaryColorLight,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: widget.autoFocus!,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword! ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
              ]
            : widget.inputFormatters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.verticalSize!,
              horizontal: widget.horizontalSize!),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? colorText : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? colorText : Colors.transparent,
                  width: widget.isShowBorder! ? 1 : 0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder!
                      ? colorText
                      : widget.enabledBorderColor ?? Colors.black,
                  width: widget.isShowBorder! ? 1 : 0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder!
                      ? Colors.red
                      : AppColors.primaryColor,
                  width: widget.isShowBorder! ? 0.2 : 0)),
          isDense: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: latoStyle300Light,
          fillColor: widget.fillColor ?? textFieldFillColor,
          hintStyle: input.copyWith(
              fontSize: widget.hintFontSize,
              color: widget.textColor!.withOpacity(.5)),
          filled: true,
          errorText: widget.errorText,
          prefixIcon: widget.isShowPrefixIcon!
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Icon(
                    widget.prefixIconUrl!,
                    size: widget.prifixIconSize,
                    color: Colors.black,
                  ),
                )
              : null,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 23, maxHeight: 30),
          suffixIcon: widget.isShowSuffixIcon! && !widget.isShowSuffixWidget!
              ? widget.isPassword!
                  ? InkWell(
                      onTap: _toggle,
                      child: Icon(
                          !_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.grey,
                          size: 23))
                  : widget.isIcon!
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Image.asset(widget.suffixIconUrl!,
                              width: widget.suffixSize ?? 15,
                              height: widget.suffixSize ?? 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        )
                      : null
              : widget.isShowSuffixWidget!
                  ? widget.suffixWidget
                  : null,
        ),
        // onChanged: (String? value) {
        //   if (widget.isSearch!) widget.onChanged!(value);
        // },

        onChanged: widget.isSearch!
            ? (String? value) {
                widget.onChanged!(value);
              }
            : widget.onChanged,
        validator: widget.validation,
        onFieldSubmitted:  
          widget.onFieldSubmitted
        ,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
