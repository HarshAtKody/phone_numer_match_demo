import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonSearchBar extends StatelessWidget {
  final double? height;
  final String? label;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  final double? elevation;
  final double? circularValue;
  final Color? clrSplash;
  final Color? clrBG;
  final bool? isRemoveMargin;
  TextEditingController controller;
  FocusNode? focusNode;
  final double? borderRadius;
  final String? hintText;

  CommonSearchBar({
    Key? key,
    this.onTap,
    this.height,
    this.label,
    this.onChanged,
    this.elevation,
    this.circularValue,
    this.clrSplash,
    this.clrBG,
    this.isRemoveMargin,
    this.borderRadius,
    required this.controller,
    this.focusNode,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                // color: clrCardBGByTheme(),
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                border: Border.all(color: Colors.grey, width: 0.5)),
            height: height ?? 48,
            child: InkWell(
              splashColor: clrSplash ?? Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(circularValue ?? 7),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorColor: Colors.lightBlueAccent,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: onChanged,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(60),
                    ],
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        prefixIcon: const Padding(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, right: 16),
                          child: Icon(
                            Icons.search,
                            size: 20,
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minHeight: 10, minWidth: 20),
                        hintText: hintText ?? "Search Here...",
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.white38),
                      helperStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.white38),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
