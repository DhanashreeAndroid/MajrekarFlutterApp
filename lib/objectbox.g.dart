// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model/DataModel.dart';
import 'model/UserModel.dart';
import 'model/VidhansabhaModel.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 6636755008911549707),
      name: 'EDetails',
      lastPropertyId: const IdUid(22, 782532491152360915),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1762073143439133799),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2834582806241126448),
            name: 'dbId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2772511510961918956),
            name: 'wardNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1366990061502476744),
            name: 'partNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5133627295665355016),
            name: 'serialNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4352255438371112960),
            name: 'cardNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1887852847113926454),
            name: 'lnEnglish',
            type: 9,
            flags: 8,
            indexId: const IdUid(1, 3140573368655584199)),
        ModelProperty(
            id: const IdUid(8, 1058148144439741616),
            name: 'fnEnglish',
            type: 9,
            flags: 8,
            indexId: const IdUid(2, 3867627287615291860)),
        ModelProperty(
            id: const IdUid(9, 1754694413920988681),
            name: 'lnMarathi',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 3888492938160347825),
            name: 'fnMarathi',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8735143405934448995),
            name: 'sex',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 6137345959293516262),
            name: 'age',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 4591107189690788330),
            name: 'houseNoEnglish',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 5229266468593082086),
            name: 'houseNoMarathi',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 371378032518673098),
            name: 'buildingNameEnglish',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 7949129436597057609),
            name: 'buildingNameMarathi',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 2373184634195340912),
            name: 'boothAddressEnglish',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 9100316075312996990),
            name: 'boothAddressMarathi',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 2961089086583348719),
            name: 'lang',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 2904791910041164046),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(21, 8976071726525648302),
            name: 'shiftedDeath',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(22, 782532491152360915),
            name: 'votedNonVoted',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 3625653354348383543),
      name: 'UserDetails',
      lastPropertyId: const IdUid(16, 7172458404123359882),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3654598264177600187),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8319204328188971642),
            name: 'userName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6134236700863483652),
            name: 'password',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5757377182504372888),
            name: 'isUpdatable',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5261924795472911042),
            name: 'isMarkable',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7685014761481313936),
            name: 'isVotingMakingReport',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1642270580272926542),
            name: 'isContactReport',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2775832838439605818),
            name: 'electionDate',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4788701231861803595),
            name: 'time',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 8937664526719358331),
            name: 'lineForOnlyPrintingPurpose',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1757053480130578827),
            name: 'smsTimeLimit',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 5732567863590215243),
            name: 'vidhansabhaName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 2879495251186326496),
            name: 'macAddress',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 7605285199971227952),
            name: 'userRole',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 7172458404123359882),
            name: 'userEmail',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 1150958799004521241),
      name: 'Vidhansabha',
      lastPropertyId: const IdUid(8, 4539419067265328488),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3389405251360437120),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5774829335366522850),
            name: 'dbId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2924295297498911914),
            name: 'wardNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1639591732004670440),
            name: 'partNo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5261312038072363433),
            name: 'from',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7114988050899651310),
            name: 'to',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4652810905865183553),
            name: 'boothAddressEnglish',
            type: 9,
            flags: 8,
            indexId: const IdUid(3, 8580387892300726525)),
        ModelProperty(
            id: const IdUid(8, 4539419067265328488),
            name: 'boothAddressMarathi',
            type: 9,
            flags: 8,
            indexId: const IdUid(4, 9173619587212408139))
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 1150958799004521241),
      lastIndexId: const IdUid(4, 9173619587212408139),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [2808037037703655817],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    EDetails: EntityDefinition<EDetails>(
        model: _entities[0],
        toOneRelations: (EDetails object) => [],
        toManyRelations: (EDetails object) => {},
        getId: (EDetails object) => object.id,
        setId: (EDetails object, int id) {
          object.id = id;
        },
        objectToFB: (EDetails object, fb.Builder fbb) {
          final dbIdOffset =
              object.dbId == null ? null : fbb.writeString(object.dbId!);
          final wardNoOffset =
              object.wardNo == null ? null : fbb.writeString(object.wardNo!);
          final partNoOffset =
              object.partNo == null ? null : fbb.writeString(object.partNo!);
          final serialNoOffset = object.serialNo == null
              ? null
              : fbb.writeString(object.serialNo!);
          final cardNoOffset =
              object.cardNo == null ? null : fbb.writeString(object.cardNo!);
          final lnEnglishOffset = object.lnEnglish == null
              ? null
              : fbb.writeString(object.lnEnglish!);
          final fnEnglishOffset = object.fnEnglish == null
              ? null
              : fbb.writeString(object.fnEnglish!);
          final lnMarathiOffset = object.lnMarathi == null
              ? null
              : fbb.writeString(object.lnMarathi!);
          final fnMarathiOffset = object.fnMarathi == null
              ? null
              : fbb.writeString(object.fnMarathi!);
          final sexOffset =
              object.sex == null ? null : fbb.writeString(object.sex!);
          final ageOffset =
              object.age == null ? null : fbb.writeString(object.age!);
          final houseNoEnglishOffset = object.houseNoEnglish == null
              ? null
              : fbb.writeString(object.houseNoEnglish!);
          final houseNoMarathiOffset = object.houseNoMarathi == null
              ? null
              : fbb.writeString(object.houseNoMarathi!);
          final buildingNameEnglishOffset = object.buildingNameEnglish == null
              ? null
              : fbb.writeString(object.buildingNameEnglish!);
          final buildingNameMarathiOffset = object.buildingNameMarathi == null
              ? null
              : fbb.writeString(object.buildingNameMarathi!);
          final boothAddressEnglishOffset = object.boothAddressEnglish == null
              ? null
              : fbb.writeString(object.boothAddressEnglish!);
          final boothAddressMarathiOffset = object.boothAddressMarathi == null
              ? null
              : fbb.writeString(object.boothAddressMarathi!);
          final langOffset =
              object.lang == null ? null : fbb.writeString(object.lang!);
          final colorOffset =
              object.color == null ? null : fbb.writeString(object.color!);
          final shiftedDeathOffset = object.shiftedDeath == null
              ? null
              : fbb.writeString(object.shiftedDeath!);
          final votedNonVotedOffset = object.votedNonVoted == null
              ? null
              : fbb.writeString(object.votedNonVoted!);
          fbb.startTable(23);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, dbIdOffset);
          fbb.addOffset(2, wardNoOffset);
          fbb.addOffset(3, partNoOffset);
          fbb.addOffset(4, serialNoOffset);
          fbb.addOffset(5, cardNoOffset);
          fbb.addOffset(6, lnEnglishOffset);
          fbb.addOffset(7, fnEnglishOffset);
          fbb.addOffset(8, lnMarathiOffset);
          fbb.addOffset(9, fnMarathiOffset);
          fbb.addOffset(10, sexOffset);
          fbb.addOffset(11, ageOffset);
          fbb.addOffset(12, houseNoEnglishOffset);
          fbb.addOffset(13, houseNoMarathiOffset);
          fbb.addOffset(14, buildingNameEnglishOffset);
          fbb.addOffset(15, buildingNameMarathiOffset);
          fbb.addOffset(16, boothAddressEnglishOffset);
          fbb.addOffset(17, boothAddressMarathiOffset);
          fbb.addOffset(18, langOffset);
          fbb.addOffset(19, colorOffset);
          fbb.addOffset(20, shiftedDeathOffset);
          fbb.addOffset(21, votedNonVotedOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);
          final dbIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final wardNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final partNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 10);
          final serialNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 12);
          final cardNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final lnEnglishParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 16);
          final fnEnglishParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final lnMarathiParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 20);
          final fnMarathiParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 22);
          final sexParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 24);
          final ageParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 26);
          final houseNoEnglishParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 28);
          final houseNoMarathiParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 30);
          final buildingNameEnglishParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 32);
          final buildingNameMarathiParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 34);
          final boothAddressEnglishParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 36);
          final boothAddressMarathiParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 38);
          final langParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 40);
          final colorParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 42);
          final shiftedDeathParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 44);
          final votedNonVotedParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 46);
          final object = EDetails(
              id: idParam,
              dbId: dbIdParam,
              wardNo: wardNoParam,
              partNo: partNoParam,
              serialNo: serialNoParam,
              cardNo: cardNoParam,
              lnEnglish: lnEnglishParam,
              fnEnglish: fnEnglishParam,
              lnMarathi: lnMarathiParam,
              fnMarathi: fnMarathiParam,
              sex: sexParam,
              age: ageParam,
              houseNoEnglish: houseNoEnglishParam,
              houseNoMarathi: houseNoMarathiParam,
              buildingNameEnglish: buildingNameEnglishParam,
              buildingNameMarathi: buildingNameMarathiParam,
              boothAddressEnglish: boothAddressEnglishParam,
              boothAddressMarathi: boothAddressMarathiParam,
              lang: langParam,
              color: colorParam,
              shiftedDeath: shiftedDeathParam,
              votedNonVoted: votedNonVotedParam);

          return object;
        }),
    UserDetails: EntityDefinition<UserDetails>(
        model: _entities[1],
        toOneRelations: (UserDetails object) => [],
        toManyRelations: (UserDetails object) => {},
        getId: (UserDetails object) => object.id,
        setId: (UserDetails object, int id) {
          object.id = id;
        },
        objectToFB: (UserDetails object, fb.Builder fbb) {
          final userNameOffset = object.userName == null
              ? null
              : fbb.writeString(object.userName!);
          final passwordOffset = object.password == null
              ? null
              : fbb.writeString(object.password!);
          final isUpdatableOffset = object.isUpdatable == null
              ? null
              : fbb.writeString(object.isUpdatable!);
          final isMarkableOffset = object.isMarkable == null
              ? null
              : fbb.writeString(object.isMarkable!);
          final isVotingMakingReportOffset = object.isVotingMakingReport == null
              ? null
              : fbb.writeString(object.isVotingMakingReport!);
          final isContactReportOffset = object.isContactReport == null
              ? null
              : fbb.writeString(object.isContactReport!);
          final electionDateOffset = object.electionDate == null
              ? null
              : fbb.writeString(object.electionDate!);
          final timeOffset =
              object.time == null ? null : fbb.writeString(object.time!);
          final lineForOnlyPrintingPurposeOffset =
              object.lineForOnlyPrintingPurpose == null
                  ? null
                  : fbb.writeString(object.lineForOnlyPrintingPurpose!);
          final smsTimeLimitOffset = object.smsTimeLimit == null
              ? null
              : fbb.writeString(object.smsTimeLimit!);
          final vidhansabhaNameOffset = object.vidhansabhaName == null
              ? null
              : fbb.writeString(object.vidhansabhaName!);
          final macAddressOffset = object.macAddress == null
              ? null
              : fbb.writeString(object.macAddress!);
          final userRoleOffset = object.userRole == null
              ? null
              : fbb.writeString(object.userRole!);
          final userEmailOffset = object.userEmail == null
              ? null
              : fbb.writeString(object.userEmail!);
          fbb.startTable(17);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, userNameOffset);
          fbb.addOffset(2, passwordOffset);
          fbb.addOffset(4, isUpdatableOffset);
          fbb.addOffset(5, isMarkableOffset);
          fbb.addOffset(6, isVotingMakingReportOffset);
          fbb.addOffset(7, isContactReportOffset);
          fbb.addOffset(8, electionDateOffset);
          fbb.addOffset(9, timeOffset);
          fbb.addOffset(10, lineForOnlyPrintingPurposeOffset);
          fbb.addOffset(11, smsTimeLimitOffset);
          fbb.addOffset(12, vidhansabhaNameOffset);
          fbb.addOffset(13, macAddressOffset);
          fbb.addOffset(14, userRoleOffset);
          fbb.addOffset(15, userEmailOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);
          final userNameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final userRoleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 32);
          final userEmailParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 34);
          final passwordParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final vidhansabhaNameParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 28);
          final isUpdatableParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12);
          final isMarkableParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final isVotingMakingReportParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 16);
          final isContactReportParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 18);
          final electionDateParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 20);
          final timeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 22);
          final lineForOnlyPrintingPurposeParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 24);
          final smsTimeLimitParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 26);
          final macAddressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 30);
          final object = UserDetails(
              id: idParam,
              userName: userNameParam,
              userRole: userRoleParam,
              userEmail: userEmailParam,
              password: passwordParam,
              vidhansabhaName: vidhansabhaNameParam,
              isUpdatable: isUpdatableParam,
              isMarkable: isMarkableParam,
              isVotingMakingReport: isVotingMakingReportParam,
              isContactReport: isContactReportParam,
              electionDate: electionDateParam,
              time: timeParam,
              lineForOnlyPrintingPurpose: lineForOnlyPrintingPurposeParam,
              smsTimeLimit: smsTimeLimitParam,
              macAddress: macAddressParam);

          return object;
        }),
    Vidhansabha: EntityDefinition<Vidhansabha>(
        model: _entities[2],
        toOneRelations: (Vidhansabha object) => [],
        toManyRelations: (Vidhansabha object) => {},
        getId: (Vidhansabha object) => object.id,
        setId: (Vidhansabha object, int id) {
          object.id = id;
        },
        objectToFB: (Vidhansabha object, fb.Builder fbb) {
          final dbIdOffset =
              object.dbId == null ? null : fbb.writeString(object.dbId!);
          final wardNoOffset =
              object.wardNo == null ? null : fbb.writeString(object.wardNo!);
          final partNoOffset =
              object.partNo == null ? null : fbb.writeString(object.partNo!);
          final fromOffset =
              object.from == null ? null : fbb.writeString(object.from!);
          final toOffset =
              object.to == null ? null : fbb.writeString(object.to!);
          final boothAddressEnglishOffset = object.boothAddressEnglish == null
              ? null
              : fbb.writeString(object.boothAddressEnglish!);
          final boothAddressMarathiOffset = object.boothAddressMarathi == null
              ? null
              : fbb.writeString(object.boothAddressMarathi!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, dbIdOffset);
          fbb.addOffset(2, wardNoOffset);
          fbb.addOffset(3, partNoOffset);
          fbb.addOffset(4, fromOffset);
          fbb.addOffset(5, toOffset);
          fbb.addOffset(6, boothAddressEnglishOffset);
          fbb.addOffset(7, boothAddressMarathiOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);
          final dbIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final wardNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final partNoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 10);
          final fromParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 12);
          final toParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final boothAddressEnglishParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 16);
          final boothAddressMarathiParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 18);
          final object = Vidhansabha(
              id: idParam,
              dbId: dbIdParam,
              wardNo: wardNoParam,
              partNo: partNoParam,
              from: fromParam,
              to: toParam,
              boothAddressEnglish: boothAddressEnglishParam,
              boothAddressMarathi: boothAddressMarathiParam);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [EDetails] entity fields to define ObjectBox queries.
class EDetails_ {
  /// see [EDetails.id]
  static final id = QueryIntegerProperty<EDetails>(_entities[0].properties[0]);

  /// see [EDetails.dbId]
  static final dbId = QueryStringProperty<EDetails>(_entities[0].properties[1]);

  /// see [EDetails.wardNo]
  static final wardNo =
      QueryStringProperty<EDetails>(_entities[0].properties[2]);

  /// see [EDetails.partNo]
  static final partNo =
      QueryStringProperty<EDetails>(_entities[0].properties[3]);

  /// see [EDetails.serialNo]
  static final serialNo =
      QueryStringProperty<EDetails>(_entities[0].properties[4]);

  /// see [EDetails.cardNo]
  static final cardNo =
      QueryStringProperty<EDetails>(_entities[0].properties[5]);

  /// see [EDetails.lnEnglish]
  static final lnEnglish =
      QueryStringProperty<EDetails>(_entities[0].properties[6]);

  /// see [EDetails.fnEnglish]
  static final fnEnglish =
      QueryStringProperty<EDetails>(_entities[0].properties[7]);

  /// see [EDetails.lnMarathi]
  static final lnMarathi =
      QueryStringProperty<EDetails>(_entities[0].properties[8]);

  /// see [EDetails.fnMarathi]
  static final fnMarathi =
      QueryStringProperty<EDetails>(_entities[0].properties[9]);

  /// see [EDetails.sex]
  static final sex = QueryStringProperty<EDetails>(_entities[0].properties[10]);

  /// see [EDetails.age]
  static final age = QueryStringProperty<EDetails>(_entities[0].properties[11]);

  /// see [EDetails.houseNoEnglish]
  static final houseNoEnglish =
      QueryStringProperty<EDetails>(_entities[0].properties[12]);

  /// see [EDetails.houseNoMarathi]
  static final houseNoMarathi =
      QueryStringProperty<EDetails>(_entities[0].properties[13]);

  /// see [EDetails.buildingNameEnglish]
  static final buildingNameEnglish =
      QueryStringProperty<EDetails>(_entities[0].properties[14]);

  /// see [EDetails.buildingNameMarathi]
  static final buildingNameMarathi =
      QueryStringProperty<EDetails>(_entities[0].properties[15]);

  /// see [EDetails.boothAddressEnglish]
  static final boothAddressEnglish =
      QueryStringProperty<EDetails>(_entities[0].properties[16]);

  /// see [EDetails.boothAddressMarathi]
  static final boothAddressMarathi =
      QueryStringProperty<EDetails>(_entities[0].properties[17]);

  /// see [EDetails.lang]
  static final lang =
      QueryStringProperty<EDetails>(_entities[0].properties[18]);

  /// see [EDetails.color]
  static final color =
      QueryStringProperty<EDetails>(_entities[0].properties[19]);

  /// see [EDetails.shiftedDeath]
  static final shiftedDeath =
      QueryStringProperty<EDetails>(_entities[0].properties[20]);

  /// see [EDetails.votedNonVoted]
  static final votedNonVoted =
      QueryStringProperty<EDetails>(_entities[0].properties[21]);
}

/// [UserDetails] entity fields to define ObjectBox queries.
class UserDetails_ {
  /// see [UserDetails.id]
  static final id =
      QueryIntegerProperty<UserDetails>(_entities[1].properties[0]);

  /// see [UserDetails.userName]
  static final userName =
      QueryStringProperty<UserDetails>(_entities[1].properties[1]);

  /// see [UserDetails.password]
  static final password =
      QueryStringProperty<UserDetails>(_entities[1].properties[2]);

  /// see [UserDetails.isUpdatable]
  static final isUpdatable =
      QueryStringProperty<UserDetails>(_entities[1].properties[3]);

  /// see [UserDetails.isMarkable]
  static final isMarkable =
      QueryStringProperty<UserDetails>(_entities[1].properties[4]);

  /// see [UserDetails.isVotingMakingReport]
  static final isVotingMakingReport =
      QueryStringProperty<UserDetails>(_entities[1].properties[5]);

  /// see [UserDetails.isContactReport]
  static final isContactReport =
      QueryStringProperty<UserDetails>(_entities[1].properties[6]);

  /// see [UserDetails.electionDate]
  static final electionDate =
      QueryStringProperty<UserDetails>(_entities[1].properties[7]);

  /// see [UserDetails.time]
  static final time =
      QueryStringProperty<UserDetails>(_entities[1].properties[8]);

  /// see [UserDetails.lineForOnlyPrintingPurpose]
  static final lineForOnlyPrintingPurpose =
      QueryStringProperty<UserDetails>(_entities[1].properties[9]);

  /// see [UserDetails.smsTimeLimit]
  static final smsTimeLimit =
      QueryStringProperty<UserDetails>(_entities[1].properties[10]);

  /// see [UserDetails.vidhansabhaName]
  static final vidhansabhaName =
      QueryStringProperty<UserDetails>(_entities[1].properties[11]);

  /// see [UserDetails.macAddress]
  static final macAddress =
      QueryStringProperty<UserDetails>(_entities[1].properties[12]);

  /// see [UserDetails.userRole]
  static final userRole =
      QueryStringProperty<UserDetails>(_entities[1].properties[13]);

  /// see [UserDetails.userEmail]
  static final userEmail =
      QueryStringProperty<UserDetails>(_entities[1].properties[14]);
}

/// [Vidhansabha] entity fields to define ObjectBox queries.
class Vidhansabha_ {
  /// see [Vidhansabha.id]
  static final id =
      QueryIntegerProperty<Vidhansabha>(_entities[2].properties[0]);

  /// see [Vidhansabha.dbId]
  static final dbId =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[1]);

  /// see [Vidhansabha.wardNo]
  static final wardNo =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[2]);

  /// see [Vidhansabha.partNo]
  static final partNo =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[3]);

  /// see [Vidhansabha.from]
  static final from =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[4]);

  /// see [Vidhansabha.to]
  static final to =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[5]);

  /// see [Vidhansabha.boothAddressEnglish]
  static final boothAddressEnglish =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[6]);

  /// see [Vidhansabha.boothAddressMarathi]
  static final boothAddressMarathi =
      QueryStringProperty<Vidhansabha>(_entities[2].properties[7]);
}
