import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toptop/views/screens/home/camera/camera_screen.dart';


class CustomAnimatedBottomBar extends StatelessWidget {
  CustomAnimatedBottomBar({
    super.key,
    required this.selectedScreenIndex,
    required this.onItemTap,
  });

  final int selectedScreenIndex;
  final Function onItemTap;
  bool _isNavigating = false; // Flag to control navigation
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 11, fontWeight: FontWeight.w600);
    var barHeight = MediaQuery.of(context).size.height * 0.06;
    return BottomAppBar(
      child: Container(
        color: selectedScreenIndex == 0 ? Colors.black : Colors.white,
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _bottomNavBarItem(0, "Home", style, 'home'),
            _bottomNavBarItem(1, "Chat", style, 'message'),
            _addVideoNavItem(context, barHeight),
            _bottomNavBarItem(2, "Mailbox", style, 'profile'),
            _bottomNavBarItem(3, "Profile", style, 'profile'),
          ],
        ),
      ),
    );
  }

  _bottomNavBarItem(
      int index, String label, TextStyle textStyle, String iconName) {
    bool isSelected = selectedScreenIndex == index;
    Color itemColor = isSelected ? Colors.black : Colors.grey;
    if (isSelected && selectedScreenIndex == 0) {
      itemColor = Colors.white;
    }

    return InkWell(
      onTap: () => {onItemTap(index)},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              "assets/icons/${isSelected ? '${iconName}_filled' : iconName}.svg",
              color: itemColor,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            label,
            style: textStyle.copyWith(color: itemColor, fontSize: 10),
          )
        ],
      ),
    );
  }

  _addVideoNavItem(BuildContext context, double barHeight) {
    return InkWell(
      onTap: () {
        if (_isNavigating) {
          print("Navigation is already in progress.");
          return; // Avoid triggering navigation if another navigation is ongoing.
        }

        _isNavigating =
        true; // Set the flag to indicate navigation is in progress
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const CameraScreen();
        })).then((_) {
          _isNavigating = false; // Reset the flag after navigation is complete
        });
      },
      child: Container(
        height: barHeight - 15,
        width: 48,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.redAccent],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Container(
            width: 40,
            height: barHeight - 15,
            decoration: BoxDecoration(
                color: selectedScreenIndex == 0 ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(
              Icons.add,
              color: selectedScreenIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}