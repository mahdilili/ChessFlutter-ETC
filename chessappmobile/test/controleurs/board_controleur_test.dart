

import 'package:chessappmobile/controleurs/board_controleur.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([])
void main()
{
  group('test du controleur de board', () {

  test('test du square si blanc ou noir', (){


  var bc = BoardControleur();

  int  indexBlanc =  4;
  int indexNoir = 3;

  expect(bc.isWhite(indexBlanc), true);
  expect(bc.isWhite(indexNoir), false);
  });

  test('test de l''index du square si il est dans le board ou pas',(){

    var bc = BoardControleur();
    expect(bc.isInBoard(9, 3),false);
    expect(bc.isInBoard(5, 3),true);

    });

  });
}