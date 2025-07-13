import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_avatar_generator/models/fonts_model.dart';
import 'package:user_avatar_generator/models/gradients_model.dart';
import 'package:user_avatar_generator/models/shortcut_model.dart';

class TextImageGenerater extends StatelessWidget {
  /// The size of the avatar. If `null`, defaults to a percentage of the screen width or height.
  final double? avatarSize;

  /// The shape of the avatar. Defaults to [BoxShape.circle].
  // final BoxShape avatarShape;

  /// The border radius of the avatar if the shape is [BoxShape.rectangle]. Defaults to `null`.
  final BorderRadius? borderRadius;

  /// The border around the avatar. Defaults to `null`.
  final BoxBorder? border;

  /// The background color of the avatar. Defaults to `null`.
  final Color? backgroundColor;

  /// The gradient background of the avatar. Defaults to `null`.
  final AvatarBackgroundGradient? avatarBackgroundGradient;

  /// The background image of the avatar. Defaults to `null`.
  final ImageProvider? backgroundImage;

  /// A list of shadows to apply to the avatar. Defaults to a standard shadow if `null`.
  final List<BoxShadow>? boxShadow;

  /// The initials to display on the avatar. If `null`, [text] will be used instead.
  final String? initials;

  /// The text to display on the avatar. Used if [initials] is `null`.
  final String? text;

  /// The style of the text on the avatar. Defaults to `null`.
  final TextStyle? textStyle;

  /// The alignment of the text within the avatar. Defaults to [Alignment.center].
  final Alignment textAlignment;

  /// Whether the text should be in uppercase. Defaults to `true`.
  final bool isUpperCase;

  /// The number of characters to display from the text. Defaults to `2`.
  final int numberOfCharacters;

  /// The font style to use for the text. Defaults to `null`.
  final AvatarFontStyles? fontStyle;

  /// Callback function to execute when the avatar is tapped. Defaults to `null`.
  final void Function()? onTap;

  /// The type of shortcut generation for the text. Defaults to [ShortcutGenerationType.initials].
  final ShortcutGenerationType shortcutGenerationType;

  /// Creates a [UserAvatarGenerator] with the given properties.
  ///
  /// [avatarSize], [avatarShape], [borderRadius], [border], [backgroundColor], [avatarBackgroundGradient],
  /// [backgroundImage], [boxShadow], [initials], [text], [textStyle], [textAlignment], [isUpperCase],
  /// [numberOfCharacters], [onTap], [fontStyle], and [shortcutGenerationType] can be customized.
  const TextImageGenerater({
    super.key,
    this.avatarSize,
    // this.avatarShape = BoxShape.circle,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.avatarBackgroundGradient,
    this.backgroundImage,
    this.boxShadow,
    this.initials,
    this.text,
    this.textStyle,
    this.textAlignment = Alignment.center,
    this.isUpperCase = true,
    this.numberOfCharacters = 2,
    this.onTap,
    this.fontStyle,
    this.shortcutGenerationType = ShortcutGenerationType.initials,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: avatarSize ?? size.width * 0.2,
        height: avatarSize ?? size.height * 0.1,
        decoration: BoxDecoration(
          color: backgroundColor,
          // gradient: avatarBackgroundGradient == null
          //     ? AvatarBackgroundGradient.oceanDepths.gradient
          //     : avatarBackgroundGradient?.gradient,
          // shape: avatarShape,
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow ??
              [
                const BoxShadow(
                  blurRadius: 5,
                  color: Colors.black26,
                )
              ],
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage!,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Align(
          alignment: textAlignment,
          child: Text(
            _getText(),
            style: _getTextStyle(size),
          ),
        ),
      ),
    );
  }

  /// Determines the text to display on the avatar.
  ///
  /// If [initials] is provided, it will be used. Otherwise, [text] will be used
  /// with the specified [shortcutGenerationType] and [isUpperCase].
  String _getText() {
    if (initials != null) {
      return initials!;
    } else if (text != null) {
      return generateTextBasedOnType(
        text!,
        shortcutGenerationType,
        isUpperCase,
      );
    }
    return '';
  }

  /// Calculates the text style to be used on the avatar.
  ///
  /// The style depends on [textStyle], [fontStyle], and the base font size derived from [avatarSize]
  /// or the screen size.
  TextStyle _getTextStyle(Size size) {
    double baseFontSize =
        avatarSize != null ? avatarSize! * 0.4 : size.shortestSide * 0.075;

    TextStyle baseStyle = GoogleFonts.pacifico().copyWith(
      fontSize: baseFontSize,
      color: Colors.white,
    );

    final fontStyles = {
      AvatarFontStyles.protestGuerrilla: GoogleFonts.protestGuerrilla(),
      AvatarFontStyles.pacifico: GoogleFonts.pacifico(),
      AvatarFontStyles.anton: GoogleFonts.anton(),
      AvatarFontStyles.concertOne: GoogleFonts.concertOne(),
      AvatarFontStyles.bangers: GoogleFonts.bangers(),
      AvatarFontStyles.chivo: GoogleFonts.chivo(),
    };

    if (textStyle != null && fontStyle != null) {
      return textStyle!.merge(
        fontStyles[fontStyle]!.copyWith(
          fontSize: textStyle!.fontSize ?? baseFontSize,
          color: textStyle!.color ?? Colors.white,
        ),
      );
    }

    if (textStyle != null) {
      return textStyle!.copyWith(
        fontSize: textStyle!.fontSize ?? baseFontSize,
        color: textStyle!.color ?? Colors.white,
      );
    }

    if (fontStyle != null) {
      return fontStyles[fontStyle]!.copyWith(
        fontSize: baseFontSize,
        color: Colors.white,
      );
    }

    return baseStyle;
  }
}
