part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddTaskEvent extends TasksEvent {
  final String categoryTitle;
  final String task;
  final bool isCompleted;
  AddTaskEvent({required this.categoryTitle,required this.task, required this.isCompleted});
}

class UpdateTaskEvent extends TasksEvent {
  final String categoryTitle;
  final String task;
  final bool isCompleted;
  UpdateTaskEvent({required this.categoryTitle,required this.task, required this.isCompleted});
}

class ListTaskEvent extends TasksEvent {
  final String categoryName;
  ListTaskEvent({required this.categoryName});
}
