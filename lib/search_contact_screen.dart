import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_numer_match_demo/common_search_bar.dart';
import 'package:phone_numer_match_demo/framework/data_provider/search_screen_controller.dart';

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
                  Contact c = isSearched
                      ? searchContactWatch.contactListFilter.elementAt(index)
                      : searchContactWatch.originalContactList.elementAt(index);

                  final int startIndex = c.displayName.indexOf(searchContactCTR.text);
                  final int endIndex = startIndex + searchContactCTR.text.length;

                  final int startPhoneIndex = c.phones[0].number.replaceAll(" ","").indexOf(searchContactCTR.text);
                  final int endPhoneIndex = startPhoneIndex + searchContactCTR.text.length;
                  return ListTile(
                    style: ListTileStyle.drawer,
                    isThreeLine: true,
                    onTap: () {},
                    leading: (c.photo != null && ((c.photo?.length)! > 0))
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(c.photo!),
                          )
                        : CircleAvatar(
                            child: Text(
                              initials(c.name),
                            ),
                          ),
                    title: (startIndex == -1)
                        ? Text(c.displayName)
                        : RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: c.displayName.substring(0, startIndex),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                                TextSpan(
                                  text: c.displayName
                                      .substring(startIndex, endIndex),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(
                                        color: Colors.yellow,
                                      ),
                                ),
                                TextSpan(
                                  text: c.displayName.substring(
                                      endIndex, c.displayName.length),
                                  style: DefaultTextStyle.of(context).style,
                                ),
                              ],
                            ),
                          ),
                      subtitle: (startPhoneIndex == -1)
                          ? Text(c.phones[0].number)
                          : RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: c.phones[0].number.substring(0, startPhoneIndex),
                              style: DefaultTextStyle.of(context).style,
                            ),
                            TextSpan(
                              text: c.phones[0].number
                                  .substring(startPhoneIndex, endPhoneIndex),
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(
                                color: Colors.yellow,
                              ),
                            ),
                            TextSpan(
                              text: c.phones[0].number.substring(
                                  endPhoneIndex, c.phones[0].number.length),
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
