import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nama: ${user?.name ?? "-"}'),
          Text('Username: ${user?.username ?? "-"}'),
          Text('Email: ${user?.email ?? "-"}'),
        ],
      ),
    );
  }
}
