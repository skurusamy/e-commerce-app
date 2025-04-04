import 'package:e_commerce_app/screens/login/auth/login_with_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  final String email;
  const AppDrawer({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Sample Name'),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage("https://plus.unsplash.com/premium_vector-1683141132250-12daa3bd85cf?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWFufGVufDB8fDB8fHww")),
          ),
          ListTile(leading: Icon(Icons.shopping_bag), title: Text("Orders"), onTap: () {}),
          ListTile(leading: Icon(Icons.account_circle), title: Text("Account Details"), onTap: () {}),
          ListTile(leading: Icon(Icons.info), title: Text("About Us"), onTap: () {}),
          ListTile(leading: Icon(Icons.contact_mail), title: Text("Contact Us"), onTap: () {}),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(SignOut());
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithEmailScreen()));
            },
          ),
        ],
      ),
    );
  }
}
