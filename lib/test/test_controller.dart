import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
    ChangeNotifierProvider((ref) => SearchScreenController());

class SearchScreenController extends ChangeNotifier {
  List<ContactsModel> originalContactList = [];

  List<ContactsModel> contactListFilter = [];

  updateDataIntoContactList(List<Contact> contact) {
    for (int i = 0; i < contact.length; i++) {
      if (contact[i].phones.isNotEmpty) {
        originalContactList.add(
          ContactsModel(
            title: (contact[i].displayName.toString()),
            phoneNumber:
                contact[i].phones.first.number.substring(0, 2).contains("+") &&
                        contact[i].phones.first.number.length == 11
                    ? contact[i]
                        .phones
                        .first
                        .number
                        .toString()
                        .replaceAll("-", "")
                        .replaceAll(" ", "")
                        .replaceAll("+", "")
                    : contact[i].phones.first.number.length == 13
                        ? contact[i]
                            .phones
                            .first
                            .number
                            .toString()
                            .replaceAll("-", "")
                            .replaceAll(" ", "")
                            .replaceRange(0, 3, "")
                        : contact[i]
                            .phones
                            .first
                            .number
                            .toString()
                            .replaceAll("+91", "")
                            .replaceAll("-", "")
                            .replaceAll(" ", ""),
          ),
        );
      }
    }
    // originalContactList = contact;

    notifyListeners();
  }

  Future<void> refreshContacts() async {
    var contacts = (await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true));
    updateDataIntoContactList(contacts);
  }

  /// remove Space in between Phone Number
  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  searchContact(String searchStr) {
    List<ContactsModel> contacts = [];
    contacts.addAll(originalContactList);
    if (searchStr != "") {
      contactListFilter = contacts
          .where((element) => (element.phoneNumber.contains(searchStr) &&
              element.phoneNumber.startsWith(searchStr[0])))
          .toList();

    } else {
      refreshContacts();
    }

    notifyListeners();
  }
}

class ContactsModel {
  String title, matchString, unMatchString, phoneNumber;
  int matchedCharLength;
  int? color;

  ContactsModel({
    required this.title,
    this.matchString = "",
    this.unMatchString = "",
    required this.phoneNumber,
    this.matchedCharLength = -1,
    this.color,
  });
}
