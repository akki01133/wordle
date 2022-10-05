import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/data/firebase/firebase_auth.dart';

import '../../../utils/values/enums.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Selector<AuthProvider, AuthStatus>(
        builder: (_,authStatus, child)=> authStatus == AuthStatus.loggedIn ? loggedInDrawer(context) : anonymousDrawer(context) ,
      selector: (_, provider)=> provider.authStatus,),
    );
  }

  Widget buildHeader(BuildContext context) {
      return Container(
          height: 200,
          color: Colors.red,
      );
  }

  buildMenuItems(BuildContext context) {
      final auth = Provider.of<AuthProvider>(context,listen: false);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            buildMenuItem(icon: Icons.person, title: auth.user.displayName ?? 'google user',),
            buildMenuItem(icon: Icons.edit_note_outlined, title: 'create challenge'),
            buildMenuItem(icon: Icons.logout, title: 'logout', onTap: auth.signOut)
        ],
      );
  }


  buildMenuItem({required IconData icon, required String title, VoidCallback? onTap}){
    return SizedBox(
      height: 60,
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: SizedBox(
              width: 30,
              child: IconButton(onPressed: (){}, icon: Icon(icon),)),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  loggedInDrawer(context) {
    return Column(
      children: [
        buildHeader(context),
        buildMenuItems(context),
      ],
    );
  }

  anonymousDrawer(context) {
    return Center(
      child: TextButton(
        onPressed: (){Navigator.of(context).pop(); Provider.of<AuthProvider>(context,listen: false).signInWithGoogle();},
        child: Text('sign in with google'),
      ),
    );
  }

}
