import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/pinpad_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class OperatorMock extends Mock implements Operator {}

class PinpadResultBuilderMock extends Mock {
  PinpadResult call<T>(
      CommandResult commandResult, CommandResponseMapper<T> mapFn);
}

// class ResponseMock extends Mock implements GetInfo00Response {}

// class PinpadResultMock extends Mock implements PinpadResult {}

// class CommandResultMock extends Mock implements CommandResult {}

class SUT {
  Operator oper;
  Pinpad pinpad;
  PinpadResultBuilder resultBuilder;

  SUT() {
    oper = OperatorMock();
    resultBuilder = PinpadResultBuilderMock();
    pinpad = Pinpad(oper, resultBuilder);
  }
}

void main() {
  test('bypass close signal', () {
    final sut = SUT();
    sut.pinpad.close();
    verify(sut.oper.close()).called(1);
  });

//   test('get info 00', () async {
//     final sut = SUT();

//     final cmdResult = CommandResultMock();
//     final cmd = Command("GIN", ["00"]);
//     final response = ResponseMock();
//     final pinpadResult = PinpadResultMock();

//     when(sut.oper.execute(cmd)).thenAnswer((x) => Future.value(cmdResult));
//     when(cmdResult.code).thenReturn(cmd.code);
//     when(sut.resultBuilder(cmdResult, any)).thenReturn(pinpadResult);

//     final result = await sut.pinpad.getInfo00();
//     expect(result.data, equals(response));
//   });
}
