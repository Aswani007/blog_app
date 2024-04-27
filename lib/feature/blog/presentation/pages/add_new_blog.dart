import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/global_constant/global_constant.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final formKey = GlobalKey<FormState>();
  final titleControllerTxt = TextEditingController();
  final contentControllerTxt = TextEditingController();
  File? file;

  @override
  void dispose() {
    titleControllerTxt.dispose();
    contentControllerTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<BlogBloc>().blogSuccess = BlogSuccess(
        professionList: [], pickedFile: null, shouldNavigate: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Blog"),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final posterId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id;
                context.read<BlogBloc>().add(BlogUploadE(
                      content: contentControllerTxt.text.trim(),
                      posterId: posterId,
                      title: titleControllerTxt.text.trim(),
                    ));
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            //error
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess && state.shouldNavigate!) {
            //navigate on Success
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    BlocBuilder<BlogBloc, BlogState>(
                      builder: (context, state) {
                        return state is BlogSuccess && state.pickedFile != null
                            ? GestureDetector(
                                onTap: () => context
                                    .read<BlogBloc>()
                                    .add(PickImageFromGalleryEvent()),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        state.pickedFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              )
                            : GestureDetector(
                                onTap: () => context
                                    .read<BlogBloc>()
                                    .add(PickImageFromGalleryEvent()),
                                child: DottedBorder(
                                    color: AppPallete.borderColor,
                                    dashPattern: const [10, 4],
                                    strokeWidth: 3,
                                    radius: const Radius.circular(20),
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: const SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.folder_open,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Pick Image from Gallery",
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: BlocBuilder<BlogBloc, BlogState>(
                          buildWhen: (previous, current) =>
                              current is BlogSuccess,
                          builder: (context, state) {
                            if (state is BlogLoading) {
                              return const SizedBox();
                            }
                            return Row(
                              children: GlobalConstant.blogProfessionType
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () => context
                                            .read<BlogBloc>()
                                            .add(AddItemToListEvent(
                                                itemName: e)),
                                        child: Chip(
                                          label: Text(e),
                                          color: state is BlogSuccess &&
                                                  state.professionList!
                                                      .contains(e)
                                              ? const MaterialStatePropertyAll(
                                                  AppPallete.gradient1)
                                              : null,
                                          side: const BorderSide(
                                              color: AppPallete.borderColor),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        )),
                    const SizedBox(height: 10),
                    BlogEditor(
                        textEditingController: titleControllerTxt,
                        hintText: "Blog Title"),
                    const SizedBox(height: 14),
                    BlogEditor(
                        textEditingController: contentControllerTxt,
                        hintText: "Blog Content"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
