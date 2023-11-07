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

  //Liste 2D pour les pièces
  late List<List<ChessPiece?>> board;

  //initialiser le board
@override
void initState(){
  super.initState();
  _initializeBoard();
}

void _initializeBoard(){
    //initialiser le board avec des null
  List<List<ChessPiece?>> newBoard = List.generate(8, (index) =>List.generate(8, (index)=>null));
  for(int i = 0 ; i<8;i++) {
    newBoard[1][i] = ChessPiece(PieceType: ChessPieceType.pawn, isWhite: false,
        PathToImage: 'lib/images/pawn.png');
    newBoard[6][i] = ChessPiece(PieceType: ChessPieceType.pawn, isWhite: true,
        PathToImage: 'lib/images/pawn.png');
  }

  board = newBoard;
}
  ChessPiece piecePawn = ChessPiece(
      PieceType:ChessPieceType.pawn, isWhite:false, PathToImage:'lib/images/pawn.png');
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: GridView.builder (
        itemCount: 8*8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), //Pour une grille 8 par 8
          itemBuilder: (context,  index) {

          int row = index ~/8;
          int col = index % 8;
            return Square(
            isWhite: bc.isWhite(index),
            piece: board[row][col],

            );
          },
      ),
    );
  }
}