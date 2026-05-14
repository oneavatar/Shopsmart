import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/core/theme/bloc/theme_bloc.dart';
import 'package:shopsmart/core/theme/bloc/theme_event.dart';
import 'package:shopsmart/core/theme/bloc/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return SwitchListTile(
                title: Text('Dark Mode'),
                value: themeState.isDarkMode,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
