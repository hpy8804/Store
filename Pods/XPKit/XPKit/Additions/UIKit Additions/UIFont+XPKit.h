//
//  UIFont+XPKit.h
//  XPKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 - 2015 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/**
 *  All font family names available in iOS 7
 */
typedef NS_ENUM (NSInteger, FamilyFontName)
{
	FamilyFontNameAcademyEngravedLET = 0,
	FamilyFontNameAlNile,
	FamilyFontNameAmericanTypewriter,
	FamilyFontNameAppleColorEmoji,
	FamilyFontNameAppleSDGothicNeo,
	FamilyFontNameArial,
	FamilyFontNameArialHebrew,
	FamilyFontNameArialRoundedMTBold,
	FamilyFontNameAvenir,
	FamilyFontNameAvenirNext,
	FamilyFontNameAvenirNextCondensed,
	FamilyFontNameBanglaSangamMN,
	FamilyFontNameBaskerville,
	FamilyFontNameBodoni72,
	FamilyFontNameBodoni72Oldstyle,
	FamilyFontNameBodoni72Smallcaps,
	FamilyFontNameBodoniOrnaments,
	FamilyFontNameBradleyHand,
	FamilyFontNameChalkboardSE,
	FamilyFontNameChalkduster,
	FamilyFontNameCochin,
	FamilyFontNameCopperplate,
	FamilyFontNameCourier,
	FamilyFontNameCourierNew,
	FamilyFontNameDamascus,
	FamilyFontNameDevanagariSangamMN,
	FamilyFontNameDidot,
	FamilyFontNameDINAlternate,
	FamilyFontNameDINCondensed,
	FamilyFontNameEuphemiaUCAS,
	FamilyFontNameFarah,
	FamilyFontNameFutura,
	FamilyFontNameGeezaPro,
	FamilyFontNameGeorgia,
	FamilyFontNameGillSans,
	FamilyFontNameGujaratiSangemMN,
	FamilyFontNameGurmukhiMN,
	FamilyFontNameHeitiSC,
	FamilyFontNameHeitiTC,
	FamilyFontNameHelvetica,
	FamilyFontNameHelveticaNeue,
	FamilyFontNameHiraginoKakuGothicProN,
	FamilyFontNameHiraginoMinchoProN,
	FamilyFontNameHoeflerText,
	FamilyFontNameIowanOldStyle,
	FamilyFontNameKailasa,
	FamilyFontNameKannadaSangamMN,
	FamilyFontNameMalayamSangamMN,
	FamilyFontNameMarion,
	FamilyFontNameMarkerFelt,
	FamilyFontNameMenlo,
	FamilyFontNameMishafi,
	FamilyFontNameNoteworthy,
	FamilyFontNameOptima,
	FamilyFontNameOriyaSangemMN,
	FamilyFontNamePalatino,
	FamilyFontNamePapyrus,
	FamilyFontNamePartyLET,
	FamilyFontNameSavoyeLET,
	FamilyFontNameSinhalaSangamMN,
	FamilyFontNameSnellRoundhand,
	FamilyFontNameSuperclarendon,
	FamilyFontNameSymbol,
	FamilyFontNameTamilSangamMN,
	FamilyFontNameTeluguSangamMN,
	FamilyFontNameThonburi,
	FamilyFontNameTimesNewRoman,
	FamilyFontNameTrebuchetMS,
	FamilyFontNameVerdana,
	FamilyFontNameZapfDingBats,
	FamilyFontNameZapfino
};

/**
 *  All font names for all family available in iOS 7
 */
typedef NS_ENUM (NSInteger, FontName)
{
	FontNameAcademyEngravedLetPlain = 0,
	FontNameAlNile,
	FontNameAlNileBold,
	FontNameAmericanTypewriter,
	FontNameAmericanTypewriterBold,
	FontNameAmericanTypewriterCondensed,
	FontNameAmericanTypewriterCondensedBold,
	FontNameAmericanTypewriterCondensedLight,
	FontNameAmericanTypewriterLight,
	FontNameAppleColorEmoji,
	FontNameAppleSDGohticNeoBold,
	FontNameAppleSDGohticNeoLight,
	FontNameAppleSDGohticNeoMedium,
	FontNameAppleSDGohticNeoRegular,
	FontNameAppleSDGohticNeoSemiBold,
	FontNameAppleSDGohticNeoThin,
	FontNameArialBoldItalicMT,
	FontNameArialBoldMT,
	FontNameArialHebrew,
	FontNameArialHebrewBold,
	FontNameArialHebrewLight,
	FontNameArialItalicMT,
	FontNameArialMT,
	FontNameArialRoundedMTBold,
	FontNameASTHeitiLight,
	FontNameASTHeitiMedium,
	FontNameAvenirBlack,
	FontNameAvenirBlackOblique,
	FontNameAvenirBook,
	FontNameAvenirBookOblique,
	FontNameAvenirHeavtOblique,
	FontNameAvenirHeavy,
	FontNameAvenirLight,
	FontNameAvenirLightOblique,
	FontNameAvenirMedium,
	FontNameAvenirMediumOblique,
	FontNameAvenirNextBold,
	FontNameAvenirNextBoldItalic,
	FontNameAvenirNextCondensedBold,
	FontNameAvenirNextCondensedBoldItalic,
	FontNameAvenirNextCondensedDemiBold,
	FontNameAvenirNextCondensedDemiBoldItalic,
	FontNameAvenirNextCondensedHeavy,
	FontNameAvenirNextCondensedHeavyItalic,
	FontNameAvenirNextCondensedItalic,
	FontNameAvenirNextCondensedMedium,
	FontNameAvenirNextCondensedMediumItalic,
	FontNameAvenirNextCondensedRegular,
	FontNameAvenirNextCondensedUltraLight,
	FontNameAvenirNextCondensedUltraLightItalic,
	FontNameAvenirNextDemiBold,
	FontNameAvenirNextDemiBoldItalic,
	FontNameAvenirNextHeavy,
	FontNameAvenirNextItalic,
	FontNameAvenirNextMedium,
	FontNameAvenirNextMediumItalic,
	FontNameAvenirNextRegular,
	FontNameAvenirNextUltraLight,
	FontNameAvenirNextUltraLightItalic,
	FontNameAvenirOblique,
	FontNameAvenirRoman,
	FontNameBanglaSangamMN,
	FontNameBanglaSangamMNBold,
	FontNameBaskerville,
	FontNameBaskervilleBold,
	FontNameBaskervilleBoldItalic,
	FontNameBaskervilleItalic,
	FontNameBaskervilleSemiBold,
	FontNameBaskervilleSemiBoldItalic,
	FontNameBodoniOrnamentsITCTT,
	FontNameBodoniSvtyTwoITCTTBold,
	FontNameBodoniSvtyTwoITCTTBook,
	FontNameBodoniSvtyTwoITCTTBookIta,
	FontNameBodoniSvtyTwoOSITCTTBold,
	FontNameBodoniSvtyTwoOSITCTTBook,
	FontNameBodoniSvtyTwoOSITCTTBookIt,
	FontNameBodoniSvtyTwoSCITCTTBook,
	FontNameBradleyHandITCTTBold,
	FontNameChalkboardSEBold,
	FontNameChalkboardSELight,
	FontNameChalkboardSERegular,
	FontNameChalkduster,
	FontNameCochin,
	FontNameCochinBold,
	FontNameCochinBoldItalic,
	FontNameCochinItalic,
	FontNameCopperplate,
	FontNameCopperplateBold,
	FontNameCopperplateLight,
	FontNameCourier,
	FontNameCourierBold,
	FontNameCourierBoldOblique,
	FontNameCourierNewPSBoldItalicMT,
	FontNameCourierNewPSBoldMT,
	FontNameCourierNewPSItalicMT,
	FontNameCourierNewPSMT,
	FontNameCourierOblique,
	FontNameDamascus,
	FontNameDamascusBold,
	FontNameDamascusMedium,
	FontNameDamascusSemiBold,
	FontNameDevanagariSangamMN,
	FontNameDevanagariSangamMNBold,
	FontNameDidot,
	FontNameDidotBold,
	FontNameDidotItalic,
	FontNameDINAlternateBold,
	FontNameDINCondensedBold,
	FontNameDiwanMishafi,
	FontNameEuphemiaUCAS,
	FontNameEuphemiaUCASBold,
	FontNameEuphemiaUCASItalic,
	FontNameFarah,
	FontNameFuturaCondensedExtraBold,
	FontNameFuturaCondensedMedium,
	FontNameFuturaMedium,
	FontNameFuturaMediumItalicm,
	FontNameGeezaPro,
	FontNameGeezaProBold,
	FontNameGeezaProLight,
	FontNameGeorgia,
	FontNameGeorgiaBold,
	FontNameGeorgiaBoldItalic,
	FontNameGeorgiaItalic,
	FontNameGillSans,
	FontNameGillSansBold,
	FontNameGillSansBoldItalic,
	FontNameGillSansItalic,
	FontNameGillSansLight,
	FontNameGillSansLightItalic,
	FontNameGujaratiSangamMN,
	FontNameGujaratiSangamMNBold,
	FontNameGurmukhiMN,
	FontNameGurmukhiMNBold,
	FontNameHelvetica,
	FontNameHelveticaBold,
	FontNameHelveticaBoldOblique,
	FontNameHelveticaLight,
	FontNameHelveticaLightOblique,
	FontNameHelveticaNeue,
	FontNameHelveticaNeueBold,
	FontNameHelveticaNeueBoldItalic,
	FontNameHelveticaNeueCondensedBlack,
	FontNameHelveticaNeueCondensedBold,
	FontNameHelveticaNeueItalic,
	FontNameHelveticaNeueLight,
	FontNameHelveticaNeueMedium,
	FontNameHelveticaNeueMediumItalic,
	FontNameHelveticaNeueThin,
	FontNameHelveticaNeueThinItalic,
	FontNameHelveticaNeueUltraLight,
	FontNameHelveticaNeueUltraLightItalic,
	FontNameHelveticaOblique,
	FontNameHiraKakuProNW3,
	FontNameHiraKakuProNW6,
	FontNameHiraMinProNW3,
	FontNameHiraMinProNW6,
	FontNameHoeflerTextBlack,
	FontNameHoeflerTextBlackItalic,
	FontNameHoeflerTextItalic,
	FontNameHoeflerTextRegular,
	FontNameIowanOldStyleBold,
	FontNameIowanOldStyleBoldItalic,
	FontNameIowanOldStyleItalic,
	FontNameIowanOldStyleRoman,
	FontNameKailasa,
	FontNameKailasaBold,
	FontNameKannadaSangamMN,
	FontNameKannadaSangamMNBold,
	FontNameMalayalamSangamMN,
	FontNameMalayalamSangamMNBold,
	FontNameMarionBold,
	FontNameMarionItalic,
	FontNameMarionRegular,
	FontNameMarkerFeltThin,
	FontNameMarkerFeltWide,
	FontNameMenloBold,
	FontNameMenloBoldItalic,
	FontNameMenloItalic,
	FontNameMenloRegular,
	FontNameNoteworthyBold,
	FontNameNoteworthyLight,
	FontNameOptimaBold,
	FontNameOptimaBoldItalic,
	FontNameOptimaExtraBlack,
	FontNameOptimaItalic,
	FontNameOptimaRegular,
	FontNameOriyaSangamMN,
	FontNameOriyaSangamMNBold,
	FontNamePalatinoBold,
	FontNamePalatinoBoldItalic,
	FontNamePalatinoItalic,
	FontNamePalatinoRoman,
	FontNamePapyrus,
	FontNamePapyrusCondensed,
	FontNamePartyLetPlain,
	FontNameSavoyeLetPlain,
	FontNameSinhalaSangamMN,
	FontNameSinhalaSangamMNBold,
	FontNameSnellRoundhand,
	FontNameSnellRoundhandBlack,
	FontNameSnellRoundhandBold,
	FontNameSTHeitiSCLight,
	FontNameSTHeitiSCMedium,
	FontNameSTHeitiTCLight,
	FontNameSTHeitiTCMedium,
	FontNameSuperclarendonBlack,
	FontNameSuperclarendonBlackItalic,
	FontNameSuperclarendonBold,
	FontNameSuperclarendonBoldItalic,
	FontNameSuperclarendonItalic,
	FontNameSuperclarendonLight,
	FontNameSuperclarendonLightItalic,
	FontNameSuperclarendonRegular,
	FontNameSymbol,
	FontNameTamilSangamMN,
	FontNameTamilSangamMNBold,
	FontNameTeluguSangamMN,
	FontNameTeluguSangamMNBold,
	FontNameThonburi,
	FontNameThonburiBold,
	FontNameThonburiLight,
	FontNameTimesNewRomanPSBoldItalicMT,
	FontNameTimesNewRomanPSBoldMT,
	FontNameTimesNewRomanPSItalicMT,
	FontNameTimesNewRomanPSMT,
	FontNameTrebuchetBoldItalic,
	FontNameTrebuchetMS,
	FontNameTrebuchetMSBold,
	FontNameTrebuchetMSItalic,
	FontNameVerdana,
	FontNameVerdanaBold,
	FontNameVerdanaBoldItalic,
	FontNameVerdanaItalic,
	FontNameZapfDingbatsITC,
	FontNameZapfino
};

/**
 *  This class add some useful methods to UIFont
 */
@interface UIFont (XPKit)

/**
 *  Return the CTFont
 */
@property (nonatomic, readonly) CTFontRef CTFont;

/**
 *  Print in console all family and font names
 */
+ (void)allFamilyAndFonts;

/**
 *  Craete an UIFont object from the given ctfont
 *
 *  @param CTFont CTFont
 *
 *  @return Return an UIFont instance
 */
+ (UIFont *)fontWithCTFont:(CTFontRef)CTFont;

/**
 *  Craete an CTFontRef from the given ttf name and size
 *
 *  @param ttfName ttf name
 *  @param size    Size of the font
 *
 *  @return Return an CTFontRef
 */
+ (CTFontRef)bundledFontNamed:(NSString *)ttfName size:(CGFloat)size;

/**
 *  Craete an CTFontRef from the given ttf path and size
 *
 *  @param ttfPath ttf path
 *  @param size    Size of the font
 *
 *  @return Return an CTFontRef
 */
+ (CTFontRef)bundledFontPath:(NSString *)ttfPath size:(CGFloat)size;

/**
 *  Print in console all font names for a given family
 *
 *  @param familyFontName Family to print the fonts
 *
 *  @return Return all the fonts for the given family
 */
+ (NSArray *)fontsNameForFamilyName:(FamilyFontName)familyFontName;

/**
 *  Craete an UIFont object from the given font name and size
 *
 *  @param fontName Font name
 *  @param fontSize Size of the font
 *
 *  @return Return an UIFont from the given font name and size
 */
+ (UIFont *)fontForFontName:(FontName)fontName
                       size:(CGFloat)fontSize;

@end
