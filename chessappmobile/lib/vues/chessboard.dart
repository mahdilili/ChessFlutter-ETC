import 'package:chessappmobile/controleurs/board_controleur.dart';
import 'package:chessappmobile/models/piece.dart';
import 'package:flutter/material.dart';

import '../models/square.dart';

class GameBoard extends StatefulWidget{
 const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}
  BoardControleur bc = BoardControleur();

class _GameBoardState extends State<GameBoard> {

  ChessPiece piecePawn = ChessPiece(
      PieceType:ChessPieceType.pawn, isWhite:false, PathToImage:'lib/images/pawn.png');
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GridView.builder (
        itemCount: 8*8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), //Pour une grille 8 par 8
          itemBuilder: (context,  index) {
            return Square(
            isWhite: bc.isWhite(index),
            piece: piecePawn,

            );
          },
      ),
    );
  }
}