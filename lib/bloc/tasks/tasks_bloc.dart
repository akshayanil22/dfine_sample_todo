import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dfine_todo/models/task_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TaskBloc extends Bloc<TasksEvent, TasksState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  TaskBloc() : super(TaskInitial()) {
    on<AddTaskEvent>(_handleTasks);
    on<UpdateTaskEvent>(_updateTasks);
    on<ListTaskEvent>(_listTasks);
  }

  Future<void> _handleTasks(AddTaskEvent event, Emitter<TasksState> emit) async {
    try {
      final credential = _auth.currentUser;

      if (credential == null) {
        emit(TaskError(message: "User not authenticated."));
        return;
      }

      // Current state must be ListCategory to proceed
      if (state is! ListTasks) return;

      final currentState = state as ListTasks;
      final currentTasks = currentState.tasks;

      // Optimistically add the new category to the local state
      final newTask = TaskModel(
        task: event.task,
        isCompleted: event.isCompleted
      );

      final updatedTasks = List<TaskModel>.from(currentTasks)
        ..add(newTask);

      // Emit the new state immediately
      emit(ListTasks(tasks: updatedTasks));

      // FireStore reference
      final userDoc = _fireStore.collection("users").doc(credential.uid);
      final categoryDoc = userDoc.collection('categories').doc(event.categoryTitle);
      final tasksCollection = categoryDoc.collection('tasks');

      // Perform the FireStore update in the background
      await tasksCollection.doc(event.task).set({
        "isCompleted": event.isCompleted,
      });

      // Fetch the latest categories from FireStore for consistency
      final result = await categoryDoc.collection('tasks').get();
      final tasksFromFireStore = result.docs.map((doc) {
        return TaskModel(
          task: doc.id,
          isCompleted: doc.get('isCompleted'),
        );
      }).toList();

      // Update the state with the latest categories from FireStore
      emit(ListTasks(tasks: tasksFromFireStore));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _updateTasks(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    try {
      final credential = _auth.currentUser;

      if (credential == null) {
        emit(TaskError(message: "User not authenticated."));
        return;
      }

      // Current state must be ListTasks to proceed
      if (state is! ListTasks) return;

      final currentState = state as ListTasks;

      // Optimistically update the task in the local state
      final updatedTasks = currentState.tasks.map((task) {
        if (task.task == event.task) {
          return TaskModel(task: task.task, isCompleted: event.isCompleted);
        }
        return task;
      }).toList();

      // Emit the new state immediately
      emit(ListTasks(tasks: updatedTasks));

      // FireStore references
      final userDoc = _fireStore.collection("users").doc(credential.uid);
      final categoryDoc = userDoc.collection('categories').doc(event.categoryTitle);
      final tasksCollection = categoryDoc.collection('tasks');

      // Perform the FireStore update in the background
      await tasksCollection.doc(event.task).set({
        "isCompleted": event.isCompleted,
      });

      log("Task updated successfully in FireStore.");
    } catch (e) {
      log("Error updating task: $e");
      emit(TaskError(message: e.toString()));

      // Optional: Revert the optimistic update if the FireStore operation fails
      if (state is ListTasks) {
        final currentState = state as ListTasks;
        final revertedTasks = currentState.tasks.map((task) {
          if (task.task == event.task) {
            return TaskModel(task: task.task, isCompleted: !event.isCompleted);
          }
          return task;
        }).toList();
        emit(ListTasks(tasks: revertedTasks));
      }
    }
  }



  Future<void> _listTasks(ListTaskEvent event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    try {
      final credential = _auth.currentUser;

      if (credential == null) {
        emit(TaskError(message: "User not authenticated."));
        return;
      }

      // Fetch tasks from FireStore
      final result = await _fireStore
          .collection("users")
          .doc(credential.uid)
          .collection('categories')
          .doc(event.categoryName)
          .collection('tasks')
          .get();

      // Map FireStore results to a list of TaskModel
      final tasks = result.docs.map((doc) {
        return TaskModel(
          task: doc.id,
          isCompleted: doc.get('isCompleted'),
        );
      }).toList();

      emit(ListTasks(tasks: tasks));
    } catch (e) {
      log("Error fetching tasks: $e");
      emit(TaskError(message: e.toString()));
    }
  }


}