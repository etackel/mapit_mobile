import 'package:flutter/material.dart';
import 'package:mapit/src/services/google_auth_service.dart';
import 'package:mapit/src/views/support/support_screen.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../settings/settings_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                           SignInService.signInWithGoogle(context);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userProvider.photoURL ?? ''),
                                radius: 24,
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150, // Set a fixed width to constrain the Text widget
                                    child: Text(
                                      userProvider.name ?? 'Abhinav Sharma',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150, // Set a fixed width to constrain the Text widget
                                    child: Text(
                                      userProvider.email ?? 'abhinavs1920bpl@gmail.com',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Support'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SupportScreen()));
                      // Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ],

          )
        ],
      ),
    );
  }
}
