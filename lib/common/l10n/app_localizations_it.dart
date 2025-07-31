// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get whoDrivesTonight => 'Chi guida stasera?';

  @override
  String get whoPaysTonight => 'Chi paga stasera?';

  @override
  String get findOutPlaying => 'Decidetelo giocando!';

  @override
  String get play => 'Gioca';

  @override
  String get playAgain => 'Gioca di nuovo';

  @override
  String get info => 'Informazioni';

  @override
  String get challenge => 'Prova di abilità';

  @override
  String get changeLanguage => '🌐 Cambia lingua';

  @override
  String get downloadFromGooglePlay => 'Scarica da Google Play';

  @override
  String get downloadFromAppStore => 'Scarica da App Store';

  @override
  String get logoPath => 'assets/images/title/logo_it.png';

  @override
  String get howDoesItWork => 'Come funziona?';

  @override
  String get proceed => 'Avanti';

  @override
  String get tutorial1 =>
      '\nChi beve alcolici non guida, **troppo pericoloso**.\n\nOgni gruppo dovrebbe avere un **Guidatore Sobrio**.\n';

  @override
  String get tutorial2 =>
      '\nGiocando a uno dei minigiochi di questa app, si stabilisce chi beve e chi guida.\n\n**Chi arriva ultimo, guida e non beve**.\n';

  @override
  String get tutorial3 =>
      '\nMa attenzione: **chi arriva primo, può bere ma deve pagare**.\n\nQuindi, conviene arrivare a metà classifica!';

  @override
  String get tutorial4 =>
      '\nPenalità possibili per chi arriva primo:\n* Pagare analcolici al Guidatore Sobrio?\n* Offrire snack a tutti?\n* Pagare la benzina?\n';

  @override
  String get defaultPlayerNames => 'ALE,FEDE,GIO,MICHI,ROBI,SIMO,VALE';

  @override
  String get duplicatesWarningTitle => 'Nomi duplicati.';

  @override
  String get duplicatesWarning =>
      'Alcuni nomi sono uguali tra loro, per favore cambiali.';

  @override
  String get addPlayersWarning => 'Aggiungi almeno 2 partecipanti per favore.';

  @override
  String get registerPlayers => 'Registra partecipanti';

  @override
  String get clickNamesToEdit => 'Clicca sui nomi per modificarli:';

  @override
  String get addPlayer => 'Aggiungi partecipante';

  @override
  String playersReady(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Pronti',
        'f': 'Pronte',
        'other': 'Si inizia',
      },
    );
    return '$_temp0';
  }

  @override
  String get editPlayer => 'Modifica partecipante';

  @override
  String get setFemininePlayer => 'Chiamala «giocatrice»';

  @override
  String get setMasculinePlayer => 'Chiamalo «giocatore»';

  @override
  String get setNeutralPlayer => 'Nessuna preferenza';

  @override
  String maxNLetters(int n) {
    return 'Massimo $n lettere';
  }

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get pickDiscipline => 'Scegli una disciplina';

  @override
  String get recommendedDiscipline => 'Suggerita';

  @override
  String get itsTurnOf => 'Tocca a';

  @override
  String get tieBreaker => 'A pari merito, conta la velocità.';

  @override
  String iAmReady(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Sono pronto',
        'f': 'Sono pronta',
        'other': 'Eccomi',
      },
    );
    return '$_temp0';
  }

  @override
  String everyonePlayed(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Hanno giocato tutti',
        'f': 'Hanno giocato tutte',
        'other': 'Ogni persona ha giocato',
      },
    );
    return '$_temp0';
  }

  @override
  String generousDesignatedBenefactor(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Generoso Benefattore Designato',
        'f': 'Generosa Benefattrice Designata',
        'other': 'Responsabile della Generosa Beneficenza',
      },
    );
    return '$_temp0';
  }

  @override
  String authorisedDrinker(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Bevitore Autorizzato',
        'f': 'Bevitrice Autorizzata',
        'other': 'Persona Autorizzata a Bere',
      },
    );
    return '$_temp0';
  }

  @override
  String soberDesignatedDriver(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'Guidatore Sobrio Designato',
        'f': 'Guidatrice Sobria Designata',
        'other': 'Responsabile della Guida Sobria',
      },
    );
    return '$_temp0';
  }

  @override
  String shot0(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': ' è stato immobile',
        'f': ' è stata immobile',
        'other': ' non ha mosso un dito',
      },
    );
    return '$_temp0';
  }

  @override
  String shotOver100(String gender) {
    return ' ha assaltato il cielo';
  }

  @override
  String shotUnderMinus100(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': ' è disceso negli inferi',
        'f': ' è discesa negli inferi',
        'other': ' ha raggiunto gli inferi',
      },
    );
    return '$_temp0';
  }

  @override
  String shotOverAbsolute20(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': ' si è dato da fare',
        'f': ' si è data da fare',
        'other': ' ci ha messo impegno',
      },
    );
    return '$_temp0';
  }

  @override
  String steadyHandStory1(String gender) {
    return ' ha resistito';
  }

  @override
  String steadyHandStory2(String gender) {
    return ' ha tenuto duro';
  }

  @override
  String steadyHandStory3(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'm': 'rimasto',
        'f': 'rimasta',
        'other': 'ancora',
      },
    );
    return 'è $_temp0 in sella';
  }

  @override
  String get steadyHandStorySuffix1 => ' pochissimo';

  @override
  String get steadyHandStorySuffix2 => ' dignitosamente';

  @override
  String get steadyHandStorySuffix3 => ' un bel po\'';

  @override
  String get steadyHandStorySuffix4 => ' a lungo';

  @override
  String get playSecretlyTitle => 'Gioca di nascosto';

  @override
  String get playSecretly =>
      'Non mostrare la tua mossa a chi non ha ancora giocato.';

  @override
  String get iAmDone => 'Ho finito!';

  @override
  String get outcome => 'Risultati';

  @override
  String get ranking => 'Classifica';

  @override
  String get finalResults => 'I risultati finali sono pronti…';

  @override
  String get seeFinalResults => 'Vediamoli!';

  @override
  String get seeRanking => 'E ora vediamo la classifica!';

  @override
  String get canDrinkButMustPay => 'Può bere ma paga';

  @override
  String canDrink(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Possono',
      one: 'Può',
    );
    return '$_temp0 bere';
  }

  @override
  String get drivesAndDoesntDrink => 'Guida e non beve';

  @override
  String get end => 'Fine';

  @override
  String get disclaimer =>
      'Applicazione realizzata nell\'ambito del progetto Safe & Drive, finanziato dal Consiglio dei Ministri — Dipartimento per le Politiche Antidroga, che ha come capofila la Città di Cuneo. L\'obiettivo principale è la riduzione degli incidenti stradali correlati al consumo di alcol e sostanze.';

  @override
  String get mainCredits =>
      'Prodotta da **cooperativa sociale Alice**\n\nPensata e sviluppata da **Mauro Vanetti**\n\nDisegni e animazioni di **Jacopo Rovida**\n\nLocalizzazione curata da **Mauro Vanetti**\n\nCollaudo e preziosi consigli di **Jacopo Rovida**';

  @override
  String get freeSoftwareCredits =>
      'Questa app è software libero. Tutto il codice sorgente e gli asset si trovano su GitHub (maurovanetti/guidi-tu) e possono essere riutilizzati purché non a scopo di lucro secondo la licenza indicata nel repository.\nSe volete aggiungere un minigioco, segnalare dei bug, proporre migliorie, aggiungere traduzioni, intervenite pure direttamente lì.';

  @override
  String get sponsorsPath => 'assets/images/info/sponsors.png';

  @override
  String elapsedTime(int seconds) {
    return 'Tempo trascorso: $seconds\"';
  }

  @override
  String xCentimeters(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 1);
    final String xString = xNumberFormat.format(x);

    return '$xString';
  }

  @override
  String xSeconds(double x) {
    final intl.NumberFormat xNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
            locale: localeName, decimalDigits: 2);
    final String xString = xNumberFormat.format(x);

    return '$xString\"';
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

    return '$xString\"';
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
  String get longShotName => 'Spararla grossa';

  @override
  String get longShotDescription => 'Scegli un numero alto.';

  @override
  String get longShotExplanation =>
      'Guidi tu se scegli il numero più basso.\n\nMa attenzione: chi sceglie il numero più alto, paga.';

  @override
  String get shortShotName => 'Cadere in basso';

  @override
  String get shortShotDescription => 'Scegli un numero basso.';

  @override
  String get shortShotExplanation =>
      'Guidi tu se scegli il numero più alto.\n\nMa attenzione: chi sceglie il numero più basso, paga.';

  @override
  String get morraName => 'Morra';

  @override
  String get morraDescription => 'Indovina la somma.';

  @override
  String get morraExplanation =>
      'Scegli quante dita mostrare e prevedi quante dita saranno mostrate da tutti.\n\nGuidi tu se ti avvicini di meno alla somma giusta.\n\nMa attenzione: chi si avvicina di più, paga.';

  @override
  String get battleshipName => 'Battaglia navale';

  @override
  String get battleshipDescription => 'Salva e affonda.';

  @override
  String battleshipExplanation(int pointsPerRescue, int pointsPerHit) {
    return 'Scegli dove collocare i tuoi galleggianti e in quali caselle attaccare.\n\nFai \$$pointsPerRescue punti per ogni tuo galleggiante salvato, \$$pointsPerHit per ognuno che affondi.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.';
  }

  @override
  String get stopwatchName => 'Cronometro';

  @override
  String get stopwatchDescription => 'Spacca il secondo.';

  @override
  String get stopwatchExplanation =>
      'La lancetta gira velocemente. Puoi fermarla quando vuoi.\n\nSe supera il mezzogiorno, ricomincia da zero.\n\nGuidi tu se hai fermato la lancetta al valore più basso.\n\nMa attenzione: chi la ferma più avanti di tutti, paga.';

  @override
  String get steadyHandName => 'Mano ferma';

  @override
  String get steadyHandDescription => 'Resisti immobile.';

  @override
  String get steadyHandExplanation =>
      'Tieni il telefono in orizzontale sulla tua mano.\n\nNon far cadere la biglia.\n\nGuidi tu se resisti meno di tutti.\n\nMa attenzione: chi resiste più a lungo, paga.';

  @override
  String get ouijaName => 'Telepatia';

  @override
  String get ouijaDescription => 'Indovina la parola.';

  @override
  String ouijaExplanation(int pointsPerMiss, int pointsPerGuess) {
    return 'Componi una sequenza di lettere.\n\nFai $pointsPerMiss pt. per ogni lettera usata anche da altri,\n\$$pointsPerGuess pt. se è anche nella stessa posizione.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.';
  }

  @override
  String get rpsName => 'Morra cinese';

  @override
  String get rpsDescription => 'Sasso, carta o forbici?';

  @override
  String get rpsExplanation =>
      'Componi una sequenza di gesti.\n\nAd ogni turno, chi è nel gruppo vincente ad ogni turno vince un punto.\n\nGuida chi fa meno punti.\n\nMa attenzione: chi ne fa di più, paga.';

  @override
  String get strawsName => 'Bastoncino corto';

  @override
  String get strawsDescription => 'Scegli un bastoncino.';

  @override
  String get strawsExplanation =>
      'Puoi cambiare bastoncino finché non ne trovi uno che ti piace.\n\nGuidi tu se lo scegli più corto degli altri.\n\nMa attenzione: chi sceglie il più lungo, paga.';

  @override
  String get boulesName => 'Bocce';

  @override
  String get boulesDescription => 'Avvicinati al boccino.';

  @override
  String get boulesExplanation =>
      'Due bocce a testa, conta solo il tiro migliore.\n\nScegli la direzione e la forza dei lanci.\n\nGuidi tu se alla fine la boccia più lontana dal boccino bianco è la tua.\n\nMa attenzione: chi avrà la boccia più vicina al boccino, paga.';

  @override
  String get quitTitle => 'Interruzione del gioco';

  @override
  String get quitMessage =>
      'Vuoi davvero interrompere il gioco?\nFarai una figura da guastafeste!';

  @override
  String get quitConfirm => 'Ferma tutto';

  @override
  String get quitCancel => 'Continua a giocare';

  @override
  String get dragFloaters => 'Trascina i galleggianti nelle caselle';

  @override
  String get chooseTargets => 'E ora decidi dove colpire';

  @override
  String nPointsPerSave(int n) {
    return '$n pt. per ogni galleggiante salvato.';
  }

  @override
  String nPointsPerHit(int n) {
    return '$n pt. per ogni colpo andato a segno.';
  }

  @override
  String get dragAndRelease => 'Trascina la freccia e poi lascia andare';

  @override
  String get waitForBoules => 'Aspettiamo che le bocce si fermino…';

  @override
  String get onlyOneBowlCounts =>
      'Conta solo la boccia migliore di ogni partecipante';

  @override
  String get total => 'SOMMA =';

  @override
  String get totalFingers => 'Totale dita: ';

  @override
  String get essentialAlphabet => 'ABCDEFGHILMNOPQRSTUVZ';

  @override
  String get extraAlphabet => 'JKWXY';

  @override
  String nPointsPerFullGuess(int n) {
    return '$n pt. per lettera indovinata.';
  }

  @override
  String nPointsPerPartialGuess(int n) {
    return '$n pt. per lettera nel posto sbagliato.';
  }

  @override
  String get onePointPerWin => '1 pt. per giocata vincente.';

  @override
  String get zeroPointsPerTie => '0 pt. per pareggio o stallo.';

  @override
  String get longTapToReset => 'Tieni premuto per azzerare';

  @override
  String get smorfia0 => 'il neonato';

  @override
  String get smorfia1 => 'l\'Italia';

  @override
  String get smorfia2 => 'la bambina';

  @override
  String get smorfia3 => 'la gatta';

  @override
  String get smorfia4 => 'il maialino';

  @override
  String get smorfia5 => 'la mano';

  @override
  String get smorfia6 => 'guarda giù';

  @override
  String get smorfia7 => 'il vaso';

  @override
  String get smorfia8 => 'la vergine';

  @override
  String get smorfia9 => 'i figli';

  @override
  String get smorfia10 => 'i fagioli';

  @override
  String get smorfia11 => 'i topini';

  @override
  String get smorfia12 => 'il soldato';

  @override
  String get smorfia13 => 'il santo';

  @override
  String get smorfia14 => 'l\'etilometro';

  @override
  String get smorfia15 => 'il ragazzo';

  @override
  String get smorfia16 => 'il sedere';

  @override
  String get smorfia17 => 'la sfortuna';

  @override
  String get smorfia18 => 'il sangue';

  @override
  String get smorfia19 => 'la risata';

  @override
  String get smorfia20 => 'la festa';

  @override
  String get smorfia21 => 'senza vestiti';

  @override
  String get smorfia22 => 'il matto';

  @override
  String get smorfia23 => 'il tonto';

  @override
  String get smorfia24 => 'le guardie';

  @override
  String get smorfia25 => 'Natale';

  @override
  String get smorfia26 => 'la santa';

  @override
  String get smorfia27 => 'il pitale';

  @override
  String get smorfia28 => 'i seni';

  @override
  String get smorfia29 => 'il papà';

  @override
  String get smorfia30 => 'il tenente';

  @override
  String get smorfia31 => 'il padrone';

  @override
  String get smorfia32 => 'il capitone';

  @override
  String get smorfia33 => 'gli anni';

  @override
  String get smorfia34 => 'la testa';

  @override
  String get smorfia35 => 'l\'uccellino';

  @override
  String get smorfia36 => 'le nacchere';

  @override
  String get smorfia37 => 'il monaco';

  @override
  String get smorfia38 => 'le botte';

  @override
  String get smorfia39 => 'il nodo';

  @override
  String get smorfia40 => 'la noia';

  @override
  String get smorfia41 => 'il coltello';

  @override
  String get smorfia42 => 'il caffè';

  @override
  String get smorfia43 => 'il gossip';

  @override
  String get smorfia44 => 'la prigione';

  @override
  String get smorfia45 => 'l\'acqua minerale';

  @override
  String get smorfia46 => 'i soldi';

  @override
  String get smorfia47 => 'lo scheletro';

  @override
  String get smorfia48 => 'che parla';

  @override
  String get smorfia49 => 'la carne';

  @override
  String get smorfia50 => 'il pane';

  @override
  String get smorfia51 => 'il giardino';

  @override
  String get smorfia52 => 'la mamma';

  @override
  String get smorfia53 => 'il vecchio';

  @override
  String get smorfia54 => 'il cappello';

  @override
  String get smorfia55 => 'la musica';

  @override
  String get smorfia56 => 'la caduta';

  @override
  String get smorfia57 => 'il gobbo';

  @override
  String get smorfia58 => 'il rider';

  @override
  String get smorfia59 => 'i peli';

  @override
  String get smorfia60 => 'il lamento';

  @override
  String get smorfia61 => 'il cacciatore';

  @override
  String get smorfia62 => 'la preda';

  @override
  String get smorfia63 => 'la sposa';

  @override
  String get smorfia64 => 'il frac';

  @override
  String get smorfia65 => 'il pianto';

  @override
  String get smorfia66 => 'le due single';

  @override
  String get smorfia67 => 'nella chitarra';

  @override
  String get smorfia68 => 'la zuppa';

  @override
  String get smorfia69 => 'sottosopra';

  @override
  String get smorfia70 => 'il palazzo';

  @override
  String get smorfia71 => 'l\'omaccio';

  @override
  String get smorfia72 => 'la meraviglia';

  @override
  String get smorfia73 => 'l\'ospedale';

  @override
  String get smorfia74 => 'la grotta';

  @override
  String get smorfia75 => 'Pulcinella';

  @override
  String get smorfia76 => 'la fontana';

  @override
  String get smorfia77 => 'le gambe';

  @override
  String get smorfia78 => 'la bella';

  @override
  String get smorfia79 => 'il ladro';

  @override
  String get smorfia80 => 'la bocca';

  @override
  String get smorfia81 => 'i fiori';

  @override
  String get smorfia82 => 'la tavola';

  @override
  String get smorfia83 => 'il maltempo';

  @override
  String get smorfia84 => 'la chiesa';

  @override
  String get smorfia85 => 'le anime';

  @override
  String get smorfia86 => 'la bottega';

  @override
  String get smorfia87 => 'i pidocchi';

  @override
  String get smorfia88 => 'i caciocavalli';

  @override
  String get smorfia89 => 'la vecchia';

  @override
  String get smorfia90 => 'la paura';

  @override
  String get smorfia91 => 'non c\'è';

  @override
  String get smorfia92 => 'l\'uranio';

  @override
  String get smorfia93 => 'la app';

  @override
  String get smorfia94 => 'il plutonio';

  @override
  String get smorfia95 => 'la finestra';

  @override
  String get smorfia96 => 'sottosopra';

  @override
  String get smorfia97 => 'la smorfia';

  @override
  String get smorfia98 => 'il collegio';

  @override
  String get smorfia99 => 'il bilico';

  @override
  String shotStory1(String gender) {
    return ' ha fatto del suo meglio';
  }

  @override
  String shotStory2(String gender) {
    return ' ha giocato pulito';
  }

  @override
  String shotStory3(String gender) {
    return ' ha fatto la sua mossa';
  }

  @override
  String get shotStorySuffix1 => ' in un istante';

  @override
  String get shotStorySuffix2 => ' con rapidità';

  @override
  String get shotStorySuffix3 => ' con calma';

  @override
  String get shotStorySuffix4 => ' con molta calma';

  @override
  String get shotStorySuffix5 => ' in tempi geologici';

  @override
  String get shotStorySuffix6 => ' in tempi astronomici';

  @override
  String get stop => 'STOP';

  @override
  String get stopwatchMemo1 => 'Ricordate:\n';

  @override
  String get stopwatchMemo2 =>
      'L\'orologio non deve per forza essere fermato al primo giro! ';

  @override
  String get stopwatchMemo3 =>
      'Se avete superato lo zero, conviene aspettare il giro successivo.\n';

  @override
  String get pickAnotherStraw => 'Prendine un altro';

  @override
  String get scores => 'Punteggi';

  @override
  String collectedNStars(int n, String emotion) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'stelle',
      one: 'stella',
    );
    String _temp1 = intl.Intl.selectLogic(
      emotion,
      {
        'bad': '…',
        'meh': '.',
        'other': '!',
      },
    );
    return 'Hai raccolto $n $_temp0$_temp1';
  }

  @override
  String get compareWithPreviousScores =>
      'Confrontalo coi risultati precedenti.';

  @override
  String get notDrinking => 'Senza bere:';

  @override
  String get drinking => 'Bevendo:';

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
  String get youCanStart => 'Si può iniziare';

  @override
  String get softwareLicences => 'Licenze software';

  @override
  String get appName => 'Guidi Tu';
}
