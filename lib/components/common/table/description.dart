import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../text/text.dart';

class Descriptions extends StatelessWidget {
  final List<List> rows;
  final double spacing;
  final String colon;
  final double fontSize;
  final List<Color> colors;
  final Function(List data)? rowBuilder;

  const Descriptions({
    Key? key,
    required this.rows,
    this.spacing = 10,
    this.colon = ':',
    this.rowBuilder,
    this.colors = const [AppColor.blue, AppColor.black2],
    this.fontSize = FontSize.px14,
  }) : super(key: key);

  // dataRow(List data) => DataRow(
  //       cells: <DataCell>[
  //         DataCell(Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             CustomText(
  //               Language.translate(data.first),
  //               color: colors.first,
  //               fontSize: fontSize,
  //             ),
  //             SizedBox(width: spacing),
  //             CustomText(
  //               colon,
  //               color: colors.first,
  //               fontSize: fontSize,
  //             ),
  //           ],
  //         )),
  //         if (data.last is String)
  //           DataCell(Container(
  //             constraints: BoxConstraints(
  //               maxHeight: double.infinity,
  //               minHeight: fontSize,
  //             ),
  //             child: CustomText(
  //               data.last == '' ? '-' : data.last,
  //               fontSize: FontSize.px14,
  //               // lineOfNumber: 2,
  //             ),
  //           )),
  //         if (data.last is! String) DataCell(data.last)
  //       ],
  //     );

  @override
  Widget build(BuildContext context) {
    // return AlignedGridView.count(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   crossAxisCount: 2,
    //   mainAxisSpacing: 4,
    //   crossAxisSpacing: spacing,
    //   itemCount: rows.length * 2,
    //   itemBuilder: (context, i) {
    //     int index = (i / 2).floor();
    //     if (i % 2 == 0) {
    //       String label = rows[index][0];
    //       return Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           CustomText(
    //             Language.translate(label),
    //             color: colors.first,
    //             fontSize: fontSize,
    //           ),
    //           SizedBox(width: spacing),
    //           CustomText(
    //             colon,
    //             color: colors.first,
    //             fontSize: fontSize,
    //           ),
    //         ],
    //       );
    //     }
    //     var value = rows[index].last;
    //     bool isString = value is String;
    //
    //     return isString
    //         ? CustomText(
    //             value == '' ? '-' : value,
    //             fontSize: FontSize.px14,
    //             // lineOfNumber: 2,
    //           )
    //         : value;
    //   },
    // );
    return Column(
      children: rows.map((e) {
        String label = e.first;
        var value = e.last;
        bool isString = e.last is String;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        Language.translate(label),
                        color: colors.first,
                        fontSize: fontSize,
                      ),
                      SizedBox(width: spacing),
                      CustomText(
                        colon,
                        color: colors.first,
                        fontSize: fontSize,
                      ),
                    ],
                  )),
              SizedBox(width: spacing),
              Flexible(
                flex: 5,
                child: isString
                    ? CustomText(
                        value == '' ? '-' : value,
                        fontSize: FontSize.px14,
                        // lineOfNumber: 2,
                      )
                    : value,
              )
            ],
          ),
        );
      }).toList(),
    );
    // return Theme(
    //   data: Theme.of(context).copyWith(dividerColor: AppColor.transparent),
    //   child: DataTable(
    //     horizontalMargin: 0,
    //     headingRowHeight: 0,
    //     dividerThickness: 0,
    //     columnSpacing: spacing,
    //     dataRowHeight: fontSize * 1.5,
    //     // dataRowMaxHeight: double.infinity,
    //     columns: rows.first.map((e) => DataColumn(label: Container())).toList(),
    //     rows: rows.map<DataRow>((data) {
    //       if (rowBuilder != null) {
    //         return rowBuilder!(data);
    //       }
    //       return dataRow(data);
    //     }).toList(),
    //   ),
    // );
  }
}
