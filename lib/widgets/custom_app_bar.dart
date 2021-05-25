import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _defaultElevation = 4.0;

  CustomAppBar(
      {Key key,
      this.title,
      this.leading,
      this.actions,
      this.toolbarHeight,
      this.backgroundColor,
      this.elevation,
      this.automaticallyImplyLeading = true,
      this.brightness})
      : preferredSize = Size.fromHeight(toolbarHeight ?? kToolbarHeight),
        super(key: key);

  final Widget title;

  final Widget leading;

  final double elevation;

  final List<Widget> actions;

  final Brightness brightness;

  final double toolbarHeight;

  final Color backgroundColor;

  final bool automaticallyImplyLeading;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    IconThemeData overallIconTheme = appBarTheme.iconTheme ?? theme.iconTheme;
    IconThemeData actionsIconTheme =
        appBarTheme.actionsIconTheme ?? overallIconTheme;

    final Brightness overlayStyleBrightness =
        brightness ?? appBarTheme.brightness ?? colorScheme.brightness;
    final SystemUiOverlayStyle overlayStyle =
        overlayStyleBrightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    Widget _lead;
    if (leading == null && automaticallyImplyLeading && canPop) {
      _lead = const BackButton();
    } else {
      _lead = leading;
    }

    Widget _title = Positioned.fill(
      child: DefaultTextStyle(
        style: theme.textTheme.headline6,
        child: Center(
          child: title,
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        elevation: elevation ?? appBarTheme.elevation ?? _defaultElevation,
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            children: [
              if (_lead != null)
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: _lead,
                ),
              _title,
              if (actions != null)
                IconTheme.merge(
                  data: actionsIconTheme,
                  child: Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
