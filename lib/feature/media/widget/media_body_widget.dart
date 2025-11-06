import 'package:flutter/material.dart';

import '../../../core/style/text_style.dart';

class MediaBodyWidget extends StatelessWidget {
  const MediaBodyWidget({super.key, this.image, this.text, required this.onTap});

  final String? image;
  final String? text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155.5,
        height: 206,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey, // Gray color
            width: 1.0,         // 1px border
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFDEE8FC),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: SizedBox(
                    height: 32.58,
                    width: 21.24 ,
                    child: Image.asset("$image"),
                  ),
              ),
            )
                ),
            const SizedBox(height: 10),
            Text( "$text",style: globalHeadingTextStyle(),),
          ],
        )
      ),
    );
  }
}
