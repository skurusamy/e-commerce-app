import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';
import 'cartegory_screen.dart';

class HomePageContent extends StatelessWidget {
  final List<String> carouselImages = [
    "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1679079456083-9f288e224e96?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3Ds",
    "https://images.unsplash.com/photo-1543508282-6319a3e2621f?q=80&w=3115&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(autoPlay: true, height: 200, enlargeCenterPage: true),
            items: carouselImages.map((item) {
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(item), fit: BoxFit.cover),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          BlocProvider(
            create: (context) => CategoryBloc(CategoryService())..add(LoadCategories()),
            child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (state is CategoryLoaded){
                    return  GridView.builder  (
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        Category category = state.categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => CategoryScreen(categoryName: category.name, categoryId: category.id),
                            ));
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(category.imageUrl, height: 50),
                                SizedBox(height: 8),
                                Text(category.name, style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else if (state is CategoryError) {
                    return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                  }
                  return Center(child: Text("No categories available"));
                }
            ),


          ),

        ],
      ),
    );
  }
}
