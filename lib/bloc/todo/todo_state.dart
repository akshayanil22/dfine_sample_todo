part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final String category;

  const TodoLoaded({required this.category});

  @override
  List<Object> get props => [category]; // Include `category` in equality checks
}

class ListCategory extends TodoState {
  final List<CategoryModel> categories; // Renamed for clarity

  const ListCategory({required this.categories});

  @override
  List<Object> get props => [categories]; // Include `categories` in equality checks
}

class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object> get props => [message]; // Include `message` in equality checks
}
