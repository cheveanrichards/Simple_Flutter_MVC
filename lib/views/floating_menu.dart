import 'package:flutter/material.dart';
import '../../../lib/controllers/models/controllers/menu_controller.dart';

class FloatingMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  final MYMenuController _menuController = MYMenuController();

  FloatingMenu({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.menu),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('Menu'),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    _menuController.navigateToPage(context, 0);
                    onItemSelected(0);
                  },
                  child: Text('Home'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    _menuController.navigateToPage(context, 1);
                    onItemSelected(1);
                  },
                  child: Text('Weather'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    _menuController.navigateToPage(context, 2);
                    onItemSelected(2);
                  },
                  child: Text('About'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}