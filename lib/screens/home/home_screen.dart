import 'package:e_commerce_app/screens/home/profile_screen.dart';
import 'package:e_commerce_app/screens/home/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/home/home_bloc.dart';
import '../../services/auth_service.dart';
import 'app_drawer.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'home_page_content.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _pages = [
    HomePageContent(),
    FavoriteScreen(),
    SearchScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text("E-Commerce App"), actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  icon: Icon(Icons.shopping_cart)),
            ]),
            drawer: AppDrawer(
                email: AuthService().getCurrentUserEmail() ?? "Guest"),
            body: _pages[state.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(HomeTabChanged(index));
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, color: Colors.grey),
                    label: "Wishlist"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: Colors.grey),
                    label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: Colors.grey),
                    label: "Account"),
                //BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, color: Colors.grey), label: "Cart"),
              ],
            ),
          );
        },
      ),
    );
  }
}
