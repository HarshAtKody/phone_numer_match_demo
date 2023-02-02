import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
    ChangeNotifierProvider((ref) => SearchScreenController());

class SearchScreenController extends ChangeNotifier {
  List<Contact> originalContactList = [];

  List<Contact> contactListFilter = [];

  updateDataIntoContactList(List<Contact> contact) {
    originalContactList = contact;
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
    List<Contact> contacts = [];
    contacts.addAll(originalContactList);
    if (searchStr != "") {
      contacts.retainWhere((contact) {
        String searchTerm = searchStr.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.number);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => Phone(""));

        return phone != Phone("");
      });
      contactListFilter = contacts;
    } else {
      refreshContacts();
    }

    notifyListeners();
  }
}
