import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../features/authentication/presentation/screens/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return state is Authenticated
                    ? Row(
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            maxRadius: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.userDetails.email,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
                              ),
                              Text(state.userDetails.fullName),
                            ],
                          ),
                          Spacer(),
                          IconButton.filled(
                              onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 30,
                          ),
                          Column(
                            children: [
                              Text('UserName'),
                              Text('UserName'),
                            ],
                          )
                        ],
                      );
              },
            ),
            Text(
                'Hi! My name is Malak, I\'m a Community manager from Rabat, Morocco'),
            Row(
              spacing: 10,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                Text('Notifications'),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                Text('General'),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.person)),
                Text('Account'),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.info_rounded)),
                Text('About'),
              ],
            ),
            GestureDetector(
              onTap: () =>
                  BlocProvider.of<ThemeBloc>(context).add(ToggleTheme()),
              child: Row(
                spacing: 10,
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<ThemeBloc>(context).add(ToggleTheme());
                      },
                      icon: Icon(Icons.brightness_6)),
                  Text('Switch Theme'),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Row(
                spacing: 10,
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(SignOutRequested());
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      icon: Icon(Icons.logout)),
                  Text('Log Out'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
