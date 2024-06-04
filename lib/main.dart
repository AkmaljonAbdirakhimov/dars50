import 'dart:convert';
import 'package:dars50/views/screens/weather_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dars50/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

// Todo - TAKRORLASH
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    getSavedThemeMode();
  }

  void getSavedThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final isDark = sharedPreferences.getBool("isDark");
    themeMode =
        isDark == null || isDark == true ? ThemeMode.light : ThemeMode.dark;
    setState(() {});
  }

  void toggleThemeMode() async {
    bool isDark = themeMode == ThemeMode.dark;
    themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    setState(() {});

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isDark", isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      darkTheme: ThemeData.dark(),
      home: HomeScreen(toggleThemeMode: toggleThemeMode),
    );
  }
}

// TODO - HOME SCREEN
class HomeScreen extends StatefulWidget {
  final VoidCallback toggleThemeMode;
  const HomeScreen({
    super.key,
    required this.toggleThemeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final contactsHttpService = ContactsHttpService();
  bool isLoading = false;

  void addContact() async {
    final response = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Kontakt Qo'shish"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ism va familiya",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Bekor qilish"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, nameController.text);
                },
                child: const Text("Yaratish"),
              ),
            ],
          );
        });

    if (response != null) {
      nameController.clear();
      setState(() {
        isLoading = true;
      });
      await contactsHttpService.addContact(response);
      setState(() {
        isLoading = false;
      });
    }
  }

  void editContact(String id, String fullname) async {
    nameController.text = fullname;
    final response = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Kontakt O'zgartirish"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ism va familiya",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Bekor qilish"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, nameController.text);
                },
                child: const Text("Yangilash"),
              ),
            ],
          );
        });

    if (response != null) {
      //? Kontakt o'zgaritish
      nameController.clear();
      setState(() {
        isLoading = true;
      });
      await contactsHttpService.editContact(id, response);
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteContact(String id) async {
    await contactsHttpService.deleteContact(id);
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;

  List<Widget> pages = const [
    Center(
      child: Text("Bosh Sahifa"),
    ),
    Center(
      child: Text("Profil Sahifa"),
    ),
    Center(
      child: Text("Sozlamalar Sahifa"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Kontaktlar"),
        actions: [
          IconButton(
            onPressed: addContact,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: widget.toggleThemeMode,
            icon: const Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),

            //  isLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : FutureBuilder(
            //         future: contactsHttpService.getContacts(),
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return const Center(
            //               child: CircularProgressIndicator(),
            //             );
            //           }
            //           final contacts = snapshot.data;
            //           return contacts == null || contacts.isEmpty
            //               ? const Center(
            //                   child: Text("Kontaktlar mavjud emas"),
            //                 )
            //               : ListView.builder(
            //                   padding: const EdgeInsets.all(20),
            //                   itemCount: contacts.length,
            //                   itemBuilder: (ctx, index) {
            //                     return Card(
            //                       color: Colors.primaries[Random().nextInt(17)],
            //                       margin:
            //                           const EdgeInsets.symmetric(vertical: 10),
            //                       child: ListTile(
            //                         onTap: () {
            //                           editContact(
            //                             contacts[index].id,
            //                             contacts[index].fullname,
            //                           );
            //                         },
            //                         title: Text(contacts[index].fullname),
            //                         trailing: IconButton(
            //                           onPressed: () {
            //                             deleteContact(contacts[index].id);
            //                           },
            //                           icon: const Icon(
            //                             Icons.delete,
            //                             color: Colors.red,
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 );
            //         },
            //       ),
          ),
          NavigationRail(
            backgroundColor: Colors.amber,
            onDestinationSelected: (value) {
              selectedIndex = value;
              setState(() {});
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Bosh Sahifa"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("Profil"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text("Sozlamalar"),
              ),
            ],
            selectedIndex: selectedIndex,
          ),
        ],
      ),
    );
  }
}

class ContactsHttpService {
  Future<List<Contact>> getContacts() async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/contacts.json");

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Contact> contacts = [];
    if (data != null) {
      data.forEach((key, value) {
        contacts.add(
          Contact(
            id: key,
            fullname: value['fullname'],
          ),
        );
      });
    }

    return contacts;
  }

  Future<void> addContact(String fullname) async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/contacts.json");
    final contactData = {
      "fullname": fullname,
    };
    final response = await http.post(url, body: jsonEncode(contactData));
    final data = jsonDecode(response.body);

    print(data);
  }

  Future<void> editContact(String id, String newFullname) async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/contacts/$id.json");

    final contactData = {
      "fullname": newFullname,
    };
    final response = await http.patch(url, body: jsonEncode(contactData));
    final data = jsonDecode(response.body);

    print(data);
  }

  Future<void> deleteContact(String id) async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/contacts/$id.json");

    final response = await http.delete(url);
  }
}
