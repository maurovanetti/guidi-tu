// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get whoDrivesTonight => 'Who drives tonight?';

  @override
  String get whoPaysTonight => 'Who pays tonight?';

  @override
  String get findOutPlaying => 'Play to find out!';

  @override
  String get play => 'Play';

  @override
  String get playAgain => 'Play again';

  @override
  String get info => 'About this app';

  @override
  String get challenge => 'Dexterity challenge';

  @override
  String get changeLanguage => '🌐 Change language';

  @override
  String get downloadFromGooglePlay => 'Download from Google Play';

  @override
  String get downloadFromAppStore => 'Download from App Store';

  @override
  String get logoPath => 'assets/images/title/logo_en.png';

  @override
  String get howDoesItWork => 'How does it work?';

  @override
  String get proceed => 'Next';

  @override
  String get tutorial1 =>
      '\nWho drinks alcohol doesn\'t drive, **too dangerous**.\n\nEvery group should have a **Sober Driver**.\n';

  @override
  String get tutorial2 =>
      '\nBy playing one of this app\'s mini games, you decide who drinks and who drives.\n\n**Whoever comes last, drives and doesn\'t drink**.\n';

  @override
  String get tutorial3 =>
      '\nBut watch out: **whoever comes first, can drink but must pay**.\n\nTherefore, it\'s better to get to mid-table!';

  @override
  String get tutorial4 =>
      '\nPossible penalties for who comes first:\n* Pay for non-alcoholic drinks for the Sober Driver?\n* Offer snacks to everyone?\n* Pay the fuel?\n';

  @override
  String get defaultPlayerNames => 'ALEX,DANNY,JO,LOU,MO,ROBBY,SAM';

  @override
  String get duplicatesWarningTitle => 'Duplicate names.';

  @override
  String get duplicatesWarning =>
      'Some names are the same, please change them.';

  @override
  String get addPlayersWarning => 'Please add at least 2 players.';

  @override
  String get registerPlayers => 'Register players';

  @override
  String get clickNamesToEdit => 'Click on the names to edit them:';

  @override
  String get addPlayer => 'Add player';

  @override
  String playersReady(String gender) {
    return 'Ready';
  }

  @override
  String get editPlayer => 'Edit player';

  @override
  String get setFemininePlayer => 'Use «she»';

  @override
  String get setMasculinePlayer => 'Use «he»';

  @override
  String get setNeutralPlayer => 'Use «they»';

  @override
  String maxNLetters(int n) {
    return 'Max $n letters';
  }

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get pickDiscipline => 'Pick a discipline';

  @override
  String get recommendedDiscipline => 'Suggested';

  @override
  String get itsTurnOf => 'It\'s the turn of';

  @override
  String get tieBreaker => 'In case of a tie, the fastest wins.';

  @override
  String iAmReady(String gender) {
    return 'I\'m ready';
  }

  @override
  String everyonePlayed(String gender) {
    return 'Everyone played';
  }

  @override
  String generousDesignatedBenefactor(String gender) {
    return 'Generous Designated Benefactor';
  }

  @override
  String authorisedDrinker(String gender) {
    return 'Authorised Drinker';
  }

  @override
  String soberDesignatedDriver(String gender) {
    return 'Sober Designated Driver';
  }

  @override
  String shot0(String gender) {
    return ' remained completely still';
  }

  @override
  String shotOver100(String gender) {
    return ' stormed heaven';
  }

  @override
  String shotUnderMinus100(String gender) {
    return ' went to the underworld';
  }

  @override
  String shotOverAbsolute20(String gender) {
    return ' put some effort';
  }

  @override
  String steadyHandStory1(String gender) {
    return ' resisted';
  }

  @override
  String steadyHandStory2(String gender) {
    return ' fought hard';
  }

  @override
  String steadyHandStory3(String gender) {
    return ' stayed in the saddle';
  }

  @override
  String get steadyHandStorySuffix1 => ' very little';

  @override
  String get steadyHandStorySuffix2 => ' decently';

  @override
  String get steadyHandStorySuffix3 => ' for quite a while';

  @override
  String get steadyHandStorySuffix4 => ' for a long time';

  @override
  String get playSecretlyTitle => 'Play in secret';

  @override
  String get playSecretly =>
      'Don\'t show your move to those who have not played yet.';

  @override
  String get iAmDone => 'I\'m done!';

  @override
  String get outcome => 'Outcome';

  @override
  String get ranking => 'Ranking';

  @override
  String get finalResults => 'The final results are ready…';

  @override
  String get seeFinalResults => 'Let\'s check them!';

  @override
  String get seeRanking => 'Let\'s see the rankings now!';

  @override
  String get canDrinkButMustPay => 'Can drink, must pay';

  @override
  String canDrink(num count) {
    return 'Can drink';
  }

  @override
  String get drivesAndDoesntDrink => 'Drives, doesn\'t drink';

  @override
  String get end => 'End';

  @override
  String get disclaimer =>
      'This app was created under the provisions of project Safe & Drive, led by the City of Cuneo, funded by the Italian government — Department for Anti-Drug Policy. The main goal of the project is the reduction of street accidents correlated with the consumption of alcohol and other addictive substances.';

  @override
  String get mainCredits =>
      'Produced by **cooperativa sociale Alice**\n\nConceived and developed by **Mauro Vanetti**\n\nArt and animation by **Jacopo Rovida**\n\nLocalised by **Mauro Vanetti**\n\nTesting and precious advice by **Jacopo Rovida**';

  @override
  String get freeSoftwareCredits =>
      'This app is free software. The entire source code and all assets are on GitHub (maurovanetti/guidi-tu) and can be reused for non-commercial purposes according to the license indicated in the repository.\nIf you wish to add a mini game, file a bug, suggest improvements, add localisations, please directly contribute there.';

  @override
  String get sponsorsPath => 'assets/images/info/sponsors.png';

  @override
  String elapsedTime(int seconds) {
    return 'Elapsed: $seconds s';
  }

  @override
  String xCentimeters(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 1);
    final String xString = xNumberFormat.format(x);

    return '$xString cm';
  }

  @override
  String xSeconds(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 2);
    final String xString = xNumberFormat.format(x);

    return '$xString s';
  }

  @override
  String xForSeconds(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 2);
    final String xString = xNumberFormat.format(x);

    return '$xString';
  }

  @override
  String xSecondsPrecise(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 4);
    final String xString = xNumberFormat.format(x);

    return '$xString s';
  }

  @override
  String dateTime(DateTime dt) {
    final intl.DateFormat dtDateFormat =
        intl.DateFormat('dd/MM HH:mm', localeName);
    final String dtString = dtDateFormat.format(dt);

    return '$dtString';
  }

  @override
  String plusMinusN(int n) {
    return '±$n';
  }

  @override
  String nPoints(int n) {
    return '$n pt.';
  }

  @override
  String get longShotName => 'Long Shot';

  @override
  String get longShotDescription => 'Pick a high number.';

  @override
  String get longShotExplanation =>
      'You drive if you picked the lowest number.\n\nBut watch out: who picked the highest number, pays.';

  @override
  String get shortShotName => 'Short Shot';

  @override
  String get shortShotDescription => 'Pick a low number.';

  @override
  String get shortShotExplanation =>
      'You drive if you picked the highest number.\n\nBut watch out: who picked the lowest number, pays.';

  @override
  String get morraName => 'Morra';

  @override
  String get morraDescription => 'Guess the total.';

  @override
  String get morraExplanation =>
      'Choose how many fingers you are showing and forecast how many fingers will be shown by all players combined.\n\nYou drive if your guess was the furthest from the actual total.\n\nBut watch out: who got closest, pays.';

  @override
  String get battleshipName => 'Battleship';

  @override
  String get battleshipDescription => 'Rescue and sink.';

  @override
  String battleshipExplanation(int pointsPerRescue, int pointsPerHit) {
    return 'Pick where you are placing your floaters and which squares you are attacking.\n\nScore $pointsPerRescue for each of your floaters that you saved, and $pointsPerHit for each enemy floater that you sank.\n\nYou drive if you got the lowest score.\n\nBut watch out: who got the highest score, pays.';
  }

  @override
  String get stopwatchName => 'Stopwatch';

  @override
  String get stopwatchDescription => 'Prove split-second timing.';

  @override
  String get stopwatchExplanation =>
      'The hand spins fast. You can stop it whenever you want.\n\nIf it goes past noon, it starts from zero.\n\nYou drive if you stopped the hand at the lowest value.\n\nBut watch out: who stopped it ahead of everyone, pays.';

  @override
  String get steadyHandName => 'Steady Hand';

  @override
  String get steadyHandDescription => 'Hold it still.';

  @override
  String get steadyHandExplanation =>
      'Hold the phone horizontally on your hand.\n\nDo not drop the marble.\n\nYou drive if you held out less than everyone else.\n\nBut watch out: who lasted longest, pays.';

  @override
  String get ouijaName => 'Telepathy';

  @override
  String get ouijaDescription => 'Guess the word.';

  @override
  String ouijaExplanation(int pointsPerMiss, int pointsPerGuess) {
    return 'Compose a sequence of letters.\n\nScore $pointsPerMiss for each letter also used by other people,\n$pointsPerGuess if it\'s in the same position too.\n\nYou drive if you got the lowest score.\n\nBut watch out: who got the highest score, pays.';
  }

  @override
  String get rpsName => 'Rock Paper Scissors';

  @override
  String get rpsDescription => 'Win the tournament.';

  @override
  String get rpsExplanation =>
      'Compose a sequence of hand gestures.\n\nWho is in the winning team in each round score one point.\n\nYou drive if you got the lowest score.\n\nBut watch out: who got the highest score, pays.';

  @override
  String get strawsName => 'Straws';

  @override
  String get strawsDescription => 'Pick a short straw.';

  @override
  String get strawsExplanation =>
      'You can cycle through the straws until you find one you like.\n\nYou drive if you got the shortest pick.\n\nBut watch out: who picked the longest one, pays.';

  @override
  String get boulesName => 'Boules';

  @override
  String get boulesDescription => 'Get close to the jack.';

  @override
  String get boulesExplanation =>
      'Two boules each, only the best shot counts.\n\nPick direction and strength of your shots.\n\nYou drive if you got the furthest from the jack.\n\nBut watch out: who got the closest, pays.';

  @override
  String get quitTitle => 'Abort game';

  @override
  String get quitMessage =>
      'Do you really want to quit the match?\nYou will come off as a spoilsport!';

  @override
  String get quitConfirm => 'Stop everything';

  @override
  String get quitCancel => 'Continue playing';

  @override
  String get dragFloaters => 'Drag your floaters onto the squares';

  @override
  String get chooseTargets => 'And now choose where to hit';

  @override
  String nPointsPerSave(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pts.',
      one: 'pt.',
    );
    return '$n $_temp0 for each surviving floater';
  }

  @override
  String nPointsPerHit(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pts.',
      one: 'pt.',
    );
    return '$n $_temp0 for each successful hit';
  }

  @override
  String get dragAndRelease => 'Drag the arrow and release';

  @override
  String get waitForBoules => 'Let\'s wait for the bowls to stop…';

  @override
  String get onlyOneBowlCounts => 'Only the best shot of every player counts';

  @override
  String get total => 'TOTAL =';

  @override
  String get totalFingers => 'Fingers total: ';

  @override
  String get essentialAlphabet => 'AEIOUY';

  @override
  String get extraAlphabet => 'BCDFGHJKLMNPQRSTVWXZ';

  @override
  String nPointsPerFullGuess(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pts.',
      one: 'pt.',
    );
    return '$n $_temp0 for each letter guessed.';
  }

  @override
  String nPointsPerPartialGuess(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'pts.',
      one: 'pt.',
    );
    return '$n $_temp0 for each letter in the wrong place.';
  }

  @override
  String get onePointPerWin => '1 pt. for each round won.';

  @override
  String get zeroPointsPerTie => '0 pt. for ties and standoffs.';

  @override
  String get longTapToReset => 'Tap longer to reset';

  @override
  String get smorfia0 => 'the newborn';

  @override
  String get smorfia1 => 'Italy';

  @override
  String get smorfia2 => 'the little girl';

  @override
  String get smorfia3 => 'the queen cat';

  @override
  String get smorfia4 => 'the piglet';

  @override
  String get smorfia5 => 'the hand';

  @override
  String get smorfia6 => 'looks down';

  @override
  String get smorfia7 => 'the vase';

  @override
  String get smorfia8 => 'the virgin';

  @override
  String get smorfia9 => 'the children';

  @override
  String get smorfia10 => 'the beans';

  @override
  String get smorfia11 => 'the little mice';

  @override
  String get smorfia12 => 'the soldier';

  @override
  String get smorfia13 => 'the saint';

  @override
  String get smorfia14 => 'the breathalyzer';

  @override
  String get smorfia15 => 'the boy';

  @override
  String get smorfia16 => 'the butt';

  @override
  String get smorfia17 => 'the misfortune';

  @override
  String get smorfia18 => 'the blood';

  @override
  String get smorfia19 => 'the laughter';

  @override
  String get smorfia20 => 'the party';

  @override
  String get smorfia21 => 'in the nude';

  @override
  String get smorfia22 => 'the madman';

  @override
  String get smorfia23 => 'the fool';

  @override
  String get smorfia24 => 'the guards';

  @override
  String get smorfia25 => 'Christmas';

  @override
  String get smorfia26 => 'the saint';

  @override
  String get smorfia27 => 'the chamber pot';

  @override
  String get smorfia28 => 'the breasts';

  @override
  String get smorfia29 => 'the dad';

  @override
  String get smorfia30 => 'the lieutenant';

  @override
  String get smorfia31 => 'the master';

  @override
  String get smorfia32 => 'the big eel';

  @override
  String get smorfia33 => 'the years';

  @override
  String get smorfia34 => 'the head';

  @override
  String get smorfia35 => 'the little bird';

  @override
  String get smorfia36 => 'the castanets';

  @override
  String get smorfia37 => 'the monk';

  @override
  String get smorfia38 => 'the beatings';

  @override
  String get smorfia39 => 'the knot';

  @override
  String get smorfia40 => 'the boredom';

  @override
  String get smorfia41 => 'the knife';

  @override
  String get smorfia42 => 'the coffee';

  @override
  String get smorfia43 => 'the gossip';

  @override
  String get smorfia44 => 'the prison';

  @override
  String get smorfia45 => 'the mineral water';

  @override
  String get smorfia46 => 'the money';

  @override
  String get smorfia47 => 'the skeleton';

  @override
  String get smorfia48 => 'who speaks';

  @override
  String get smorfia49 => 'the meat';

  @override
  String get smorfia50 => 'the bread';

  @override
  String get smorfia51 => 'the garden';

  @override
  String get smorfia52 => 'the mom';

  @override
  String get smorfia53 => 'the old man';

  @override
  String get smorfia54 => 'the hat';

  @override
  String get smorfia55 => 'the music';

  @override
  String get smorfia56 => 'the fall';

  @override
  String get smorfia57 => 'the hunchback';

  @override
  String get smorfia58 => 'the rider';

  @override
  String get smorfia59 => 'the hair';

  @override
  String get smorfia60 => 'the lament';

  @override
  String get smorfia61 => 'the hunter';

  @override
  String get smorfia62 => 'the prey';

  @override
  String get smorfia63 => 'the bride';

  @override
  String get smorfia64 => 'the tailcoat';

  @override
  String get smorfia65 => 'the cry';

  @override
  String get smorfia66 => 'the two spinsters';

  @override
  String get smorfia67 => 'in the guitar';

  @override
  String get smorfia68 => 'the soup';

  @override
  String get smorfia69 => 'upside down';

  @override
  String get smorfia70 => 'the palace';

  @override
  String get smorfia71 => 'the bad man';

  @override
  String get smorfia72 => 'the wonder';

  @override
  String get smorfia73 => 'the hospital';

  @override
  String get smorfia74 => 'the cave';

  @override
  String get smorfia75 => 'Pulcinella';

  @override
  String get smorfia76 => 'the fountain';

  @override
  String get smorfia77 => 'the legs';

  @override
  String get smorfia78 => 'the beauty';

  @override
  String get smorfia79 => 'the thief';

  @override
  String get smorfia80 => 'the mouth';

  @override
  String get smorfia81 => 'the flowers';

  @override
  String get smorfia82 => 'the table';

  @override
  String get smorfia83 => 'the bad weather';

  @override
  String get smorfia84 => 'the church';

  @override
  String get smorfia85 => 'the souls';

  @override
  String get smorfia86 => 'the shop';

  @override
  String get smorfia87 => 'the lice';

  @override
  String get smorfia88 => 'the caciocavallos';

  @override
  String get smorfia89 => 'the old woman';

  @override
  String get smorfia90 => 'the fear';

  @override
  String get smorfia91 => 'there isn\'t';

  @override
  String get smorfia92 => 'the uranium';

  @override
  String get smorfia93 => 'the app';

  @override
  String get smorfia94 => 'the plutonium';

  @override
  String get smorfia95 => 'the window';

  @override
  String get smorfia96 => 'upside down';

  @override
  String get smorfia97 => 'the grimace';

  @override
  String get smorfia98 => 'the college';

  @override
  String get smorfia99 => 'the edge';

  @override
  String shotStory1(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'his',
        'f': 'her',
        'other': 'their',
      },
    );
    return ' did $_temp0 best';
  }

  @override
  String shotStory2(String gender) {
    return ' played fair';
  }

  @override
  String shotStory3(String gender) {
    return ' made a move';
  }

  @override
  String get shotStorySuffix1 => ' in a hurry';

  @override
  String get shotStorySuffix2 => ' rapidly';

  @override
  String get shotStorySuffix3 => ' calmly';

  @override
  String get shotStorySuffix4 => ' very calmly';

  @override
  String get shotStorySuffix5 => ' in geological times';

  @override
  String get shotStorySuffix6 => ' in astronomical times';

  @override
  String get stop => 'STOP';

  @override
  String get stopwatchMemo1 => 'Remember:\n';

  @override
  String get stopwatchMemo2 =>
      'The stopwatch does not need to be stopped at its first round! ';

  @override
  String get stopwatchMemo3 =>
      'If you passed beyond the zero, you\'d rather wait for the next round.\n';

  @override
  String get pickAnotherStraw => 'Pick another straw';

  @override
  String get scores => 'Scores';

  @override
  String collectedNStars(int n, String emotion) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'stars',
      one: 'star',
    );
    String _temp1 = intl.Intl.selectLogic(
      emotion,
      {
        'bad': '…',
        'meh': '.',
        'other': '!',
      },
    );
    return 'You collected $n $_temp0$_temp1';
  }

  @override
  String get compareWithPreviousScores => 'Compare with previous performances.';

  @override
  String get notDrinking => 'Not drinking:';

  @override
  String get drinking => 'Drinking:';

  @override
  String get prepareForChallenge => 'Prepare for the challenge';

  @override
  String get placePhoneHorizontally =>
      'Place the phone horizontally before proceeding.';

  @override
  String get done => 'Done';

  @override
  String get preparingForChallenge => 'Preparing for the challenge';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get iHaveDrunk => 'I have drunk alcohol';

  @override
  String get iHaveNotDrunk => 'I have not drunk alcohol';

  @override
  String get youCanStart => 'You can start';

  @override
  String get softwareLicences => 'Software licences';

  @override
  String get appName => 'Sober Driver';
}
