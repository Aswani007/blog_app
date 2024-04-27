import 'dart:async';
import 'dart:io';

import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/pick_image.dart';
import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogSuccess blogSuccess =
      BlogSuccess(professionList: [], pickedFile: null, shouldNavigate: false);

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    // on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadE>(_onBlogUpload);
    on<BlogFetchAllBlogE>(_onBlogFetchAllBlogE);
    on<AddItemToListEvent>(_addItemToListEvent);
    on<PickImageFromGalleryEvent>(_pickImageFromGalleryEvent);
  }

  FutureOr<void> _onBlogUpload(
      BlogUploadE event, Emitter<BlogState> emit) async {
    if (blogSuccess.professionList!.isEmpty || blogSuccess.pickedFile == null) {
      emit(BlogFailure("Please Select At least one Type"));
      return;
    }
    emit(BlogLoading());
    final res = await _uploadBlog(UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: blogSuccess.pickedFile!,
        topics: blogSuccess.professionList ?? []));

    blogSuccess = blogSuccess.copyWith(shouldNavigate: true);

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(blogSuccess),
    );
    emit(blogSuccess);
  }

  //adding or removing the profession type in the list and updating the list
  FutureOr<void> _addItemToListEvent(
      AddItemToListEvent event, Emitter<BlogState> emit) {
    emit(BlogLoading());
    String name = event.itemName;
    List<String> temp = blogSuccess.professionList!;
    if (temp.contains(name)) {
      blogSuccess.professionList!.remove(name);
    } else {
      temp.add(name);
    }
    blogSuccess =
        blogSuccess.copyWith(professionList: temp, shouldNavigate: false);
    emit(blogSuccess);
  }

  //image pick
  FutureOr<void> _pickImageFromGalleryEvent(
      PickImageFromGalleryEvent event, Emitter<BlogState> emit) async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      blogSuccess = blogSuccess.copyWith(pickedFile: pickedImage);
    }
    emit(blogSuccess);
  }

  FutureOr<void> _onBlogFetchAllBlogE(
      BlogFetchAllBlogE event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _getAllBlogs(NoParams());
    res.fold((l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogDisplaySuccess(r)));
  }
}
