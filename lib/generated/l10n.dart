// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class SLocale {
  SLocale();

  static SLocale? _current;

  static SLocale get current {
    assert(_current != null,
        'No instance of SLocale was loaded. Try to initialize the SLocale delegate before accessing SLocale.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<SLocale> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = SLocale();
      SLocale._current = instance;

      return instance;
    });
  }

  static SLocale of(BuildContext context) {
    final instance = SLocale.maybeOf(context);
    assert(instance != null,
        'No instance of SLocale present in the widget tree. Did you add SLocale.delegate in localizationsDelegates?');
    return instance!;
  }

  static SLocale? maybeOf(BuildContext context) {
    return Localizations.of<SLocale>(context, SLocale);
  }

  /// `Change theme`
  String get changeTheme {
    return Intl.message(
      'Change theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Change language to Russian`
  String get changeLanguageToRus {
    return Intl.message(
      'Change language to Russian',
      name: 'changeLanguageToRus',
      desc: '',
      args: [],
    );
  }

  /// `Change language to English`
  String get changeLanguageToEn {
    return Intl.message(
      'Change language to English',
      name: 'changeLanguageToEn',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Repeat new password`
  String get newPasswordRepeat {
    return Intl.message(
      'Repeat new password',
      name: 'newPasswordRepeat',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get toChangePassword {
    return Intl.message(
      'Change password',
      name: 'toChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Hide password`
  String get hidePassword {
    return Intl.message(
      'Hide password',
      name: 'hidePassword',
      desc: '',
      args: [],
    );
  }

  /// `Show password`
  String get showPassword {
    return Intl.message(
      'Show password',
      name: 'showPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password at least 8 characters`
  String get password8char {
    return Intl.message(
      'Password at least 8 characters',
      name: 'password8char',
      desc: '',
      args: [],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `User information`
  String get userInformation {
    return Intl.message(
      'User information',
      name: 'userInformation',
      desc: '',
      args: [],
    );
  }

  /// `No account. Sign up`
  String get noAccountSignUp {
    return Intl.message(
      'No account. Sign up',
      name: 'noAccountSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account. Sign in`
  String get haveAccountSignIn {
    return Intl.message(
      'Already have an account. Sign in',
      name: 'haveAccountSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect username`
  String get incorrectUsername {
    return Intl.message(
      'Incorrect username',
      name: 'incorrectUsername',
      desc: '',
      args: [],
    );
  }

  /// `Failed authorization attempt`
  String get failedAuthorizationAttempt {
    return Intl.message(
      'Failed authorization attempt',
      name: 'failedAuthorizationAttempt',
      desc: '',
      args: [],
    );
  }

  /// `Enter a unique nickname`
  String get enterUniqueNickname {
    return Intl.message(
      'Enter a unique nickname',
      name: 'enterUniqueNickname',
      desc: '',
      args: [],
    );
  }

  /// `The password is too short (at least 8 characters).`
  String get passwordIsTooShort {
    return Intl.message(
      'The password is too short (at least 8 characters).',
      name: 'passwordIsTooShort',
      desc: '',
      args: [],
    );
  }

  /// `The password must not exceed 255 characters.`
  String get passwordIsTooLong {
    return Intl.message(
      'The password must not exceed 255 characters.',
      name: 'passwordIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `The password can contain Latin letters, numbers and symbols`
  String get passwordCanContain {
    return Intl.message(
      'The password can contain Latin letters, numbers and symbols',
      name: 'passwordCanContain',
      desc: '',
      args: [],
    );
  }

  /// `The current password is not correct`
  String get passwordCurrentIncorrect {
    return Intl.message(
      'The current password is not correct',
      name: 'passwordCurrentIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `The new passwords don''t match`
  String get newPasswordsDontMatch {
    return Intl.message(
      'The new passwords don\'\'t match',
      name: 'newPasswordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong with the password input data`
  String get wrongInputData {
    return Intl.message(
      'Something went wrong with the password input data',
      name: 'wrongInputData',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The username can only contain Latin letters and . _`
  String get usernameCanContain {
    return Intl.message(
      'The username can only contain Latin letters and . _',
      name: 'usernameCanContain',
      desc: '',
      args: [],
    );
  }

  /// `User name is too short (at least 3 characters)`
  String get usernameIsTooShort {
    return Intl.message(
      'User name is too short (at least 3 characters)',
      name: 'usernameIsTooShort',
      desc: '',
      args: [],
    );
  }

  /// `User name must not exceed 32 characters)`
  String get usernameIsTooLong {
    return Intl.message(
      'User name must not exceed 32 characters)',
      name: 'usernameIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Add new box`
  String get addNewBox {
    return Intl.message(
      'Add new box',
      name: 'addNewBox',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get search {
    return Intl.message(
      'search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Box library`
  String get boxLibrary {
    return Intl.message(
      'Box library',
      name: 'boxLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Box name`
  String get boxName {
    return Intl.message(
      'Box name',
      name: 'boxName',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Box''s cards`
  String get boxsCards {
    return Intl.message(
      'Box\'\'s cards',
      name: 'boxsCards',
      desc: '',
      args: [],
    );
  }

  /// `Only unstudied`
  String get onlyUnstudied {
    return Intl.message(
      'Only unstudied',
      name: 'onlyUnstudied',
      desc: '',
      args: [],
    );
  }

  /// `Authorization was successful!`
  String get success {
    return Intl.message(
      'Authorization was successful!',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `A user with this nickname already exists`
  String get userExist {
    return Intl.message(
      'A user with this nickname already exists',
      name: 'userExist',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect data`
  String get invailidData {
    return Intl.message(
      'Incorrect data',
      name: 'invailidData',
      desc: '',
      args: [],
    );
  }

  /// `The user with this nickname does not exist or the password is incorrect`
  String get invalidLoginorPassword {
    return Intl.message(
      'The user with this nickname does not exist or the password is incorrect',
      name: 'invalidLoginorPassword',
      desc: '',
      args: [],
    );
  }

  /// `Box must belong to at least one category`
  String get categoryHintText {
    return Intl.message(
      'Box must belong to at least one category',
      name: 'categoryHintText',
      desc: '',
      args: [],
    );
  }

  /// `The title of the box should convey the theme of the cards contained in it`
  String get boxNameHintText {
    return Intl.message(
      'The title of the box should convey the theme of the cards contained in it',
      name: 'boxNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Box Creating`
  String get boxCreating {
    return Intl.message(
      'Box Creating',
      name: 'boxCreating',
      desc: '',
      args: [],
    );
  }

  /// `Box Editting`
  String get boxEditting {
    return Intl.message(
      'Box Editting',
      name: 'boxEditting',
      desc: '',
      args: [],
    );
  }

  /// ` Go to cards`
  String get goToCards {
    return Intl.message(
      ' Go to cards',
      name: 'goToCards',
      desc: '',
      args: [],
    );
  }

  /// `The box name must not exceed 50 characters`
  String get boxNameIsTooLong {
    return Intl.message(
      'The box name must not exceed 50 characters',
      name: 'boxNameIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Category must not exceed 15 characters`
  String get categoryIsTooLong {
    return Intl.message(
      'Category must not exceed 15 characters',
      name: 'categoryIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Contains invalid characters or the first character is not a letter or number`
  String get invalidSimbolsForBoxandCategory {
    return Intl.message(
      'Contains invalid characters or the first character is not a letter or number',
      name: 'invalidSimbolsForBoxandCategory',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Exit without saving`
  String get exitWithoutSaving {
    return Intl.message(
      'Exit without saving',
      name: 'exitWithoutSaving',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to close the window? Any changes you make will not be saved`
  String get exitWithoutSavingMessage {
    return Intl.message(
      'Are you sure you want to close the window? Any changes you make will not be saved',
      name: 'exitWithoutSavingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Is private`
  String get isPrivate {
    return Intl.message(
      'Is private',
      name: 'isPrivate',
      desc: '',
      args: [],
    );
  }

  /// `Private cardbox can't view other users`
  String get isPrivateToolTip {
    return Intl.message(
      'Private cardbox can\'t view other users',
      name: 'isPrivateToolTip',
      desc: '',
      args: [],
    );
  }

  /// `Card creating`
  String get cardCreating {
    return Intl.message(
      'Card creating',
      name: 'cardCreating',
      desc: '',
      args: [],
    );
  }

  /// `Card editing`
  String get cardEditting {
    return Intl.message(
      'Card editing',
      name: 'cardEditting',
      desc: '',
      args: [],
    );
  }

  /// `Is universal`
  String get isUniversal {
    return Intl.message(
      'Is universal',
      name: 'isUniversal',
      desc: '',
      args: [],
    );
  }

  /// `Card's back note`
  String get backNote {
    return Intl.message(
      'Card\'s back note',
      name: 'backNote',
      desc: '',
      args: [],
    );
  }

  /// `Card's front note`
  String get frontNote {
    return Intl.message(
      'Card\'s front note',
      name: 'frontNote',
      desc: '',
      args: [],
    );
  }

  /// `Card is solved`
  String get isSolved {
    return Intl.message(
      'Card is solved',
      name: 'isSolved',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Write here what you want to remember`
  String get frontNoteTooltip {
    return Intl.message(
      'Write here what you want to remember',
      name: 'frontNoteTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Write here the answer to the question or translation of the word`
  String get backNoteTooltip {
    return Intl.message(
      'Write here the answer to the question or translation of the word',
      name: 'backNoteTooltip',
      desc: '',
      args: [],
    );
  }

  /// `For universal cards, the front and back sides are interchangeable`
  String get universalTooltip {
    return Intl.message(
      'For universal cards, the front and back sides are interchangeable',
      name: 'universalTooltip',
      desc: '',
      args: [],
    );
  }

  /// `The studied cards are not found in trainings`
  String get solvedTooltip {
    return Intl.message(
      'The studied cards are not found in trainings',
      name: 'solvedTooltip',
      desc: '',
      args: [],
    );
  }

  /// `The card field can contain no more than 250 characters`
  String get noteIsTooLong {
    return Intl.message(
      'The card field can contain no more than 250 characters',
      name: 'noteIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `search by tag`
  String get searchByTag {
    return Intl.message(
      'search by tag',
      name: 'searchByTag',
      desc: '',
      args: [],
    );
  }

  /// `Not exist`
  String get notExist {
    return Intl.message(
      'Not exist',
      name: 'notExist',
      desc: '',
      args: [],
    );
  }

  /// `Box Info`
  String get boxInfo {
    return Intl.message(
      'Box Info',
      name: 'boxInfo',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get author {
    return Intl.message(
      'Author',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `Number of cards in the box`
  String get numOfCardsInBox {
    return Intl.message(
      'Number of cards in the box',
      name: 'numOfCardsInBox',
      desc: '',
      args: [],
    );
  }

  /// `Delete box`
  String get deleteBox {
    return Intl.message(
      'Delete box',
      name: 'deleteBox',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the box? This action cannot be undone.`
  String get deleteBoxMessage {
    return Intl.message(
      'Are you sure you want to delete the box? This action cannot be undone.',
      name: 'deleteBoxMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit box`
  String get editBox {
    return Intl.message(
      'Edit box',
      name: 'editBox',
      desc: '',
      args: [],
    );
  }

  /// `Learning`
  String get learning {
    return Intl.message(
      'Learning',
      name: 'learning',
      desc: '',
      args: [],
    );
  }

  /// `Cards`
  String get cards {
    return Intl.message(
      'Cards',
      name: 'cards',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get of_msg {
    return Intl.message(
      'of',
      name: 'of_msg',
      desc: '',
      args: [],
    );
  }

  /// `Timed`
  String get timed {
    return Intl.message(
      'Timed',
      name: 'timed',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Start Learning`
  String get startLearning {
    return Intl.message(
      'Start Learning',
      name: 'startLearning',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get abort {
    return Intl.message(
      'Cancel',
      name: 'abort',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `PAUSED`
  String get paused {
    return Intl.message(
      'PAUSED',
      name: 'paused',
      desc: '',
      args: [],
    );
  }

  /// `Resume`
  String get resume {
    return Intl.message(
      'Resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get goBack {
    return Intl.message(
      'Go back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Time remaining`
  String get remainingTime {
    return Intl.message(
      'Time remaining',
      name: 'remainingTime',
      desc: '',
      args: [],
    );
  }

  /// `Learning box`
  String get learningBox {
    return Intl.message(
      'Learning box',
      name: 'learningBox',
      desc: '',
      args: [],
    );
  }

  /// `Passed`
  String get passed {
    return Intl.message(
      'Passed',
      name: 'passed',
      desc: '',
      args: [],
    );
  }

  /// `Cards passed`
  String get cardsPassed {
    return Intl.message(
      'Cards passed',
      name: 'cardsPassed',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Error`
  String get unknownError {
    return Intl.message(
      'Unknown Error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Global error`
  String get globalError {
    return Intl.message(
      'Global error',
      name: 'globalError',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop learning session?`
  String get stopLearningWarningMessage {
    return Intl.message(
      'Are you sure you want to stop learning session?',
      name: 'stopLearningWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to stop the timer?`
  String get stopTimer {
    return Intl.message(
      'Are you sure you want to stop the timer?',
      name: 'stopTimer',
      desc: '',
      args: [],
    );
  }

  /// `My favorites boxes`
  String get favoriteBoxes {
    return Intl.message(
      'My favorites boxes',
      name: 'favoriteBoxes',
      desc: '',
      args: [],
    );
  }

  /// `If card can be entered during training you will have to enter the value of the card to control learning`
  String get cardModeTooltip {
    return Intl.message(
      'If card can be entered during training you will have to enter the value of the card to control learning',
      name: 'cardModeTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Card learn mode - is Writeble?`
  String get isWriteble {
    return Intl.message(
      'Card learn mode - is Writeble?',
      name: 'isWriteble',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get avatar {
    return Intl.message(
      'Avatar',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `Image size more than 5 Mb`
  String get imageSize5Mb {
    return Intl.message(
      'Image size more than 5 Mb',
      name: 'imageSize5Mb',
      desc: '',
      args: [],
    );
  }

  /// `Image size no more than 5 Mb`
  String get imageSizeNoMore5Mb {
    return Intl.message(
      'Image size no more than 5 Mb',
      name: 'imageSizeNoMore5Mb',
      desc: '',
      args: [],
    );
  }

  /// `Change avatar`
  String get changeAvatar {
    return Intl.message(
      'Change avatar',
      name: 'changeAvatar',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<SLocale> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<SLocale> load(Locale locale) => SLocale.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
