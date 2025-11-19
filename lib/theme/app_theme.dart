import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  // Colours (tweak if you grab exact hex from DevTools)
  const Color brandSkyBlue = Color(0xFF57B7F9); // top bar / main CTAs
  const Color brandHeadingBlue = Color(0xFF3384D9); // headings
  const Color brandYellow = Color(0xFFFFC94A); // underline accents
  const Color bodyTextGrey = Color(0xFF555D66);
  const Color pageBackground = Color(0xFFFFFFFF); // site is mostly pure white

  final base = ThemeData.light();

  // Body text – Nunito Sans
  TextTheme textTheme = base.textTheme;

  final bodyBase = GoogleFonts.nunitoSans(
    textStyle: textTheme.bodyMedium?.copyWith(
      color: bodyTextGrey,
      fontSize: 15, // slightly smaller, like the site
      height: 1.6,
    ),
  );

  final headlineHero = GoogleFonts.amaticSc(
    textStyle: textTheme.headlineLarge?.copyWith(
      fontSize: 40, // ~wp preset x-large (42px)
      fontWeight: FontWeight.w700,
      color: brandHeadingBlue,
      height: 1.05,
    ),
  );

  final headlineSection = GoogleFonts.amaticSc(
    textStyle: textTheme.headlineMedium?.copyWith(
      fontSize: 32, // ~large (36px) but scaled for mobile
      fontWeight: FontWeight.w700,
      color: brandHeadingBlue,
      height: 1.1,
    ),
  );

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: brandSkyBlue,
      secondary: brandYellow,
    ),
    scaffoldBackgroundColor: pageBackground,

    textTheme: textTheme.copyWith(
      // Hero headings (“Baby & Pet Sitters”)
      headlineLarge: headlineHero,

      // Section headings (“Care for Your Children and Pets”, etc.)
      headlineMedium: headlineSection,

      // Smaller section titles if you need (you can ignore for now)
      titleLarge: GoogleFonts.nunitoSans(
        textStyle: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: brandHeadingBlue,
        ),
      ),

      titleMedium: GoogleFonts.nunitoSans(
        textStyle: textTheme.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: brandHeadingBlue,
        ),
      ),

      bodyLarge: bodyBase,
      bodyMedium: bodyBase,
      bodySmall: GoogleFonts.nunitoSans(
        textStyle: textTheme.bodySmall?.copyWith(
          color: bodyTextGrey.withOpacity(0.9),
          fontSize: 13,
          height: 1.5,
        ),
      ),

      labelLarge: GoogleFonts.nunitoSans(
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: brandSkyBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunitoSans(
        textStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandSkyBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
