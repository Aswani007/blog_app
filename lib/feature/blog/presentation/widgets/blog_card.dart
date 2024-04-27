import 'package:blog_app/feature/blog/domain/entities/blog.dart';
import 'package:blog_app/feature/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/calc_reading_time.dart';

class BlogCardWidget extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCardWidget({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, BlogViewerPage.route(blog)),
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(15).copyWith(bottom: 4),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: blog.topics
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(e),
                            side:
                                const BorderSide(color: AppPallete.borderColor),
                          ),
                        ),
                      )
                      .toList(),
                )),
            Text(
              blog.title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Spacer(),
            Text(
              "${calcReadingTime(blog.content)} min",
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
