import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:contacts/model/contact/contact_model.dart';
import 'package:contacts/pages/home_page.dart';
import 'package:contacts/repositories/back4app/contacts_back4app.dart';
import 'package:contacts/widgets/shared/show_snackback_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  var contactsRepository = ContactsBack4AppRepository();
  var countryController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var nameController = TextEditingController();
  var cityController = TextEditingController();
  var instagramController = TextEditingController();
  var linkednController = TextEditingController();
  var emailController = TextEditingController();
  var loading = false;
  XFile? photo;

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueGrey,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('add_contact').tr(),
      ),
      body: loading
          ? Center(
              child: Lottie.asset('assets/lotties/loader.json'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  SizedBox(
                    height: 220,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (_) {
                              return DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) =>
                                    Wrap(children: [
                                  ListTile(
                                    leading:
                                        const FaIcon(FontAwesomeIcons.camera),
                                    title: const Text("Camera"),
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      photo = await picker.pickImage(
                                          source: ImageSource.camera);
                                      if (photo != null) {
                                        cropImage(photo!);
                                      }
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const FaIcon(
                                        FontAwesomeIcons.photoFilm),
                                    title: const Text('gallery').tr(),
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      photo = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (photo != null) {
                                        cropImage(photo!);
                                      }
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                ]),
                              );
                            });
                      },
                      child: photo != null
                          ? Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: FileImage(File(photo!.path)))))
                          : Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                          "assets/images/default_profile_image.png"))),
                            ),
                      // child: CircleAvatar(
                      //     foregroundImage: photo != null
                      //         ? FileImage(scale: 5, File(photo!.path))
                      //         : null,
                      //     backgroundImage: const AssetImage(
                      //         "assets/images/default_profile_image.png")),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: tr('country_code'),
                        suffixIcon: const Icon(Icons.location_searching),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: countryController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: tr('DDD_n_phone'),
                        suffixIcon: const Icon(Icons.phone_android),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: phoneNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: tr('name'),
                        suffixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: tr('city'),
                        suffixIcon: const Icon(Icons.location_city),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: cityController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: "Instagram",
                        suffixIcon: FaIcon(FontAwesomeIcons.instagram),
                        suffixIconConstraints:
                            BoxConstraints.tightFor(width: 35),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: instagramController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: "Linkedn",
                        suffixIcon: FaIcon(FontAwesomeIcons.linkedin),
                        suffixIconConstraints:
                            BoxConstraints.tightFor(width: 35),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: linkednController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: "Email",
                        suffixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).secondaryHeaderColor)),
                      onPressed: () async {
                        if (countryController.text.trim() == "") {
                          showWarningSnackBar(
                              context, tr('warning_country_code'));
                          return;
                        }
                        if (phoneNumberController.text.trim() == "") {
                          showWarningSnackBar(
                              context, tr('warning_phone_number'));
                          return;
                        }
                        if (phoneNumberController.text.length < 14) {
                          showWarningSnackBar(
                              context, tr('warning_valid_phone_number'));
                          return;
                        }
                        if (nameController.text.trim() == "") {
                          showWarningSnackBar(context, tr('warning_name'));
                          return;
                        }
                        if (cityController.text.trim() == "") {
                          showWarningSnackBar(context, tr('warning_city'));
                          return;
                        }
                        if (emailController.text.trim() == "") {
                          showWarningSnackBar(context, tr('warning_email'));
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        await contactsRepository.createContact(
                            ContactModel.create(
                                nameController.text,
                                phoneNumberController.text,
                                countryController.text,
                                false,
                                cityController.text,
                                instagramController.text,
                                linkednController.text,
                                photo?.path ?? "",
                                emailController.text));
                        setState(() {
                          loading = false;
                        });
                        if (mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext bc) =>
                                      const HomePage()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "add_contact",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ).tr(),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
