import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States representing the data fetching and display
abstract class MainScreenState {}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenLoaded extends MainScreenState {
  final List<String> items;
  MainScreenLoaded(this.items);
}

class MainScreenError extends MainScreenState {
  final String message;
  MainScreenError(this.message);
}

// Cubit that manages the state for the main screen
class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitial());

  Future<void> loadItems() async {
    try {
      emit(MainScreenLoading());
      // Simulate network or database loading
      await Future.delayed(Duration(seconds: 2));
      final items = List<String>.generate(20, (index) => 'Item ${index + 1}');
      emit(MainScreenLoaded(items));
    } catch (e) {
      emit(MainScreenError('Failed to load items'));
    }
  }

  void clearItems() {
    emit(MainScreenInitial());
  }
}

// MainScreen widget displays list of items and a toolbar
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainScreenCubit()..loadItems(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Главный экран'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => context.read<MainScreenCubit>().loadItems(),
              tooltip: 'Обновить список',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Text('Меню Навигации', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Главная'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Настройки'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: BlocBuilder<MainScreenCubit, MainScreenState>(
          builder: (context, state) {
            if (state is MainScreenLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MainScreenLoaded) {
              return ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(state.items[index]),
                  leading: Icon(Icons.list),
                ),
              );
            } else if (state is MainScreenError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return Center(child: Text('Добро пожаловать! Нажмите обновить для загрузки списка.'));
          },
        ),
        // Simple bottom toolbar with actions
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => context.read<MainScreenCubit>().loadItems(),
                  tooltip: 'Обновить',
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => context.read<MainScreenCubit>().clearItems(),
                  tooltip: 'Очистить',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
