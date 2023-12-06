import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/text_helper.dart';
import '../../style_variables.dart';
import 'ability_details_sheet.dart';

AppBar detailsAppBar({required String name, required int id}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(capitalizeFirstLetter(name),
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ),
    ),
    actions: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Text(
              formatNumber(id),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget detailHeaderConstructor({
  required String title,
  required String type,
  EdgeInsets? padding
}) {
  return Container(
    padding: padding ?? const EdgeInsets.all(20.0),
    child: Text(
        title,
        style: headingTextStyle(type)
    ),
  );
}

Widget typeGradient(Color primaryColor, Color secondaryColor) {
  return Positioned(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    ),
  );
}

Widget pokeballDecoration(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    height: 350,
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'lib/resources/pokeball.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.contain,
            opacity: const AlwaysStoppedAnimation(0.5),
            colorBlendMode: BlendMode.srcOver,
          ),
        ]
    ),
  );
}

Widget aboutInfoItem({
  String? imgSource,
  required String value,
  required String unit,
  required String text,
  Icon? icon,


}) {  return Expanded(
    child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                if (imgSource != null)
                SvgPicture.asset(
                  imgSource,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
                ),

                if (icon != null)
                icon,

                const SizedBox(width: 10),
                Text(' $value $unit',
                  style: softerTextStyle(),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(color: Colors.grey[400]),
              )
            )
          ],
        )
    ),
  );
}

Widget aboutInfo({required String weight, required String height, int? gen}) {
  return Row(
    children: [

      aboutInfoItem(
        imgSource: 'lib/resources/weight.svg',
        value: weight,
        unit: 'kg',
        text: 'Weight'
      ),

      Container(
        width: 1,
        height: 70,
        color: Colors.grey[200],
      ),

      aboutInfoItem(
          imgSource: 'lib/resources/ruler.svg',
          value: height,
          unit: 'm',
          text: 'Height'
      ),

      if (gen != null)
      Container(
        width: 1,
        height: 70,
        color: Colors.grey[200],
      ),

      if (gen != null)
        aboutInfoItem(
            icon: Icon(Icons.gamepad_outlined,
              color: Colors.grey[600],
              size: 22,
            ),
            value: "Gen",
            unit: gen.toString(),
            text: 'Generation'
        ),
    ],
  );
}

Widget pokemonAbility({required String name, required String ability, required String url, required Color typeColor, required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return AbilityDetailsSheet(name: name, url: url, ability: ability, typeColor: typeColor);
        },
      );
    },
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: typeColor,
          width: 1,
        ),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ability,
            style: softerTextStyle(),
          ),
          Icon(
            Icons.info_outline,
            color: Colors.grey[400],
          ),
        ],
      ),
    ),
  );
}

Widget pokemonHiddenAbility({required String name, required String ability, required String url, required Color typeColor, required BuildContext context}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: pokemonAbility(name: name, ability: ability, url: url, typeColor: typeColor, context: context)
      ),
      Expanded(
        child: Container(
          height: 45,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: typeColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Hidden",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget evolutionSheetPlaceholder({required Color color}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
          ),
        ),
        Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16)
                        )
                    ),
                  ),
                )
              ],
            )
        ),
      ],
    ),
  );
}

Widget moveSheetPlaceholder({required Color color}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 10, 5),
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        width: double.infinity,
                      )
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(10, 20, 20, 5),
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Type',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: softerTextStyle()
                      ),
                    ),
                    Expanded(
                      child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: softerTextStyle()
                      ),
                    ),
                    Expanded(
                      child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: softerTextStyle()
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Power',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Accuracy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'PP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          height: 65,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(16)
                              )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        )
      ],
    ),
  );
}