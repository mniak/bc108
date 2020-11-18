import 'package:bc108/src/layer2/exports.dart';
import 'package:bc108/src/layer3/commands/get_info.dart';
import 'package:bc108/src/layer3/factory.dart';
import 'package:bc108/src/layer3/handler.dart';
import 'package:bc108/src/layer3/pinpad.dart';
import 'package:bc108/src/layer3/pinpad_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class OperatorMock extends Mock implements Operator {}

class RequestHandlerFactoryMock extends Mock implements RequestHandlerFactory {}

class RequestHandlerMock<TRequest, TResponse> extends Mock
    implements RequestHandler<TRequest, TResponse> {}

class PinpadResultMock<T> extends Mock implements PinpadResult<T> {}

class SUT {
  Operator oper;
  RequestHandlerFactory handlerFactory;
  Pinpad pinpad;

  SUT() {
    oper = OperatorMock();
    handlerFactory = RequestHandlerFactoryMock();
    pinpad = Pinpad(oper, handlerFactory);
  }
}

void main() {
  test('bypass close signal', () {
    final sut = SUT();
    sut.pinpad.close();
    verify(sut.oper.close()).called(1);
  });

  // test('table load init', () async {
  //   final sut = SUT();
  //   final requestHandler = RequestHandlerMock<TableLoadInitRequest>();
  //   final pinpadResult = PinpadResultMock<GetInfo00Response>();

  //   when(requestHandler.handle(any))
  //       .thenAnswer((_) => Future.value(pinpadResult));
  //   when(sut.handlerFactory.getInfo(sut.oper)).thenReturn(requestHandler);

  //   final result = await sut.pinpad.getInfo00();
  //   expect(result, equals(pinpadResult));
  // });

  test('get info 00', () async {
    final sut = SUT();
    final requestHandler = RequestHandlerMock<void, GetInfo00Response>();
    final pinpadResult = PinpadResultMock<GetInfo00Response>();

    when(requestHandler.handle(any))
        .thenAnswer((_) => Future.value(pinpadResult));
    when(sut.handlerFactory.getInfo(sut.oper)).thenReturn(requestHandler);

    final result = await sut.pinpad.getInfo00();
    expect(result, equals(pinpadResult));
  });
}
