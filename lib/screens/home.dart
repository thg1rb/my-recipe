import 'package:flutter/material.dart';
import 'package:my_recipe/widgets/home/home_category_list.dart';
import 'package:my_recipe/widgets/home/home_recipe_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: Icon(Icons.add_rounded, size: 35),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              HomeHeader(username: "kkerdsiri_", profileUrl: ""),
              HomeSearchBar(),
              HomeCategoryList(),
              HomeRecipeList(title: "แนะนำสำหรับคุณ"),
              HomeRecipeList(title: "Like มากที่สุด"),
              HomeRecipeList(title: "มีวิดีโอให้ดู"),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Header
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.username,
    required this.profileUrl,
  });

  final String username;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Header Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "สวัสดี, $username",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "วันนี้คุณอยากทำเมนูอะไร?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        // Header Profile Image
        // Image.network(profileUrl),
        ClipOval(
          // Circle profile image
          child: Image.asset(
            "assets/images/default-profile.jpg",
            width: 65,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

// Home Search Bar
class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController searchBarController = TextEditingController();

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: searchBarController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณาระบุสูตรอาหารที่ต้องการ";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search_rounded),
                prefixIconColor: Theme.of(context).colorScheme.onSurface,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print(searchBarController.text);
              }
            },
            child: Text("ค้นหา"),
          ),
        ],
      ),
    );
  }
}
