import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
