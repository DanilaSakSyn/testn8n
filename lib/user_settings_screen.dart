import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// UserSettingsState - holds the current user settings data
class UserSettingsState {
  final String username;
  final String email;
  final bool notificationsEnabled;
  final bool darkMode;

  UserSettingsState({
    required this.username,
    required this.email,
    required this.notificationsEnabled,
    required this.darkMode,
  });

  // Copy with method for immutability
  UserSettingsState copyWith({
    String? username,
    String? email,
    bool? notificationsEnabled,
    bool? darkMode,
  }) {
    return UserSettingsState(
      username: username ?? this.username,
      email: email ?? this.email,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

// UserSettingsCubit - manages the user settings state
class UserSettingsCubit extends Cubit<UserSettingsState> {
  UserSettingsCubit()
      : super(UserSettingsState(
          username: 'User',
          email: 'user@example.com',
          notificationsEnabled: true,
          darkMode: false,
        ));

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void toggleNotifications(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void toggleDarkMode(bool enabled) {
    emit(state.copyWith(darkMode: enabled));
  }
}

// UserSettingsScreen - main widget for the settings screen
class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserSettingsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Настройки пользователя'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
            builder: (context, state) {
              final cubit = context.read<UserSettingsCubit>();
              return ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Имя пользователя'),
                    controller: TextEditingController(text: state.username),
                    onChanged: cubit.updateUsername,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    controller: TextEditingController(text: state.email),
                    onChanged: cubit.updateEmail,
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Уведомления'),
                    value: state.notificationsEnabled,
                    onChanged: cubit.toggleNotifications,
                  ),
                  SwitchListTile(
                    title: Text('Темная тема'),
                    value: state.darkMode,
                    onChanged: cubit.toggleDarkMode,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

