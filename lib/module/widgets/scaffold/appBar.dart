import 'package:flutter/material.dart';

import '../../../helpers/utility.dart';
import '../../../utils/theme/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../buttons/iconButton.dart';

class WordleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openStatistics;
  const WordleAppBar({Key? key,required this.openStatistics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Text(
        'Wordle',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 22,
          color: AppColors.black,
        ),
      ),
      elevation: 0,
      centerTitle: true,
      // leading: CircularMaterialButton(onPress: () => Scaffold.of(context).openDrawer(), icon: Icons.house_rounded),
      leading: kIsWeb? CircularMaterialButton(onPress: ()async {await Utility.shareWebsiteUrl();}, icon: Icons.share):null,
      actions: [CircularMaterialButton(onPress: openStatistics, icon: Icons.more_vert)],
    );
  }


  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(48);
}
