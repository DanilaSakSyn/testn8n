import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit для управления состоянием навигации
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void navigateTo(int index) => emit(index);
}

// Главный экран приложения с приветственным сообщением и навигационной панелью
class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    Center(child: Text('Главная')), // Основные функции
    Center(child: Text('Новости и обновления')), // Новости и обновления
    Center(child: Text('Профиль')), // Профиль
  ];

  final List<String> _titles = [
    'Основные функции',
    'Новости',
    'Профиль',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[state]),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blueAccent,
                  child: Text(
                    'Добро пожаловать! Используйте навигацию ниже для быстрого доступа к основным функциям.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: _pages[state]),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state,
              onTap: (index) => context.read<NavigationCubit>().navigateTo(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Новости',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
