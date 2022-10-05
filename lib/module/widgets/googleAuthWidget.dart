


import 'package:flutter/material.dart';
import 'package:wordle/services/data/firebase/firebase_auth.dart';

class GoogleAuthWidget extends StatelessWidget {
  final Widget child;
  const GoogleAuthWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: AuthProvider().authStateChanges,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              return child;
            }
            else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('something Went Wrong!!', style: TextStyle(color: Colors.redAccent,fontSize: 18)),
                    ElevatedButton.icon(onPressed: (){}, icon: Text('try again'), label: Icon(Icons.refresh))
                  ],
                )
              );
            }

          }
      ),
    );
  }
}
