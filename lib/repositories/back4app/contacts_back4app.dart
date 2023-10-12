import 'package:contacts/model/contact/contact_model.dart';
import 'package:contacts/model/contact/contacts_model.dart';
import 'package:contacts/repositories/back4app/back4app_custom.dart';
import 'package:flutter/material.dart';

class ContactsBack4AppRepository {
  final back4AppCustomDio = Back4AppCustomDio();

  ContactsBack4AppRepository();

  Future<void> deleteContact(String objectId) async {
    try {
      await back4AppCustomDio.dio.delete("/Contacts/$objectId");
    } catch (e) {
      debugPrint("Erro ao deletar contato: $e");
    }
  }

  Future<ContactsModel> getFavoriteContacts() async {
    var result = await back4AppCustomDio.dio
        .get("/Contacts?where={\"favorite\":true}&order=Name");
    if (result.statusCode == 200) {
      return ContactsModel.fromJson(result.data);
    } else {
      return ContactsModel.vazio();
    }
  }

  Future<ContactsModel> getContacts() async {
    var result = await back4AppCustomDio.dio.get("/Contacts?order=Name");
    if (result.statusCode == 200) {
      return ContactsModel.fromJson(result.data);
    } else {
      return ContactsModel.vazio();
    }
  }

  Future<void> createContact(ContactModel contactModel) async {
    try {
      await back4AppCustomDio.dio
          .post("/Contacts", data: contactModel.toJson());
    } catch (e) {
      debugPrint("Erro ao criar contato: $e");
    }
  }

  Future<void> updateContact(ContactModel contactModel, String objectId) async {
    try {
      await back4AppCustomDio.dio
          .put("/Contacts/$objectId", data: contactModel.toJsonUpdate());
    } catch (e) {
      debugPrint("Erro ao salvar alterações do contato: $e");
    }
  }

  Future<void> favoriteContact(String objectId, bool favorite) async {
    try {
      await back4AppCustomDio.dio
          .put("/Contacts/$objectId", data: {"favorite": favorite});
    } catch (e) {
      debugPrint("Erro ao favoritar contato: $e");
    }
  }
}
