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
  required String imgSource,
  required String value,
  required String unit,
  required String text,

}) {  return Expanded(
    child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imgSource,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
                ),
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

Widget aboutInfo({required String weight, required String height}) {
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
    ],
  );
}

Widget pokemonAbility({required String name, required String ability, required String url, required Color typeColor, required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: AbilityDetailsSheet(name: name, url: url, ability: ability, typeColor: typeColor)
          );
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