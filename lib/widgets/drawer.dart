import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../confi/NavigationServices.dart';
import '../confi/routes/routesname.dart';
import '../viewmodel/auth_viewmodel.dart';


class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // User Info
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "Guest User"),
            accountEmail: Text(user?.email ?? "No Email"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),

          // Navigation to History Page

          const Spacer(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              await authVM.signOut(); // Call logout in ViewModel
              NavigatorServices.GoTo(
                  RoutesName.login_route); // Redirect to login
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
