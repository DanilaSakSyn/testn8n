import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Состояния для ключевых возможностей
abstract class FeaturesState {}

class FeaturesInitial extends FeaturesState {}
class FeaturesLoadInProgress extends FeaturesState {}
class FeaturesLoadSuccess extends FeaturesState {
  final List<String> features;
  FeaturesLoadSuccess(this.features);
}
class FeaturesLoadFailure extends FeaturesState {
  final String errorMessage;
  FeaturesLoadFailure(this.errorMessage);
}

// Cubit для управления состоянием ключевых возможностей
class FeaturesCubit extends Cubit<FeaturesState> {
  FeaturesCubit() : super(FeaturesInitial());

  // Имитация загрузки данных
  Future<void> loadFeatures() async {
    emit(FeaturesLoadInProgress());
    await Future.delayed(Duration(seconds: 1)); // эмуляция задержки
    try {
      // Здесь можно загружать данные из API или БД
      final List<String> loadedFeatures = [
        'Задачи',
        'Каталог товаров',
        'Инструменты взаимодействия',
      ];
      emit(FeaturesLoadSuccess(loadedFeatures));
    } catch (e) {
      emit(FeaturesLoadFailure('Ошибка загрузки ключевых возможностей'));
    }
  }
}

// Экран ключевых возможностей с адаптивным дизайном
class FeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeaturesCubit()..loadFeatures(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ключевые возможности'),
        ),
        body: BlocBuilder<FeaturesCubit, FeaturesState>(
          builder: (context, state) {
            if (state is FeaturesLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeaturesLoadSuccess) {
              final features = state.features;
              if (features.isEmpty) {
                return const Center(child: Text('Нет доступных возможностей'));
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3,
                    ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return Card(
                        elevation: 2,
                        child: Center(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is FeaturesLoadFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
