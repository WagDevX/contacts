import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:contacts/model/contact/contact_model.dart';
import 'package:contacts/model/contact/contacts_model.dart';
import 'package:contacts/pages/contact/edit_contact/edit_contact_page.dart';
import 'package:contacts/pages/home_page.dart';
import 'package:contacts/services/router/custom_router.dart';
import 'package:contacts/repositories/back4app/contacts_back4app.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactsModel contactsModel;
  final int index;
  const ContactDetailsPage(
      {super.key, required this.contactsModel, required this.index});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late ContactsBack4AppRepository contactsRepository;
  var phoneNumberController = TextEditingController();
  var cityController = TextEditingController();
  var emailController = TextEditingController();
  XFile? photo;
  Uri? _urlInsta;
  Uri? _urlLinkedn;
  Uri? _phoneNumber;
  Uri? _whatsApp;
  late ContactModel contact;
  var loading = false;

  @override
  void initState() {
    super.initState();
    contactsRepository = ContactsBack4AppRepository();
    contact = ContactModel.fromJson(
        widget.contactsModel.results[widget.index].toJson());
    phoneNumberController.text =
        widget.contactsModel.results[widget.index].phoneNumer;
    cityController.text = widget.contactsModel.results[widget.index].cidade;
    emailController.text = widget.contactsModel.results[widget.index].email;
    _urlInsta = Uri.parse(
        "https://www.instagram.com/${widget.contactsModel.results[widget.index].instagram}");
    _urlLinkedn = Uri.parse(widget.contactsModel.results[widget.index].linkedn);
    _phoneNumber = Uri(
        scheme: 'tel',
        path: widget.contactsModel.results[widget.index].phoneNumer);
    _whatsApp = Uri.parse(
        "https://api.whatsapp.com/send?phone=${widget.contactsModel.results[widget.index].phoneNumer}");
  }

  Future<void> _launchInstagram() async {
    if (!await launchUrl(_urlInsta!)) {
      throw Exception('Could not launch $_urlInsta');
    }
  }

  Future<void> _launchLinkedin() async {
    if (!await launchUrl(_urlLinkedn!)) {
      throw Exception('Could not launch $_urlLinkedn');
    }
  }

  Future<void> _callPhoneNumber() async {
    if (!await launchUrl(_phoneNumber!)) {
      throw Exception('Could not launch $_urlLinkedn');
    }
  }

  Future<void> _launchWhatsApp() async {
    if (!await launchUrl(_whatsApp!)) {
      throw Exception('Could not launch $_urlLinkedn');
    }
  }

  Future<void> _sharePhoneNumber() {
    return Share.share(widget.contactsModel.results[widget.index].phoneNumer,
        subject: "Nome: ${widget.contactsModel.results[widget.index].name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.contactsModel.results[widget.index].name),
        actions: [
          loading
              ? const CircularProgressIndicator()
              : widget.contactsModel.results[widget.index].favorite
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await contactsRepository.favoriteContact(
                            widget.contactsModel.results[widget.index].objectId,
                            false);
                        setState(() {
                          loading = false;
                          widget.contactsModel.results[widget.index].favorite =
                              false;
                        });
                      },
                      icon: const Icon(
                        Icons.star,
                        size: 30,
                      ))
                  : IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await contactsRepository.favoriteContact(
                            widget.contactsModel.results[widget.index].objectId,
                            true);
                        setState(() {
                          loading = false;
                          widget.contactsModel.results[widget.index].favorite =
                              true;
                        });
                      },
                      icon: const Icon(
                        Icons.star_outline,
                        size: 30,
                      )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CustomRoute(
                          builder: (_) => EditContactPage(
                              contactModel: ContactModel(
                                  contact.objectId,
                                  contact.name,
                                  contact.phoneNumer,
                                  contact.countryCode,
                                  contact.favorite,
                                  contact.cidade,
                                  contact.instagram,
                                  contact.linkedn,
                                  contact.photo,
                                  contact.email))));
                },
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                )),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            height: 220,
            child: widget.contactsModel.results[widget.index].photo != ""
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: FileImage(File(widget
                                .contactsModel.results[widget.index].photo)))))
                : Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(
                                "assets/images/default_profile_image.png"))),
                  ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      _callPhoneNumber();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.phone,
                      size: 40,
                    )),
                const SizedBox(width: 20),
                if (contact.instagram != "")
                  IconButton(
                      onPressed: () async {
                        _launchInstagram();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.instagram,
                        size: 40,
                      )),
                if (contact.instagram != "") const SizedBox(width: 20),
                if (contact.linkedn != "")
                  IconButton(
                      onPressed: () async {
                        _launchLinkedin();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 40,
                      )),
                if (contact.linkedn != "") const SizedBox(width: 20),
                IconButton(
                    onPressed: () {
                      _launchWhatsApp();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 40,
                    )),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () {
                      _sharePhoneNumber();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.shareNodes,
                      size: 40,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      labelText: tr('DDD_n_phone'),
                      suffixIcon: const Icon(Icons.phone_android),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  controller: phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter()
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      labelText: tr('city'),
                      suffixIcon: const Icon(Icons.location_city),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  controller: cityController,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      labelText: "Email",
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  controller: emailController,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).secondaryHeaderColor)),
                    onPressed: () {
                      CoolAlert.show(
                          animType: CoolAlertAnimType.scale,
                          backgroundColor: Theme.of(context).primaryColor,
                          loopAnimation: true,
                          lottieAsset: "assets/lotties/delete_animation.json",
                          confirmBtnColor: Theme.of(context).primaryColor,
                          borderRadius: 30,
                          title: tr('warning_sure'),
                          text: tr('warning_action'),
                          cancelBtnText: tr('cancel'),
                          confirmBtnText: tr('Yes'),
                          context: context,
                          onConfirmBtnTap: () async {
                            await contactsRepository
                                .deleteContact(contact.objectId);
                            if (mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  CustomRoute(
                                      builder: (BuildContext bc) =>
                                          const HomePage()));
                            }
                          },
                          type: CoolAlertType.confirm);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "delete",
                            style: TextStyle(
                                fontSize: 20,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                          ).tr(),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.delete,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
