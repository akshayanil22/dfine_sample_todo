part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddCategoryEvent extends TodoEvent {
  final String categoryTitle;
  final String categoryIcon;
  final int taskCount;
  AddCategoryEvent({required this.categoryTitle,required this.categoryIcon, required this.taskCount});
}

// class ForgotPasswordRequested extends TodoEvent {
//   final String email;
//   ForgotPasswordRequested({required this.email});
// }
//
class ListCategoryEvent extends TodoEvent {}
