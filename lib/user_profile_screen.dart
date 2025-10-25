import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// State Management with Cubit
class UserProfileState {
  final String avatarUrl;
  final String name;
  final String email;
  final String phone;
  final bool notificationsEnabled;
  final List<String> activityHistory;
  final bool isEditing;

  UserProfileState({
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.phone,
    required this.notificationsEnabled,
    required this.activityHistory,
    this.isEditing = false,
  });

  UserProfileState copyWith({
    String? avatarUrl,
    String? name,
    String? email,
    String? phone,
    bool? notificationsEnabled,
    List<String>? activityHistory,
    bool? isEditing,
  }) {
    return UserProfileState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      activityHistory: activityHistory ?? this.activityHistory,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit()
      : super(UserProfileState(
          avatarUrl: 'https://via.placeholder.com/150',
          name: 'John Doe',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          notificationsEnabled: true,
          activityHistory: ['Logged in', 'Updated profile', 'Changed password'],
        ));

  void toggleEditing() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  void updateName(String newName) {
    emit(state.copyWith(name: newName));
  }

  void updateEmail(String newEmail) {
    emit(state.copyWith(email: newEmail));
  }

  void updatePhone(String newPhone) {
    emit(state.copyWith(phone: newPhone));
  }

  void toggleNotifications() {
    emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
  }

  // For demonstration, we just add a new entry to activity history
  void addActivity(String activity) {
    final updatedHistory = List<String>.from(state.activityHistory)..insert(0, activity);
    emit(state.copyWith(activityHistory: updatedHistory));
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          actions: [
            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(state.isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (state.isEditing) {
                      // Save changes logic can be added here
                      context.read<UserProfileCubit>().addActivity('Profile updated');
                    }
                    context.read<UserProfileCubit>().toggleEditing();
                  },
                );
              },
            )
          ],
        ),
        body: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(state.avatarUrl),
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(height: 20),

                  // Name
                  state.isEditing
                      ? TextFormField(
                          initialValue: state.name,
                          decoration: InputDecoration(labelText: 'Name'),
                          onChanged: (val) => context.read<UserProfileCubit>().updateName(val),
                        )
                      : Text(state.name, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 12),

                  // Email
                  state.isEditing
                      ? TextFormField(
                          initialValue: state.email,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => context.read<UserProfileCubit>().updateEmail(val),
                        )
                      : Text('Email: ${state.email}', style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(height: 12),

                  // Phone
                  state.isEditing
                      ? TextFormField(
                          initialValue: state.phone,
                          decoration: InputDecoration(labelText: 'Phone'),
                          keyboardType: TextInputType.phone,
                          onChanged: (val) => context.read<UserProfileCubit>().updatePhone(val),
                        )
                      : Text('Phone: ${state.phone}', style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(height: 20),

                  // Notification toggle
                  SwitchListTile(
                    title: Text('Enable Notifications'),
                    value: state.notificationsEnabled,
                    onChanged: (val) => context.read<UserProfileCubit>().toggleNotifications(),
                  ),

                  SizedBox(height: 20),

                  // Activity History
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Activity History', style: Theme.of(context).textTheme.subtitle1),
                  ),
                  SizedBox(height: 8),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.activityHistory.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.activityHistory[index]),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
