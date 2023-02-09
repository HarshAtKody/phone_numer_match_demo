import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'test_controller.dart';

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
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 16),
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

class SearchContactsScreen extends ConsumerStatefulWidget {
  const SearchContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchContactsScreen> createState() =>
      _SearchContactsScreenState();
}

class _SearchContactsScreenState extends ConsumerState<SearchContactsScreen> {
  TextEditingController searchContactCTR = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final searchContactWatch = ref.watch(searchProvider);
      searchContactWatch.refreshContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchContactWatch = ref.watch(searchProvider);

    bool isSearched = searchContactCTR.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: CommonSearchBar(
          controller: searchContactCTR,
          onChanged: (value) {
            searchContactWatch.searchContact(value);
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: searchContactWatch.originalContactList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: isSearched
                    ? searchContactWatch.contactListFilter.length
                    : searchContactWatch.originalContactList.length,
                itemBuilder: (BuildContext context, int index) {
                  ContactsModel c = isSearched
                      ? searchContactWatch.contactListFilter.elementAt(index)
                      : searchContactWatch.originalContactList.elementAt(index);

                  final int startIndex =
                      c.title.indexOf(searchContactCTR.text.trim());
                  final int endIndex =
                      startIndex + searchContactCTR.text.trim().length;

                  final int startPhoneIndex = c.phoneNumber
                      .replaceAll(" ", "")
                      .indexOf(searchContactCTR.text);
                  final int endPhoneIndex =
                      startPhoneIndex + searchContactCTR.text.trim().length;
                  return ListTile(
                    style: ListTileStyle.drawer,
                    isThreeLine: true,
                    onTap: () {},

                    title: (startIndex == -1)
                        ? Text(c.title)
                        : RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: c.title.substring(0, startIndex),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                                TextSpan(
                                  text: c.title.substring(startIndex, endIndex),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                        color: Colors.yellow,
                                      ),
                                ),
                                TextSpan(
                                  text: c.title
                                      .substring(endIndex, c.title.length),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                              ],
                            ),
                          ),
                    subtitle: (startPhoneIndex == -1)
                        ? Text(c.phoneNumber
                            .toString()
                            .replaceAll("+91", "")
                            .replaceAll("-", ""))
                        : RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: c.phoneNumber
                                      .replaceAll("+91", "")
                                      .replaceAll("-", "")
                                      .trim()
                                      .substring(0, startPhoneIndex),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                                TextSpan(
                                  text: c.phoneNumber
                                      .replaceAll("+91", "")
                                      .replaceAll("-", "")
                                      .trim()
                                      .substring(
                                          startPhoneIndex, endPhoneIndex),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                        color: Colors.yellow,
                                      ),
                                ),
                                TextSpan(
                                  text: c.phoneNumber.trim().substring(
                                      endPhoneIndex, c.phoneNumber.length),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                              ],
                            ),
                          ),
                    //   },
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    // ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  String initials(Name name) {
    return (name.first != "" ? name.first.substring(0, 1) : "") +
        (name.last != "" ? name.last.substring(0, 1) : "").toUpperCase();
  }
}
