import 'package:flutter/material.dart';
import 'package:foodapp_new/main.dart';
import 'package:foodapp_new/model/meals.dart';
import 'package:foodapp_new/spref.dart';
import 'package:foodapp_new/view/bookmark.dart';
import 'package:foodapp_new/view/detail_makanan.dart';
import 'package:foodapp_new/view/profile.dart';
import 'package:foodapp_new/view_model/fetch_meals.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

var category = ["All", "Breakfast", "Lunch", "Dinner"];
var selectedCategory = 0;

class HomeScreen extends StatefulWidget {
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Makanan> detailMakanan = [];
  Repository repo = Repository();
  bool tema = false;
  late Future<List<Meals>> futureData;
  late List<bool> isBookmarkClickedList;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() async {
    setState(() {
      // Baca preferensi tema, atau gunakan tema default jika tidak ada preferensi yang disimpan
      tema = SharedPref.pref?.getBool('tema') ?? false;
    });
  }

  // Metode untuk menyimpan preferensi tema ke SharedPreferences
  void saveTheme(bool newTheme) async {
    SharedPref.pref?.setBool('tema', newTheme);
    setState(() {
      tema = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.greenAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
              break;
            case 1:
              // Navigasi ke halaman ProfilePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Bookmark(),
                ),
              );
              break;
            case 2:
              // Navigasi ke halaman ProfilePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
              break;
          }
        },
        currentIndex: 0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfffF0F6F4),
      body: SingleChildScrollView(
        child: SafeArea(
            // width: double.infinity,
            // height: double.infinity,
            child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            greetings(),
            const SizedBox(
              height: 24,
            ),
            searchBar(),
            const SizedBox(
              height: 24,
            ),
            banner(),
            const SizedBox(
              height: 20,
            ),
            // categories(),
            // const SizedBox(
            //   height: 16,
            // ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quick & Easy',
                          style: GoogleFonts.manrope(
                              fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                        future: repo.fetchData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<bool> isBookmarkClickedList =
                                List.filled(snapshot.data!.length, false);
                            return ListView.builder(
                                // itemCount: snapshot.data!.length,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var meal = snapshot.data![index];
                                  // print(meal.strMeal);
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isBookmarkClickedList[index] =
                                              !isBookmarkClickedList[index];
                                        });
                                        print('Bookmark Clicked');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return DetailMakanan(food: meal);
                                          },
                                        ));
                                      },
                                      child: Container(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade200,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          meal.strMealThumb)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: 260,
                                                  // height: 50,
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 10),
                                                  child: Text(
                                                    meal.strMeal,
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget greetings() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What are you\ncooking today?',
              style: GoogleFonts.manrope(
                  fontSize: 28, fontWeight: FontWeight.w800),
            ),
            Container(
              // padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: IconButton(
                  onPressed: () {
                    saveTheme(!tema);
                  },
                  icon: Icon(
                    tema ? FeatherIcons.sun : FeatherIcons.moon,
                    size: 20,
                  )),
            )
          ],
        ),
      );
}

Widget searchBar() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: const Icon(
              FeatherIcons.search,
              color: Color(0xfffb1b1b1),
            ),
            border: InputBorder.none,
            hintText: "Search any recipe...",
            hintStyle: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xfffB1B1B1),
                height: 170 / 100)),
      ),
    );

Widget banner() => AspectRatio(
      aspectRatio: 345 / 170,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xfffA7DC63),
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/logo/banner.png',
              height: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cook the best\nrecipes at home',
                      style: GoogleFonts.manrope(
                          height: 150 / 100,
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        'Explore',
                        style: GoogleFonts.manrope(
                            color: const Color(0xfff7CBA2C),
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget categories() => Align(
      alignment: AlignmentDirectional.topStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Categories',
              style: GoogleFonts.manrope(
                  fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 36,
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                          color: selectedCategory == index
                              ? const Color(0xfff52AA0C)
                              : const Color(0xfffFFFFF),
                          borderRadius: BorderRadius.circular(24)),
                      child: Center(
                          child: Text(
                        category[index],
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            color: selectedCategory == index
                                ? const Color(0xfffFFFFF)
                                : const Color(0xfff868686).withOpacity(.5)),
                      )),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                itemCount: category.length),
          )
        ],
      ),
    );