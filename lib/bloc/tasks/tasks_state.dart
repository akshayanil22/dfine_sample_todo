part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TasksState {}

class TaskLoading extends TasksState {}

class ListTasks extends TasksState {
  final List<TaskModel> tasks;

  const ListTasks({required this.tasks});

  @override
  List<Object> get props => [tasks]; // Include tasks in props for equality checks
}

class TaskError extends TasksState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message]; // Include message in props for equality checks
}
