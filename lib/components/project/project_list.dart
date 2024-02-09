import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../config/language.dart';
import '../common/image/image_network.dart';
import '../common/text/text.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function()? onTap;

  const ProjectCard({
    Key? key,
    required this.project,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: ImageNetwork(
                  project.imgSource,
                  fit: BoxFit.cover,
                  height: 75,
                  radius: 5,
                ),
              ),
              CustomText(
                project.name,
                color: AppColor.red,
                fontSize: FontSize.px12,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                lineOfNumber: 3,
              ),
              if (project.location.trim() != '')
                CustomText(
                  '(${project.location})',
                  color: AppColor.red,
                  fontSize: FontSize.px9,
                  lineOfNumber: 1,
                ),
              if (project.startPrice.trim() != '')
                CustomText(
                  '${Language.translate('module.project.start_price')} ${project.startPrice}',
                  color: AppColor.blue,
                  fontSize: FontSize.px9,
                  lineOfNumber: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Project {
  final String id;
  final String location;
  final String name;
  final String imgSource;
  final String startPrice;

  Project({
    this.id = '',
    this.location = '',
    this.name = '',
    this.imgSource = '',
    this.startPrice = '',
  });
}
