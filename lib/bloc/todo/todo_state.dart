part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final String category;
  TodoLoaded({required this.category});
}

class ListCategory extends TodoState {
  final List<CategoryModel> category;
  ListCategory({required this.category});
}

class TodoError extends TodoState {
  final String message;
  TodoError({required this.message});
}
