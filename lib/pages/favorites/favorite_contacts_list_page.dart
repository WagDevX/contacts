import 'dart:io';

import 'package:animations/animations.dart';
import 'package:contacts/model/contact/contacts_model.dart';
import 'package:contacts/pages/contact/contact_details_page.dart';
import 'package:contacts/repositories/back4app/contacts_back4app.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class FavoriteContactsPage extends StatefulWidget {
  const FavoriteContactsPage({super.key});

  @override
  State<FavoriteContactsPage> createState() => _FavoriteContactsPageState();
}

class _FavoriteContactsPageState extends State<FavoriteContactsPage> {
  var loading = false;
  late ContactsBack4AppRepository contactsRepository;
  var contacts = ContactsModel.vazio();
  var favoriteId = "";
  var favoriteLoading = false;
  var errorMessage = "";

  loadContacts() async {
    setState(() {
      loading = true;
    });
    contactsRepository = ContactsBack4AppRepository();
    try {
      contacts = await contactsRepository.getFavoriteContacts();
    } on DioException catch (e) {
      debugPrint(e.toString());
      if (e.type == DioExceptionType.connectionError) {
        errorMessage = tr('connection_error');
      } else {
        errorMessage = tr('unknown_error');
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => Shimmer(
              colorOpacity: 0.6,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListTile(
                trailing: CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                title: SizedBox(
                  height: 10,
                  child: Container(
                    margin: const EdgeInsets.only(right: 140),
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                  ),
                ),
                subtitle: SizedBox(
                  width: 20,
                  height: 10,
                  child: Container(
                    margin: const EdgeInsets.only(right: 110),
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                  ),
                ),
                key: UniqueKey(),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          )
        : contacts.results.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lotties/error.json", repeat: false),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: contacts.results.length,
                itemBuilder: (context, index) {
                  var contact = contacts.results[index];
                  var file = File(contacts.results[index].photo);
                  Icon icon = contacts.results[index].favorite
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_outline);
                  return OpenContainer(
                    closedElevation: 0,
                    key: UniqueKey(),
                    transitionDuration: const Duration(milliseconds: 700),
                    openBuilder: (context, action) => ContactDetailsPage(
                        contactsModel: contacts, index: index),
                    closedColor: Theme.of(context).scaffoldBackgroundColor,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedBuilder: (context, action) => ListTile(
                        key: Key(contact.objectId),
                        title: Text(contact.name),
                        subtitle: Text(contact.phoneNumer),
                        leading: CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/default_profile_image.png"),
                          foregroundImage:
                              file.path == "" ? null : FileImage(file),
                        ),
                        trailing: favoriteId == contact.objectId
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () async {
                                  setState(() {
                                    favoriteId = contact.objectId;
                                    favoriteLoading = true;
                                  });
                                  await contactsRepository.favoriteContact(
                                      contact.objectId, !contact.favorite);
                                  setState(() {
                                    contact.favorite = !contact.favorite;
                                    favoriteId = "";
                                    favoriteLoading = false;
                                  });
                                  if (!contact.favorite) {
                                    contacts.results
                                        .remove(contacts.results[index]);
                                  }
                                },
                                icon: icon,
                              )),
                  );
                },
              );
  }
}
