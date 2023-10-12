import 'dart:io';

import 'package:animations/animations.dart';
import 'package:contacts/model/contact/contacts_model.dart';
import 'package:contacts/pages/contact/contact_details_page.dart';
import 'package:contacts/repositories/back4app/contacts_back4app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => tr('search_contacts');
  var contactsRepository = ContactsBack4AppRepository();
  var contactsModel = ContactsModel.vazio();
  var favoriteLoading = false;
  var favoriteId = "";

  MySearchDelegate(this.contactsModel);

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = "";
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = contactsModel.results.where((element) {
      var result = element.name.toLowerCase();
      var input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return suggestions.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/empty_result.json'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'no_results',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ).tr(),
                ],
              ),
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              var contact = suggestions[index];
              var file = File(suggestions[index].photo);
              Icon icon = suggestions[index].favorite
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_outline);
              return OpenContainer(
                closedElevation: 0,
                key: UniqueKey(),
                transitionDuration: const Duration(milliseconds: 700),
                openBuilder: (context, action) => ContactDetailsPage(
                    contactsModel: contactsModel, index: index),
                closedColor: Theme.of(context).scaffoldBackgroundColor,
                openColor: Theme.of(context).scaffoldBackgroundColor,
                closedBuilder: (context, action) => ListTile(
                    key: Key(contact.objectId),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumer),
                    leading: CircleAvatar(
                      backgroundImage: const AssetImage(
                          "assets/images/default_profile_image.png"),
                      foregroundImage: file.path == "" ? null : FileImage(file),
                    ),
                    trailing: favoriteId == contact.objectId
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () async {
                              favoriteId = contact.objectId;
                              favoriteLoading = true;
                              await contactsRepository.favoriteContact(
                                  contact.objectId, !contact.favorite);
                              contact.favorite = !contact.favorite;
                              favoriteId = "";
                              favoriteLoading = false;
                            },
                            icon: icon,
                          )),
              );
            },
          );
  }

  @override
  Widget buildResults(BuildContext context) {
    var suggestions = contactsModel.results.where((element) {
      var result = element.name.toLowerCase();
      var input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return suggestions.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/empty_result.json'),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Nenhum resultado encontrado.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              var contact = suggestions[index];
              var file = File(suggestions[index].photo);
              Icon icon = suggestions[index].favorite
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_outline);
              return OpenContainer(
                closedElevation: 0,
                key: UniqueKey(),
                transitionDuration: const Duration(milliseconds: 700),
                openBuilder: (context, action) => ContactDetailsPage(
                    contactsModel: contactsModel, index: index),
                closedColor: Theme.of(context).scaffoldBackgroundColor,
                openColor: Theme.of(context).scaffoldBackgroundColor,
                closedBuilder: (context, action) => ListTile(
                    key: Key(contact.objectId),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumer),
                    leading: CircleAvatar(
                      backgroundImage: const AssetImage(
                          "assets/images/default_profile_image.png"),
                      foregroundImage: file.path == "" ? null : FileImage(file),
                    ),
                    trailing: favoriteId == contact.objectId
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () async {
                              favoriteId = contact.objectId;
                              favoriteLoading = true;
                              await contactsRepository.favoriteContact(
                                  contact.objectId, !contact.favorite);
                              contact.favorite = !contact.favorite;
                              favoriteId = "";
                              favoriteLoading = false;
                            },
                            icon: icon,
                          )),
              );
            },
          );
  }
}
