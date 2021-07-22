import 'package:compare_prices/ui/assets/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../route.dart';

class OtherPage extends HookWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.commonOther),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(AppLocalizations.of(context)!.otherDataList),
            _listItem(
              AppLocalizations.of(context)!.commonCommodityList,
              () => Navigator.of(context)
                  .pushNamed(RouteName.selectCommodityPage, arguments: {
                ArgumentName.title:
                    AppLocalizations.of(context)!.commonCommodityList,
                ArgumentName.isSelectable: false,
                ArgumentName.isFullscreenDialog: false
              }),
            ),
            _listItem(
              AppLocalizations.of(context)!.commonShopList,
              () => Navigator.of(context)
                  .pushNamed(RouteName.selectShopPage, arguments: {
                ArgumentName.title:
                    AppLocalizations.of(context)!.commonShopList,
                ArgumentName.isSelectable: false,
                ArgumentName.isFullscreenDialog: false
              }),
            ),
            _section(AppLocalizations.of(context)!.otherAboutApp),
            _listItem(
              AppLocalizations.of(context)!.commonLicense,
              () => showLicensePage(
                  context: context,
                  // TODO アプリ名・アイコン
                  applicationName: AppLocalizations.of(context)!.appName,
                  applicationIcon: Icon(Icons.list)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _listItem(String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
      ),
      onTap: onTap,
    );
  }
}
