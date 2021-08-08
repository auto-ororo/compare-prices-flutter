import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../route.dart';

class AppDrawer extends HookWidget {
  final String currentRoute;

  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 100,
            child: DrawerHeader(
              child: Text(
                AppLocalizations.of(context)!.appName,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          _DrawerListTile(
            title: AppLocalizations.of(context)!.commonBottomPrice,
            iconData: Icons.attach_money,
            currentRouteName: currentRoute,
            pushRouteName: RouteName.bottomPriceListPage,
          ),
          _DrawerListTile(
            title: AppLocalizations.of(context)!.commonHistory,
            iconData: Icons.history,
            currentRouteName: currentRoute,
            pushRouteName: RouteName.purchaseResultListPage,
          ),
          _DrawerListTile(
              title: AppLocalizations.of(context)!.commonCommodity,
              iconData: Icons.shopping_basket_outlined,
              currentRouteName: currentRoute,
              pushRouteName: RouteName.commodityListPage,
              arguments: {
                ArgumentName.title:
                    AppLocalizations.of(context)!.commonCommodityList,
                ArgumentName.isSelectable: false,
                ArgumentName.isFullscreenDialog: false
              }),
          _DrawerListTile(
              title: AppLocalizations.of(context)!.commonShop,
              iconData: Icons.storefront,
              currentRouteName: currentRoute,
              pushRouteName: RouteName.shopListPage,
              arguments: {
                ArgumentName.title:
                    AppLocalizations.of(context)!.commonShopList,
                ArgumentName.isSelectable: false,
                ArgumentName.isFullscreenDialog: false
              }),
          _DrawerListTile(
            title: AppLocalizations.of(context)!.commonLicense,
            iconData: Icons.info_outlined,
            currentRouteName: currentRoute,
            pushRouteName: RouteName.licensePage,
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    Key? key,
    required this.title,
    required this.iconData,
    required this.currentRouteName,
    required this.pushRouteName,
    this.arguments,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final String currentRouteName;
  final String pushRouteName;
  final Map? arguments;

  @override
  Widget build(BuildContext context) {
    final isCurrentRoute = currentRouteName == pushRouteName;

    return ListTile(
      leading: Icon(
        iconData,
        color: isCurrentRoute ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: isCurrentRoute
            ? TextStyle(color: Theme.of(context).primaryColor)
            : null,
      ),
      minLeadingWidth: 10,
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
        color: isCurrentRoute ? Theme.of(context).primaryColor : null,
      ),
      onTap: () async {
        if (pushRouteName == RouteName.licensePage) {
          _showLicense(context);
          return;
        }

        if (isCurrentRoute) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed(
            pushRouteName,
            arguments: arguments,
          );
        }
      },
    );
  }

  void _showLicense(BuildContext context) async {
    showLicensePage(
        context: context,
        applicationIcon: Icon(Icons.info_outlined),
        applicationName: AppLocalizations.of(context)!.appName,
        applicationLegalese: AppLocalizations.of(context)!.appAuthor);
  }
}
