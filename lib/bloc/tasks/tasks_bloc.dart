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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskBloc() : super(TaskInitial()) {
    on<AddTaskEvent>(_handleTasks);
    on<UpdateTaskEvent>(_updateTasks);
    on<ListTaskEvent>(_listTasks);
  }

  Future<void> _handleTasks(AddTaskEvent event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    try {
      var credential = _auth.currentUser;
      List<TaskModel> tasks = [];
      if (credential != null) {
        await _firestore.collection("users").doc(credential.uid).collection(
            'categories').doc(event.categoryTitle).collection('tasks').doc(event.task).set({
          "isCompleted": event.isCompleted,
        }).then((value) async {
          var result = await _firestore.collection("users").doc(credential.uid).collection(
              'categories').doc(event.categoryTitle).collection('tasks').get();


          for(var i in result.docs){
            tasks.add(TaskModel(task: i.id, isCompleted: i.get('isCompleted')));
          }

        },);
        emit(ListTasks(tasks: tasks));
      }
    } catch (e) {
      log(e.toString());
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _updateTasks(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    try {
      var credential = _auth.currentUser;
      List<TaskModel> tasks = [];
      if (credential != null) {
        await _firestore.collection("users").doc(credential.uid).collection(
            'categories').doc(event.categoryTitle).collection('tasks').doc(event.task).set({
          "isCompleted": event.isCompleted,
        }).then((value) async {
          var result = await _firestore.collection("users").doc(credential.uid).collection(
              'categories').doc(event.categoryTitle).collection('tasks').get();

          for(var i in result.docs){
            tasks.add(TaskModel(task: i.id, isCompleted: i.get('isCompleted')));
          }

        },);
        emit(ListTasks(tasks: tasks));
      }
    } catch (e) {
      log(e.toString());
      emit(TaskError(message: e.toString()));
    }
  }



  Future<void> _listTasks(ListTaskEvent event, Emitter<TasksState> emit) async {
    emit(TaskLoading());
    try {
      var credential = _auth.currentUser;
      if (credential != null) {
        log('hehe');
        var result = await _firestore.collection("users").doc(credential.uid).collection(
            'categories').doc(event.categoryName).collection('tasks').get();
        List<TaskModel> tasks = [];

        for(var i in result.docs){
          tasks.add(TaskModel(task: i.id, isCompleted: i.get('isCompleted')));
        }

        emit(ListTasks(tasks: tasks));
      }
    } catch (e) {
      log(e.toString());
      emit(TaskError(message: e.toString()));
    }
  }


}