import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:contacts/model/contact/contacts_model.dart';
import 'package:contacts/pages/configuration/configuration_page.dart';
import 'package:contacts/pages/contact/add_contact/add_contact_page.dart';
import 'package:contacts/pages/contact/contacts_list/contacts_list_page.dart';
import 'package:contacts/pages/favorites/favorite_contacts_list_page.dart';
import 'package:contacts/pages/search/search_delegate.dart';
import 'package:contacts/repositories/back4app/contacts_back4app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var contactsRepository = ContactsBack4AppRepository();
  var contactsModel = ContactsModel.vazio();
  var pageController = PageController(initialPage: 0);
  var _bottonNavIndex = 0;
  var darTheme = true;
  final iconList = <IconData>[
    Icons.person,
    Icons.star_outlined,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  loadContacts() async {
    try {
      contactsModel = await contactsRepository.getContacts();
    } catch (e) {
      debugPrint("Erro ao consultar banco de dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        openColor: Theme.of(context).secondaryHeaderColor,
        closedShape: const CircleBorder(),
        closedColor: Theme.of(context).secondaryHeaderColor,
        transitionDuration: const Duration(milliseconds: 900),
        openBuilder: (context, _) => const AddContactPage(),
        closedBuilder: (context, VoidCallback openContainer) =>
            FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: openContainer,
          child: const Icon(Icons.person_add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        blurEffect: true,
        iconSize: 27,
        activeColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        icons: iconList,
        activeIndex: _bottonNavIndex,
        onTap: (index) {
          setState(() {
            _bottonNavIndex = index;
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          });
        },
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.defaultEdge,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: _bottonNavIndex == 0
            ? Text(tr('contacts'))
            : _bottonNavIndex == 1
                ? const Text('favorites').tr()
                : const Text('configurations').tr(),
        actions: [
          if (_bottonNavIndex != 2)
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MySearchDelegate(contactsModel));
                },
                icon: const Icon(Icons.search))
        ],
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _bottonNavIndex = index;
          });
        },
        controller: pageController,
        children: const [
          ContactsListPage(),
          FavoriteContactsPage(),
          ConfigurationPage()
        ],
      ),
    );
  }
}
