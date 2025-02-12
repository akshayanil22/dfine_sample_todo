import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dfine_todo/models/category_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoBloc() : super(TodoInitial()) {
    on<AddCategoryEvent>(_handleCategory);
    on<ListCategoryEvent>(_listCategory);
  }


  Future<void> _handleCategory(AddCategoryEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      var credential = _auth.currentUser;
      List<CategoryModel> category = [];
      if (credential != null) {
        await _firestore.collection("users").doc(credential.uid).collection(
            'categories').doc(event.categoryTitle).set({
          "categoryIcon": event.categoryIcon,
          "taskCount": event.taskCount,
        }).then((value) async {
          var result = await _firestore.collection("users").doc(credential.uid).collection(
              'categories').get();



          for(var i in result.docs){
            log(i.id);
            log(i.get('categoryIcon'));
            category.add(CategoryModel(title: i.id, icon: i.get('categoryIcon'), taskCount: '${i.get('taskCount')} tasks'));
          }
        },);
        emit(ListCategory(category: category));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _listCategory(ListCategoryEvent event, Emitter<TodoState> emit) async {
    print('hai');
    emit(TodoLoading());
    try {
      var credential = _auth.currentUser;
      if (credential != null) {
        var result = await _firestore.collection("users").doc(credential.uid).collection(
            'categories').get();

        List<CategoryModel> category = [];

        for(var i in result.docs){
          log(i.id);
          log(i.get('categoryIcon'));
          category.add(CategoryModel(title: i.id, icon: i.get('categoryIcon'), taskCount: '${i.get('taskCount')} tasks'));
        }

        emit(ListCategory(category: category));
      }
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

}