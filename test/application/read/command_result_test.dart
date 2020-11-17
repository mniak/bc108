import 'package:bc108/application/read/command_result.dart';
import 'package:bc108/application/read/command_result_exceptions.dart';
import 'package:bc108/application/statuses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when is null should raise error', () {
    expect(() => CommandResult.parse(null),
        throwsA(isInstanceOf<CommandResultParseException>()));
  });
  group('happy scenario when there is code and status but no parameters', () {
    group('test status code mappings', () {
      final data = [
        ["000", Status.PP_OK],
        ["001", Status.PP_PROCESSING],
        ["002", Status.PP_NOTIFY],
        ["004", Status.PP_F1],
        ["005", Status.PP_F2],
        ["006", Status.PP_F3],
        ["007", Status.PP_F4],
        ["008", Status.PP_BACKSP],
        ["010", Status.PP_INVCALL],
        ["011", Status.PP_INVPARM],
        ["012", Status.PP_TIMEOUT],
        ["013", Status.PP_CANCEL],
        ["014", Status.PP_ALREADYOPEN],
        ["015", Status.PP_NOTOPEN],
        ["016", Status.PP_EXECERR],
        ["017", Status.PP_INVMODEL],
        ["018", Status.PP_NOFUNC],
        ["020", Status.PP_TABEXP],
        ["021", Status.PP_TABERR],
        ["022", Status.PP_NOAPPLIC],
        ["030", Status.PP_PORTERR],
        ["031", Status.PP_COMMERR],
        ["032", Status.PP_UNKNOWNSTAT],
        ["033", Status.PP_RSPERR],
        ["034", Status.PP_COMMTOUT],
        ["040", Status.PP_INTERR],
        ["041", Status.PP_MCDATAERR],
        ["042", Status.PP_ERRPIN],
        ["043", Status.PP_NOCARD],
        ["044", Status.PP_PINBUSY],
        ["050", Status.PP_SAMERR],
        ["051", Status.PP_NOSAM],
        ["052", Status.PP_SAMINV],
        ["060", Status.PP_DUMBCARD],
        ["061", Status.PP_ERRCARD],
        ["062", Status.PP_CARDINV],
        ["063", Status.PP_CARDBLOCKED],
        ["064", Status.PP_CARDNAUTH],
        ["065", Status.PP_CARDEXPIRED],
        ["066", Status.PP_CARDERRSTRUCT],
        ["068", Status.PP_CARDPROBLEMS],
        ["069", Status.PP_CARDINVDATA],
        ["070", Status.PP_CARDAPPNAV],
        ["071", Status.PP_CARDAPPNAUT],
        ["072", Status.PP_NOBALANCE],
        ["073", Status.PP_LIMITEXC],
        ["074", Status.PP_CARDNOTEFFECT],
        ["075", Status.PP_VCINVCURR],
        ["076", Status.PP_ERRFALLBACK],
        ["080", Status.PP_CTLSSMULTIPLE],
        ["081", Status.PP_CTLSSCOMMERR],
        ["082", Status.PP_CTLSSINVALIDAT],
        ["083", Status.PP_CTLSSPROBLEMS],
        ["084", Status.PP_CTLSSAPPNAV],
        ["085", Status.PP_CTLSSAPPNAUT],
        // UNKNOWN STATUS
        ["086", Status.PP_UNKNOWNSTAT],
        ["087", Status.PP_UNKNOWNSTAT],
        ["088", Status.PP_UNKNOWNSTAT],
        ["089", Status.PP_UNKNOWNSTAT],
        ["090", Status.PP_UNKNOWNSTAT],
      ];
      data.forEach((d) {
        final statusCode = d[0] as String;
        final status = d[1] as Status;
        test('$statusCode -> $status', () {
          final cmdResult = CommandResult.parse("CMD" + statusCode);
          expect(cmdResult.code, equals("CMD"));
          expect(cmdResult.status, equals(status));
          expect(cmdResult.parameters, isNotNull);
          expect(cmdResult.parameters, isEmpty);
        });
      });
    });
    group('test unknown status code ranges', () {
      final ranges = [
        [32, 32],
        [9, 9],
        [23, 29],
        [35, 39],
        [45, 49],
        [53, 59],
        [77, 79],
        [86, 99],
        [100, 999],
      ];
      ranges.forEach((range) {
        for (var s = range[0]; s <= range[1]; s++) {
          test('$s should be understood as status Unknown', () {
            final cmdResult =
                CommandResult.parse("CMD" + s.toString().padLeft(3, '0'));
            expect(cmdResult.code, equals("CMD"));
            expect(cmdResult.status, equals(Status.PP_UNKNOWNSTAT));
            expect(cmdResult.parameters, isNotNull);
            expect(cmdResult.parameters, isEmpty);
          });
        }
      });
    });
  });

  group('when does not match pattern should raise error', () {
    final data = [
      "ABCD000",
      "AB000",
      "ABC01A",
      "ABCDEF",
    ];
    data.forEach((d) {
      test(d, () {
        expect(() => CommandResult.parse(d),
            throwsA(isInstanceOf<CommandResultParseException>()));
      });
    });
  });

  group(
      'when matches pattern but 1st params is badly formatted, should raise error',
      () {
    final data = [
      "CMD001" + "ABC",
      "CMD001" + "-12",
      "CMD001" + "007",
    ];
    data.forEach((d) {
      test(d, () {
        expect(() => CommandResult.parse(d),
            throwsA(isInstanceOf<CommandResultParseException>()));
      });
    });
  });

  test('happy scenario when there is code and status and one parameter', () {
    final cmdResult = CommandResult.parse("CMD000010abcdefghij");
    expect(cmdResult.code, equals("CMD"));
    expect(cmdResult.status, equals(Status.PP_OK));
    expect(cmdResult.parameters, isNotNull);
    expect(cmdResult.parameters, hasLength(1));
    expect(cmdResult.parameters, contains("abcdefghij"));
  });

  group('test unknown status code ranges', () {
    final ranges = [
      [32, 32],
      [9, 9],
      [23, 29],
      [35, 39],
      [45, 49],
      [53, 59],
      [77, 79],
      [86, 99],
      [100, 999],
    ];
    ranges.forEach((range) {
      for (var s = range[0]; s <= range[1]; s++) {
        test('$s should be understood as status Unknown', () {
          final cmdResult =
              CommandResult.parse("CMD" + s.toString().padLeft(3, '0'));
          expect(cmdResult.code, equals("CMD"));
          expect(cmdResult.status, equals(Status.PP_UNKNOWNSTAT));
          expect(cmdResult.parameters, isNotNull);
          expect(cmdResult.parameters, isEmpty);
        });
      }
    });
  });

  test(
      'when there is code and status and one parameter but the parameter size is greater thant the remaining string, should raise error',
      () {
    expect(() => CommandResult.parse("CMD000010abcde"),
        throwsA(isInstanceOf<CommandResultParseException>()));
  });
}
