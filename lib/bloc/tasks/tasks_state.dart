part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskInitial extends TasksState {}

class TaskLoading extends TasksState {}

class ListTasks extends TasksState {
  final List<TaskModel> tasks;
  ListTasks({required this.tasks});
}

class TaskError extends TasksState {
  final String message;
  TaskError({required this.message});
}
