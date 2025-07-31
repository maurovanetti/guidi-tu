import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @whoDrivesTonight.
  ///
  /// In it, this message translates to:
  /// **'Chi guida stasera?'**
  String get whoDrivesTonight;

  /// No description provided for @whoPaysTonight.
  ///
  /// In it, this message translates to:
  /// **'Chi paga stasera?'**
  String get whoPaysTonight;

  /// No description provided for @findOutPlaying.
  ///
  /// In it, this message translates to:
  /// **'Decidetelo giocando!'**
  String get findOutPlaying;

  /// No description provided for @play.
  ///
  /// In it, this message translates to:
  /// **'Gioca'**
  String get play;

  /// No description provided for @playAgain.
  ///
  /// In it, this message translates to:
  /// **'Gioca di nuovo'**
  String get playAgain;

  /// No description provided for @info.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get info;

  /// No description provided for @challenge.
  ///
  /// In it, this message translates to:
  /// **'Prova di abilità'**
  String get challenge;

  /// No description provided for @changeLanguage.
  ///
  /// In it, this message translates to:
  /// **'🌐 Cambia lingua'**
  String get changeLanguage;

  /// No description provided for @downloadFromGooglePlay.
  ///
  /// In it, this message translates to:
  /// **'Scarica da Google Play'**
  String get downloadFromGooglePlay;

  /// No description provided for @downloadFromAppStore.
  ///
  /// In it, this message translates to:
  /// **'Scarica da App Store'**
  String get downloadFromAppStore;

  /// No description provided for @logoPath.
  ///
  /// In it, this message translates to:
  /// **'assets/images/title/logo_it.png'**
  String get logoPath;

  /// No description provided for @howDoesItWork.
  ///
  /// In it, this message translates to:
  /// **'Come funziona?'**
  String get howDoesItWork;

  /// No description provided for @proceed.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get proceed;

  /// No description provided for @tutorial1.
  ///
  /// In it, this message translates to:
  /// **'\nChi beve alcolici non guida, **troppo pericoloso**.\n\nOgni gruppo dovrebbe avere un **Guidatore Sobrio**.\n'**
  String get tutorial1;

  /// No description provided for @tutorial2.
  ///
  /// In it, this message translates to:
  /// **'\nGiocando a uno dei minigiochi di questa app, si stabilisce chi beve e chi guida.\n\n**Chi arriva ultimo, guida e non beve**.\n'**
  String get tutorial2;

  /// No description provided for @tutorial3.
  ///
  /// In it, this message translates to:
  /// **'\nMa attenzione: **chi arriva primo, può bere ma deve pagare**.\n\nQuindi, conviene arrivare a metà classifica!'**
  String get tutorial3;

  /// No description provided for @tutorial4.
  ///
  /// In it, this message translates to:
  /// **'\nPenalità possibili per chi arriva primo:\n* Pagare analcolici al Guidatore Sobrio?\n* Offrire snack a tutti?\n* Pagare la benzina?\n'**
  String get tutorial4;

  /// No description provided for @defaultPlayerNames.
  ///
  /// In it, this message translates to:
  /// **'ALE,FEDE,GIO,MICHI,ROBI,SIMO,VALE'**
  String get defaultPlayerNames;

  /// No description provided for @duplicatesWarningTitle.
  ///
  /// In it, this message translates to:
  /// **'Nomi duplicati.'**
  String get duplicatesWarningTitle;

  /// No description provided for @duplicatesWarning.
  ///
  /// In it, this message translates to:
  /// **'Alcuni nomi sono uguali tra loro, per favore cambiali.'**
  String get duplicatesWarning;

  /// No description provided for @addPlayersWarning.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi almeno 2 partecipanti per favore.'**
  String get addPlayersWarning;

  /// No description provided for @registerPlayers.
  ///
  /// In it, this message translates to:
  /// **'Registra partecipanti'**
  String get registerPlayers;

  /// No description provided for @clickNamesToEdit.
  ///
  /// In it, this message translates to:
  /// **'Clicca sui nomi per modificarli:'**
  String get clickNamesToEdit;

  /// No description provided for @addPlayer.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi partecipante'**
  String get addPlayer;

  /// No description provided for @playersReady.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Pronti} f{Pronte} other{Si inizia}}'**
  String playersReady(String gender);

  /// No description provided for @editPlayer.
  ///
  /// In it, this message translates to:
  /// **'Modifica partecipante'**
  String get editPlayer;

  /// No description provided for @setFemininePlayer.
  ///
  /// In it, this message translates to:
  /// **'Chiamala «giocatrice»'**
  String get setFemininePlayer;

  /// No description provided for @setMasculinePlayer.
  ///
  /// In it, this message translates to:
  /// **'Chiamalo «giocatore»'**
  String get setMasculinePlayer;

  /// No description provided for @setNeutralPlayer.
  ///
  /// In it, this message translates to:
  /// **'Nessuna preferenza'**
  String get setNeutralPlayer;

  /// No description provided for @maxNLetters.
  ///
  /// In it, this message translates to:
  /// **'Massimo {n} lettere'**
  String maxNLetters(int n);

  /// No description provided for @ok.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get confirm;

  /// No description provided for @pickDiscipline.
  ///
  /// In it, this message translates to:
  /// **'Scegli una disciplina'**
  String get pickDiscipline;

  /// No description provided for @recommendedDiscipline.
  ///
  /// In it, this message translates to:
  /// **'Suggerita'**
  String get recommendedDiscipline;

  /// No description provided for @itsTurnOf.
  ///
  /// In it, this message translates to:
  /// **'Tocca a'**
  String get itsTurnOf;

  /// No description provided for @tieBreaker.
  ///
  /// In it, this message translates to:
  /// **'A pari merito, conta la velocità.'**
  String get tieBreaker;

  /// No description provided for @iAmReady.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Sono pronto} f{Sono pronta} other{Eccomi}}'**
  String iAmReady(String gender);

  /// No description provided for @everyonePlayed.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Hanno giocato tutti} f{Hanno giocato tutte} other{Ogni persona ha giocato}}'**
  String everyonePlayed(String gender);

  /// No description provided for @generousDesignatedBenefactor.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Generoso Benefattore Designato} f{Generosa Benefattrice Designata} other{Responsabile della Generosa Beneficenza}}'**
  String generousDesignatedBenefactor(String gender);

  /// No description provided for @authorisedDrinker.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Bevitore Autorizzato} f{Bevitrice Autorizzata} other{Persona Autorizzata a Bere}}'**
  String authorisedDrinker(String gender);

  /// No description provided for @soberDesignatedDriver.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{Guidatore Sobrio Designato} f{Guidatrice Sobria Designata} other{Responsabile della Guida Sobria}}'**
  String soberDesignatedDriver(String gender);

  /// No description provided for @shot0.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{ è stato immobile} f{ è stata immobile} other{ non ha mosso un dito}}'**
  String shot0(String gender);

  /// No description provided for @shotOver100.
  ///
  /// In it, this message translates to:
  /// **' ha assaltato il cielo'**
  String shotOver100(String gender);

  /// No description provided for @shotUnderMinus100.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{ è disceso negli inferi} f{ è discesa negli inferi} other{ ha raggiunto gli inferi}}'**
  String shotUnderMinus100(String gender);

  /// No description provided for @shotOverAbsolute20.
  ///
  /// In it, this message translates to:
  /// **'{gender, select, m{ si è dato da fare} f{ si è data da fare} other{ ci ha messo impegno}}'**
  String shotOverAbsolute20(String gender);

  /// No description provided for @steadyHandStory1.
  ///
  /// In it, this message translates to:
  /// **' ha resistito'**
  String steadyHandStory1(String gender);

  /// No description provided for @steadyHandStory2.
  ///
  /// In it, this message translates to:
  /// **' ha tenuto duro'**
  String steadyHandStory2(String gender);

  /// No description provided for @steadyHandStory3.
  ///
  /// In it, this message translates to:
  /// **'è {gender, select, m{rimasto} f{rimasta} other{ancora}} in sella'**
  String steadyHandStory3(String gender);

  /// No description provided for @steadyHandStorySuffix1.
  ///
  /// In it, this message translates to:
  /// **' pochissimo'**
  String get steadyHandStorySuffix1;

  /// No description provided for @steadyHandStorySuffix2.
  ///
  /// In it, this message translates to:
  /// **' dignitosamente'**
  String get steadyHandStorySuffix2;

  /// No description provided for @steadyHandStorySuffix3.
  ///
  /// In it, this message translates to:
  /// **' un bel po\''**
  String get steadyHandStorySuffix3;

  /// No description provided for @steadyHandStorySuffix4.
  ///
  /// In it, this message translates to:
  /// **' a lungo'**
  String get steadyHandStorySuffix4;

  /// No description provided for @playSecretlyTitle.
  ///
  /// In it, this message translates to:
  /// **'Gioca di nascosto'**
  String get playSecretlyTitle;

  /// No description provided for @playSecretly.
  ///
  /// In it, this message translates to:
  /// **'Non mostrare la tua mossa a chi non ha ancora giocato.'**
  String get playSecretly;

  /// No description provided for @iAmDone.
  ///
  /// In it, this message translates to:
  /// **'Ho finito!'**
  String get iAmDone;

  /// No description provided for @outcome.
  ///
  /// In it, this message translates to:
  /// **'Risultati'**
  String get outcome;

  /// No description provided for @ranking.
  ///
  /// In it, this message translates to:
  /// **'Classifica'**
  String get ranking;

  /// No description provided for @finalResults.
  ///
  /// In it, this message translates to:
  /// **'I risultati finali sono pronti…'**
  String get finalResults;

  /// No description provided for @seeFinalResults.
  ///
  /// In it, this message translates to:
  /// **'Vediamoli!'**
  String get seeFinalResults;

  /// No description provided for @seeRanking.
  ///
  /// In it, this message translates to:
  /// **'E ora vediamo la classifica!'**
  String get seeRanking;

  /// No description provided for @canDrinkButMustPay.
  ///
  /// In it, this message translates to:
  /// **'Può bere ma paga'**
  String get canDrinkButMustPay;

  /// A plural message
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{Può} other{Possono}} bere'**
  String canDrink(num count);

  /// No description provided for @drivesAndDoesntDrink.
  ///
  /// In it, this message translates to:
  /// **'Guida e non beve'**
  String get drivesAndDoesntDrink;

  /// No description provided for @end.
  ///
  /// In it, this message translates to:
  /// **'Fine'**
  String get end;

  /// No description provided for @disclaimer.
  ///
  /// In it, this message translates to:
  /// **'Applicazione realizzata nell\'ambito del progetto Safe & Drive, finanziato dal Consiglio dei Ministri — Dipartimento per le Politiche Antidroga, che ha come capofila la Città di Cuneo. L\'obiettivo principale è la riduzione degli incidenti stradali correlati al consumo di alcol e sostanze.'**
  String get disclaimer;

  /// No description provided for @mainCredits.
  ///
  /// In it, this message translates to:
  /// **'Prodotta da **cooperativa sociale Alice**\n\nPensata e sviluppata da **Mauro Vanetti**\n\nDisegni e animazioni di **Jacopo Rovida**\n\nLocalizzazione curata da **Mauro Vanetti**\n\nCollaudo e preziosi consigli di **Jacopo Rovida**'**
  String get mainCredits;

  /// No description provided for @freeSoftwareCredits.
  ///
  /// In it, this message translates to:
  /// **'Questa app è software libero. Tutto il codice sorgente e gli asset si trovano su GitHub (maurovanetti/guidi-tu) e possono essere riutilizzati purché non a scopo di lucro secondo la licenza indicata nel repository.\nSe volete aggiungere un minigioco, segnalare dei bug, proporre migliorie, aggiungere traduzioni, intervenite pure direttamente lì.'**
  String get freeSoftwareCredits;

  /// No description provided for @sponsorsPath.
  ///
  /// In it, this message translates to:
  /// **'assets/images/info/sponsors.png'**
  String get sponsorsPath;

  /// No description provided for @elapsedTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo trascorso: {seconds}\"'**
  String elapsedTime(int seconds);

  /// No description provided for @xCentimeters.
  ///
  /// In it, this message translates to:
  /// **'{x}'**
  String xCentimeters(double x);

  /// No description provided for @xSeconds.
  ///
  /// In it, this message translates to:
  /// **'{x}\"'**
  String xSeconds(double x);

  /// No description provided for @xForSeconds.
  ///
  /// In it, this message translates to:
  /// **'{x}'**
  String xForSeconds(double x);

  /// No description provided for @xSecondsPrecise.
  ///
  /// In it, this message translates to:
  /// **'{x}\"'**
  String xSecondsPrecise(double x);

  /// No description provided for @dateTime.
  ///
  /// In it, this message translates to:
  /// **'{dt}'**
  String dateTime(DateTime dt);

  /// No description provided for @plusMinusN.
  ///
  /// In it, this message translates to:
  /// **'±{n}'**
  String plusMinusN(int n);

  /// No description provided for @nPoints.
  ///
  /// In it, this message translates to:
  /// **'{n} pt.'**
  String nPoints(int n);

  /// No description provided for @longShotName.
  ///
  /// In it, this message translates to:
  /// **'Spararla grossa'**
  String get longShotName;

  /// No description provided for @longShotDescription.
  ///
  /// In it, this message translates to:
  /// **'Scegli un numero alto.'**
  String get longShotDescription;

  /// No description provided for @longShotExplanation.
  ///
  /// In it, this message translates to:
  /// **'Guidi tu se scegli il numero più basso.\n\nMa attenzione: chi sceglie il numero più alto, paga.'**
  String get longShotExplanation;

  /// No description provided for @shortShotName.
  ///
  /// In it, this message translates to:
  /// **'Cadere in basso'**
  String get shortShotName;

  /// No description provided for @shortShotDescription.
  ///
  /// In it, this message translates to:
  /// **'Scegli un numero basso.'**
  String get shortShotDescription;

  /// No description provided for @shortShotExplanation.
  ///
  /// In it, this message translates to:
  /// **'Guidi tu se scegli il numero più alto.\n\nMa attenzione: chi sceglie il numero più basso, paga.'**
  String get shortShotExplanation;

  /// No description provided for @morraName.
  ///
  /// In it, this message translates to:
  /// **'Morra'**
  String get morraName;

  /// No description provided for @morraDescription.
  ///
  /// In it, this message translates to:
  /// **'Indovina la somma.'**
  String get morraDescription;

  /// No description provided for @morraExplanation.
  ///
  /// In it, this message translates to:
  /// **'Scegli quante dita mostrare e prevedi quante dita saranno mostrate da tutti.\n\nGuidi tu se ti avvicini di meno alla somma giusta.\n\nMa attenzione: chi si avvicina di più, paga.'**
  String get morraExplanation;

  /// No description provided for @battleshipName.
  ///
  /// In it, this message translates to:
  /// **'Battaglia navale'**
  String get battleshipName;

  /// No description provided for @battleshipDescription.
  ///
  /// In it, this message translates to:
  /// **'Salva e affonda.'**
  String get battleshipDescription;

  /// No description provided for @battleshipExplanation.
  ///
  /// In it, this message translates to:
  /// **'Scegli dove collocare i tuoi galleggianti e in quali caselle attaccare.\n\nFai \${pointsPerRescue} punti per ogni tuo galleggiante salvato, \${pointsPerHit} per ognuno che affondi.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.'**
  String battleshipExplanation(int pointsPerRescue, int pointsPerHit);

  /// No description provided for @stopwatchName.
  ///
  /// In it, this message translates to:
  /// **'Cronometro'**
  String get stopwatchName;

  /// No description provided for @stopwatchDescription.
  ///
  /// In it, this message translates to:
  /// **'Spacca il secondo.'**
  String get stopwatchDescription;

  /// No description provided for @stopwatchExplanation.
  ///
  /// In it, this message translates to:
  /// **'La lancetta gira velocemente. Puoi fermarla quando vuoi.\n\nSe supera il mezzogiorno, ricomincia da zero.\n\nGuidi tu se hai fermato la lancetta al valore più basso.\n\nMa attenzione: chi la ferma più avanti di tutti, paga.'**
  String get stopwatchExplanation;

  /// No description provided for @steadyHandName.
  ///
  /// In it, this message translates to:
  /// **'Mano ferma'**
  String get steadyHandName;

  /// No description provided for @steadyHandDescription.
  ///
  /// In it, this message translates to:
  /// **'Resisti immobile.'**
  String get steadyHandDescription;

  /// No description provided for @steadyHandExplanation.
  ///
  /// In it, this message translates to:
  /// **'Tieni il telefono in orizzontale sulla tua mano.\n\nNon far cadere la biglia.\n\nGuidi tu se resisti meno di tutti.\n\nMa attenzione: chi resiste più a lungo, paga.'**
  String get steadyHandExplanation;

  /// No description provided for @ouijaName.
  ///
  /// In it, this message translates to:
  /// **'Telepatia'**
  String get ouijaName;

  /// No description provided for @ouijaDescription.
  ///
  /// In it, this message translates to:
  /// **'Indovina la parola.'**
  String get ouijaDescription;

  /// No description provided for @ouijaExplanation.
  ///
  /// In it, this message translates to:
  /// **'Componi una sequenza di lettere.\n\nFai {pointsPerMiss} pt. per ogni lettera usata anche da altri,\n\${pointsPerGuess} pt. se è anche nella stessa posizione.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.'**
  String ouijaExplanation(int pointsPerMiss, int pointsPerGuess);

  /// No description provided for @rpsName.
  ///
  /// In it, this message translates to:
  /// **'Morra cinese'**
  String get rpsName;

  /// No description provided for @rpsDescription.
  ///
  /// In it, this message translates to:
  /// **'Sasso, carta o forbici?'**
  String get rpsDescription;

  /// No description provided for @rpsExplanation.
  ///
  /// In it, this message translates to:
  /// **'Componi una sequenza di gesti.\n\nAd ogni turno, chi è nel gruppo vincente ad ogni turno vince un punto.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.'**
  String get rpsExplanation;

  /// No description provided for @strawsName.
  ///
  /// In it, this message translates to:
  /// **'Bastoncino corto'**
  String get strawsName;

  /// No description provided for @strawsDescription.
  ///
  /// In it, this message translates to:
  /// **'Scegli un bastoncino.'**
  String get strawsDescription;

  /// No description provided for @strawsExplanation.
  ///
  /// In it, this message translates to:
  /// **'Puoi cambiare bastoncino finché non ne trovi uno che ti piace.\n\nGuidi tu se lo scegli più corto degli altri.\n\nMa attenzione: chi sceglie il più lungo, paga.'**
  String get strawsExplanation;

  /// No description provided for @boulesName.
  ///
  /// In it, this message translates to:
  /// **'Bocce'**
  String get boulesName;

  /// No description provided for @boulesDescription.
  ///
  /// In it, this message translates to:
  /// **'Avvicinati al boccino.'**
  String get boulesDescription;

  /// No description provided for @boulesExplanation.
  ///
  /// In it, this message translates to:
  /// **'Due bocce a testa, conta solo il tiro migliore.\n\nScegli la direzione e la forza dei lanci.\n\nGuidi tu se alla fine la boccia più lontana dal boccino bianco è la tua.\n\nMa attenzione: chi avrà la boccia più vicina al boccino, paga.'**
  String get boulesExplanation;

  /// No description provided for @quitTitle.
  ///
  /// In it, this message translates to:
  /// **'Interruzione del gioco'**
  String get quitTitle;

  /// No description provided for @quitMessage.
  ///
  /// In it, this message translates to:
  /// **'Vuoi davvero interrompere il gioco?\nFarai una figura da guastafeste!'**
  String get quitMessage;

  /// No description provided for @quitConfirm.
  ///
  /// In it, this message translates to:
  /// **'Ferma tutto'**
  String get quitConfirm;

  /// No description provided for @quitCancel.
  ///
  /// In it, this message translates to:
  /// **'Continua a giocare'**
  String get quitCancel;

  /// No description provided for @dragFloaters.
  ///
  /// In it, this message translates to:
  /// **'Trascina i galleggianti nelle caselle'**
  String get dragFloaters;

  /// No description provided for @chooseTargets.
  ///
  /// In it, this message translates to:
  /// **'E ora decidi dove colpire'**
  String get chooseTargets;

  /// No description provided for @nPointsPerSave.
  ///
  /// In it, this message translates to:
  /// **'{n} pt. per ogni galleggiante salvato.'**
  String nPointsPerSave(int n);

  /// No description provided for @nPointsPerHit.
  ///
  /// In it, this message translates to:
  /// **'{n} pt. per ogni colpo andato a segno.'**
  String nPointsPerHit(int n);

  /// No description provided for @dragAndRelease.
  ///
  /// In it, this message translates to:
  /// **'Trascina la freccia e poi lascia andare'**
  String get dragAndRelease;

  /// No description provided for @waitForBoules.
  ///
  /// In it, this message translates to:
  /// **'Aspettiamo che le bocce si fermino…'**
  String get waitForBoules;

  /// No description provided for @onlyOneBowlCounts.
  ///
  /// In it, this message translates to:
  /// **'Conta solo la boccia migliore di ogni partecipante'**
  String get onlyOneBowlCounts;

  /// No description provided for @total.
  ///
  /// In it, this message translates to:
  /// **'SOMMA ='**
  String get total;

  /// No description provided for @totalFingers.
  ///
  /// In it, this message translates to:
  /// **'Totale dita: '**
  String get totalFingers;

  /// No description provided for @essentialAlphabet.
  ///
  /// In it, this message translates to:
  /// **'ABCDEFGHILMNOPQRSTUVZ'**
  String get essentialAlphabet;

  /// No description provided for @extraAlphabet.
  ///
  /// In it, this message translates to:
  /// **'JKWXY'**
  String get extraAlphabet;

  /// No description provided for @nPointsPerFullGuess.
  ///
  /// In it, this message translates to:
  /// **'{n} pt. per lettera indovinata.'**
  String nPointsPerFullGuess(int n);

  /// No description provided for @nPointsPerPartialGuess.
  ///
  /// In it, this message translates to:
  /// **'{n} pt. per lettera nel posto sbagliato.'**
  String nPointsPerPartialGuess(int n);

  /// No description provided for @onePointPerWin.
  ///
  /// In it, this message translates to:
  /// **'1 pt. per giocata vincente.'**
  String get onePointPerWin;

  /// No description provided for @zeroPointsPerTie.
  ///
  /// In it, this message translates to:
  /// **'0 pt. per pareggio o stallo.'**
  String get zeroPointsPerTie;

  /// No description provided for @longTapToReset.
  ///
  /// In it, this message translates to:
  /// **'Tieni premuto per azzerare'**
  String get longTapToReset;

  /// No description provided for @smorfia0.
  ///
  /// In it, this message translates to:
  /// **'il neonato'**
  String get smorfia0;

  /// No description provided for @smorfia1.
  ///
  /// In it, this message translates to:
  /// **'l\'Italia'**
  String get smorfia1;

  /// No description provided for @smorfia2.
  ///
  /// In it, this message translates to:
  /// **'la bambina'**
  String get smorfia2;

  /// No description provided for @smorfia3.
  ///
  /// In it, this message translates to:
  /// **'la gatta'**
  String get smorfia3;

  /// No description provided for @smorfia4.
  ///
  /// In it, this message translates to:
  /// **'il maialino'**
  String get smorfia4;

  /// No description provided for @smorfia5.
  ///
  /// In it, this message translates to:
  /// **'la mano'**
  String get smorfia5;

  /// No description provided for @smorfia6.
  ///
  /// In it, this message translates to:
  /// **'guarda giù'**
  String get smorfia6;

  /// No description provided for @smorfia7.
  ///
  /// In it, this message translates to:
  /// **'il vaso'**
  String get smorfia7;

  /// No description provided for @smorfia8.
  ///
  /// In it, this message translates to:
  /// **'la vergine'**
  String get smorfia8;

  /// No description provided for @smorfia9.
  ///
  /// In it, this message translates to:
  /// **'i figli'**
  String get smorfia9;

  /// No description provided for @smorfia10.
  ///
  /// In it, this message translates to:
  /// **'i fagioli'**
  String get smorfia10;

  /// No description provided for @smorfia11.
  ///
  /// In it, this message translates to:
  /// **'i topini'**
  String get smorfia11;

  /// No description provided for @smorfia12.
  ///
  /// In it, this message translates to:
  /// **'il soldato'**
  String get smorfia12;

  /// No description provided for @smorfia13.
  ///
  /// In it, this message translates to:
  /// **'il santo'**
  String get smorfia13;

  /// No description provided for @smorfia14.
  ///
  /// In it, this message translates to:
  /// **'l\'etilometro'**
  String get smorfia14;

  /// No description provided for @smorfia15.
  ///
  /// In it, this message translates to:
  /// **'il ragazzo'**
  String get smorfia15;

  /// No description provided for @smorfia16.
  ///
  /// In it, this message translates to:
  /// **'il sedere'**
  String get smorfia16;

  /// No description provided for @smorfia17.
  ///
  /// In it, this message translates to:
  /// **'la sfortuna'**
  String get smorfia17;

  /// No description provided for @smorfia18.
  ///
  /// In it, this message translates to:
  /// **'il sangue'**
  String get smorfia18;

  /// No description provided for @smorfia19.
  ///
  /// In it, this message translates to:
  /// **'la risata'**
  String get smorfia19;

  /// No description provided for @smorfia20.
  ///
  /// In it, this message translates to:
  /// **'la festa'**
  String get smorfia20;

  /// No description provided for @smorfia21.
  ///
  /// In it, this message translates to:
  /// **'senza vestiti'**
  String get smorfia21;

  /// No description provided for @smorfia22.
  ///
  /// In it, this message translates to:
  /// **'il matto'**
  String get smorfia22;

  /// No description provided for @smorfia23.
  ///
  /// In it, this message translates to:
  /// **'il tonto'**
  String get smorfia23;

  /// No description provided for @smorfia24.
  ///
  /// In it, this message translates to:
  /// **'le guardie'**
  String get smorfia24;

  /// No description provided for @smorfia25.
  ///
  /// In it, this message translates to:
  /// **'Natale'**
  String get smorfia25;

  /// No description provided for @smorfia26.
  ///
  /// In it, this message translates to:
  /// **'la santa'**
  String get smorfia26;

  /// No description provided for @smorfia27.
  ///
  /// In it, this message translates to:
  /// **'il pitale'**
  String get smorfia27;

  /// No description provided for @smorfia28.
  ///
  /// In it, this message translates to:
  /// **'i seni'**
  String get smorfia28;

  /// No description provided for @smorfia29.
  ///
  /// In it, this message translates to:
  /// **'il papà'**
  String get smorfia29;

  /// No description provided for @smorfia30.
  ///
  /// In it, this message translates to:
  /// **'il tenente'**
  String get smorfia30;

  /// No description provided for @smorfia31.
  ///
  /// In it, this message translates to:
  /// **'il padrone'**
  String get smorfia31;

  /// No description provided for @smorfia32.
  ///
  /// In it, this message translates to:
  /// **'il capitone'**
  String get smorfia32;

  /// No description provided for @smorfia33.
  ///
  /// In it, this message translates to:
  /// **'gli anni'**
  String get smorfia33;

  /// No description provided for @smorfia34.
  ///
  /// In it, this message translates to:
  /// **'la testa'**
  String get smorfia34;

  /// No description provided for @smorfia35.
  ///
  /// In it, this message translates to:
  /// **'l\'uccellino'**
  String get smorfia35;

  /// No description provided for @smorfia36.
  ///
  /// In it, this message translates to:
  /// **'le nacchere'**
  String get smorfia36;

  /// No description provided for @smorfia37.
  ///
  /// In it, this message translates to:
  /// **'il monaco'**
  String get smorfia37;

  /// No description provided for @smorfia38.
  ///
  /// In it, this message translates to:
  /// **'le botte'**
  String get smorfia38;

  /// No description provided for @smorfia39.
  ///
  /// In it, this message translates to:
  /// **'il nodo'**
  String get smorfia39;

  /// No description provided for @smorfia40.
  ///
  /// In it, this message translates to:
  /// **'la noia'**
  String get smorfia40;

  /// No description provided for @smorfia41.
  ///
  /// In it, this message translates to:
  /// **'il coltello'**
  String get smorfia41;

  /// No description provided for @smorfia42.
  ///
  /// In it, this message translates to:
  /// **'il caffè'**
  String get smorfia42;

  /// No description provided for @smorfia43.
  ///
  /// In it, this message translates to:
  /// **'il gossip'**
  String get smorfia43;

  /// No description provided for @smorfia44.
  ///
  /// In it, this message translates to:
  /// **'la prigione'**
  String get smorfia44;

  /// No description provided for @smorfia45.
  ///
  /// In it, this message translates to:
  /// **'l\'acqua minerale'**
  String get smorfia45;

  /// No description provided for @smorfia46.
  ///
  /// In it, this message translates to:
  /// **'i soldi'**
  String get smorfia46;

  /// No description provided for @smorfia47.
  ///
  /// In it, this message translates to:
  /// **'lo scheletro'**
  String get smorfia47;

  /// No description provided for @smorfia48.
  ///
  /// In it, this message translates to:
  /// **'che parla'**
  String get smorfia48;

  /// No description provided for @smorfia49.
  ///
  /// In it, this message translates to:
  /// **'la carne'**
  String get smorfia49;

  /// No description provided for @smorfia50.
  ///
  /// In it, this message translates to:
  /// **'il pane'**
  String get smorfia50;

  /// No description provided for @smorfia51.
  ///
  /// In it, this message translates to:
  /// **'il giardino'**
  String get smorfia51;

  /// No description provided for @smorfia52.
  ///
  /// In it, this message translates to:
  /// **'la mamma'**
  String get smorfia52;

  /// No description provided for @smorfia53.
  ///
  /// In it, this message translates to:
  /// **'il vecchio'**
  String get smorfia53;

  /// No description provided for @smorfia54.
  ///
  /// In it, this message translates to:
  /// **'il cappello'**
  String get smorfia54;

  /// No description provided for @smorfia55.
  ///
  /// In it, this message translates to:
  /// **'la musica'**
  String get smorfia55;

  /// No description provided for @smorfia56.
  ///
  /// In it, this message translates to:
  /// **'la caduta'**
  String get smorfia56;

  /// No description provided for @smorfia57.
  ///
  /// In it, this message translates to:
  /// **'il gobbo'**
  String get smorfia57;

  /// No description provided for @smorfia58.
  ///
  /// In it, this message translates to:
  /// **'il rider'**
  String get smorfia58;

  /// No description provided for @smorfia59.
  ///
  /// In it, this message translates to:
  /// **'i peli'**
  String get smorfia59;

  /// No description provided for @smorfia60.
  ///
  /// In it, this message translates to:
  /// **'il lamento'**
  String get smorfia60;

  /// No description provided for @smorfia61.
  ///
  /// In it, this message translates to:
  /// **'il cacciatore'**
  String get smorfia61;

  /// No description provided for @smorfia62.
  ///
  /// In it, this message translates to:
  /// **'la preda'**
  String get smorfia62;

  /// No description provided for @smorfia63.
  ///
  /// In it, this message translates to:
  /// **'la sposa'**
  String get smorfia63;

  /// No description provided for @smorfia64.
  ///
  /// In it, this message translates to:
  /// **'il frac'**
  String get smorfia64;

  /// No description provided for @smorfia65.
  ///
  /// In it, this message translates to:
  /// **'il pianto'**
  String get smorfia65;

  /// No description provided for @smorfia66.
  ///
  /// In it, this message translates to:
  /// **'le due single'**
  String get smorfia66;

  /// No description provided for @smorfia67.
  ///
  /// In it, this message translates to:
  /// **'nella chitarra'**
  String get smorfia67;

  /// No description provided for @smorfia68.
  ///
  /// In it, this message translates to:
  /// **'la zuppa'**
  String get smorfia68;

  /// No description provided for @smorfia69.
  ///
  /// In it, this message translates to:
  /// **'sottosopra'**
  String get smorfia69;

  /// No description provided for @smorfia70.
  ///
  /// In it, this message translates to:
  /// **'il palazzo'**
  String get smorfia70;

  /// No description provided for @smorfia71.
  ///
  /// In it, this message translates to:
  /// **'l\'omaccio'**
  String get smorfia71;

  /// No description provided for @smorfia72.
  ///
  /// In it, this message translates to:
  /// **'la meraviglia'**
  String get smorfia72;

  /// No description provided for @smorfia73.
  ///
  /// In it, this message translates to:
  /// **'l\'ospedale'**
  String get smorfia73;

  /// No description provided for @smorfia74.
  ///
  /// In it, this message translates to:
  /// **'la grotta'**
  String get smorfia74;

  /// No description provided for @smorfia75.
  ///
  /// In it, this message translates to:
  /// **'Pulcinella'**
  String get smorfia75;

  /// No description provided for @smorfia76.
  ///
  /// In it, this message translates to:
  /// **'la fontana'**
  String get smorfia76;

  /// No description provided for @smorfia77.
  ///
  /// In it, this message translates to:
  /// **'le gambe'**
  String get smorfia77;

  /// No description provided for @smorfia78.
  ///
  /// In it, this message translates to:
  /// **'la bella'**
  String get smorfia78;

  /// No description provided for @smorfia79.
  ///
  /// In it, this message translates to:
  /// **'il ladro'**
  String get smorfia79;

  /// No description provided for @smorfia80.
  ///
  /// In it, this message translates to:
  /// **'la bocca'**
  String get smorfia80;

  /// No description provided for @smorfia81.
  ///
  /// In it, this message translates to:
  /// **'i fiori'**
  String get smorfia81;

  /// No description provided for @smorfia82.
  ///
  /// In it, this message translates to:
  /// **'la tavola'**
  String get smorfia82;

  /// No description provided for @smorfia83.
  ///
  /// In it, this message translates to:
  /// **'il maltempo'**
  String get smorfia83;

  /// No description provided for @smorfia84.
  ///
  /// In it, this message translates to:
  /// **'la chiesa'**
  String get smorfia84;

  /// No description provided for @smorfia85.
  ///
  /// In it, this message translates to:
  /// **'le anime'**
  String get smorfia85;

  /// No description provided for @smorfia86.
  ///
  /// In it, this message translates to:
  /// **'la bottega'**
  String get smorfia86;

  /// No description provided for @smorfia87.
  ///
  /// In it, this message translates to:
  /// **'i pidocchi'**
  String get smorfia87;

  /// No description provided for @smorfia88.
  ///
  /// In it, this message translates to:
  /// **'i caciocavalli'**
  String get smorfia88;

  /// No description provided for @smorfia89.
  ///
  /// In it, this message translates to:
  /// **'la vecchia'**
  String get smorfia89;

  /// No description provided for @smorfia90.
  ///
  /// In it, this message translates to:
  /// **'la paura'**
  String get smorfia90;

  /// No description provided for @smorfia91.
  ///
  /// In it, this message translates to:
  /// **'non c\'è'**
  String get smorfia91;

  /// No description provided for @smorfia92.
  ///
  /// In it, this message translates to:
  /// **'l\'uranio'**
  String get smorfia92;

  /// No description provided for @smorfia93.
  ///
  /// In it, this message translates to:
  /// **'la app'**
  String get smorfia93;

  /// No description provided for @smorfia94.
  ///
  /// In it, this message translates to:
  /// **'il plutonio'**
  String get smorfia94;

  /// No description provided for @smorfia95.
  ///
  /// In it, this message translates to:
  /// **'la finestra'**
  String get smorfia95;

  /// No description provided for @smorfia96.
  ///
  /// In it, this message translates to:
  /// **'sottosopra'**
  String get smorfia96;

  /// No description provided for @smorfia97.
  ///
  /// In it, this message translates to:
  /// **'la smorfia'**
  String get smorfia97;

  /// No description provided for @smorfia98.
  ///
  /// In it, this message translates to:
  /// **'il collegio'**
  String get smorfia98;

  /// No description provided for @smorfia99.
  ///
  /// In it, this message translates to:
  /// **'il bilico'**
  String get smorfia99;

  /// No description provided for @shotStory1.
  ///
  /// In it, this message translates to:
  /// **' ha fatto del suo meglio'**
  String shotStory1(String gender);

  /// No description provided for @shotStory2.
  ///
  /// In it, this message translates to:
  /// **' ha giocato pulito'**
  String shotStory2(String gender);

  /// No description provided for @shotStory3.
  ///
  /// In it, this message translates to:
  /// **' ha fatto la sua mossa'**
  String shotStory3(String gender);

  /// No description provided for @shotStorySuffix1.
  ///
  /// In it, this message translates to:
  /// **' in un istante'**
  String get shotStorySuffix1;

  /// No description provided for @shotStorySuffix2.
  ///
  /// In it, this message translates to:
  /// **' con rapidità'**
  String get shotStorySuffix2;

  /// No description provided for @shotStorySuffix3.
  ///
  /// In it, this message translates to:
  /// **' con calma'**
  String get shotStorySuffix3;

  /// No description provided for @shotStorySuffix4.
  ///
  /// In it, this message translates to:
  /// **' con molta calma'**
  String get shotStorySuffix4;

  /// No description provided for @shotStorySuffix5.
  ///
  /// In it, this message translates to:
  /// **' in tempi geologici'**
  String get shotStorySuffix5;

  /// No description provided for @shotStorySuffix6.
  ///
  /// In it, this message translates to:
  /// **' in tempi astronomici'**
  String get shotStorySuffix6;

  /// No description provided for @stop.
  ///
  /// In it, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @stopwatchMemo1.
  ///
  /// In it, this message translates to:
  /// **'Ricordate:\n'**
  String get stopwatchMemo1;

  /// No description provided for @stopwatchMemo2.
  ///
  /// In it, this message translates to:
  /// **'L\'orologio non deve per forza essere fermato al primo giro! '**
  String get stopwatchMemo2;

  /// No description provided for @stopwatchMemo3.
  ///
  /// In it, this message translates to:
  /// **'Se avete superato lo zero, conviene aspettare il giro successivo.\n'**
  String get stopwatchMemo3;

  /// No description provided for @pickAnotherStraw.
  ///
  /// In it, this message translates to:
  /// **'Prendine un altro'**
  String get pickAnotherStraw;

  /// No description provided for @scores.
  ///
  /// In it, this message translates to:
  /// **'Punteggi'**
  String get scores;

  /// No description provided for @collectedNStars.
  ///
  /// In it, this message translates to:
  /// **'Hai raccolto {n} {n, plural, =1{stella} other{stelle}}{emotion, select, bad{…} meh{.} other{!}}'**
  String collectedNStars(int n, String emotion);

  /// No description provided for @compareWithPreviousScores.
  ///
  /// In it, this message translates to:
  /// **'Confrontalo coi risultati precedenti.'**
  String get compareWithPreviousScores;

  /// No description provided for @notDrinking.
  ///
  /// In it, this message translates to:
  /// **'Senza bere:'**
  String get notDrinking;

  /// No description provided for @drinking.
  ///
  /// In it, this message translates to:
  /// **'Bevendo:'**
  String get drinking;

  /// No description provided for @prepareForChallenge.
  ///
  /// In it, this message translates to:
  /// **'Prepare for the challenge'**
  String get prepareForChallenge;

  /// No description provided for @placePhoneHorizontally.
  ///
  /// In it, this message translates to:
  /// **'Place the phone horizontally before proceeding.'**
  String get placePhoneHorizontally;

  /// No description provided for @done.
  ///
  /// In it, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @preparingForChallenge.
  ///
  /// In it, this message translates to:
  /// **'Preparing for the challenge'**
  String get preparingForChallenge;

  /// No description provided for @whatsYourName.
  ///
  /// In it, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// No description provided for @iHaveDrunk.
  ///
  /// In it, this message translates to:
  /// **'I have drunk alcohol'**
  String get iHaveDrunk;

  /// No description provided for @iHaveNotDrunk.
  ///
  /// In it, this message translates to:
  /// **'I have not drunk alcohol'**
  String get iHaveNotDrunk;

  /// No description provided for @youCanStart.
  ///
  /// In it, this message translates to:
  /// **'Si può iniziare'**
  String get youCanStart;

  /// No description provided for @softwareLicences.
  ///
  /// In it, this message translates to:
  /// **'Licenze software'**
  String get softwareLicences;

  /// No description provided for @appName.
  ///
  /// In it, this message translates to:
  /// **'Guidi Tu'**
  String get appName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
