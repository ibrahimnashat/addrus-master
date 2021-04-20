import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/data/models/responses/course_data_response.dart';
import 'package:adrus/ui/screens/course_preview_screen.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';

class HorizontalVideoList extends StatelessWidget {
  final List<CourseData> data;
  final String blockType;
  final Function returnedBack;

  HorizontalVideoList(
      {@required this.data,
      @required this.blockType,
      @required this.returnedBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppStyles.paddingAll(1, 0, 1, 1),
      height: 26 * SizeConfig.heightMultiplier,
      child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CoursePreviewScreen(
                            blockType: this.blockType,
                            courseData: data[index],
                          ),
                        ),
                      )
                      .then((value) => this.returnedBack());
                },
                child: Container(
                  width: 25 * SizeConfig.heightMultiplier,
                  // height: 20 * SizeConfig.heightMultiplier,
                  margin: AppStyles.paddingSymmetric(0.5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.5 * SizeConfig.heightMultiplier),
                        ),
                        child: Container(
                            color: Colors.black12,
                          child: Image.network(
                            data[index].image,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 14 * SizeConfig.heightMultiplier,
                          ),
                        ),
                      ),
                      Container(
                        padding: AppStyles.paddingSymmetric(1, 1),
                        child: Text(
                          data[index].title ?? "",
                          textAlign: TextAlign.right,
                          style: AppTextStyles.textStyle(
                              13, Colors.white, FontWeight.w600, null, 1.3),
                        ),
                      )
                    ],
                  ),
                ));
          }),
    );
  }
}
