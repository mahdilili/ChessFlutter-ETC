import 'package:chessappmobile/models/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final bool isSelected;
  final bool isKingInCheck;
  final bool isValidMove;
  final void Function()? onTap;
  final ChessPiece? piece;
  final bool iswhitekingincheck;
  final bool isblackkingincheck;

  const Square({
    super.key,
    required this.isWhite,
    required this.isKingInCheck,
    required this.piece,
    required this.isSelected,
    required this.iswhitekingincheck,
    required this.isblackkingincheck,
    required this.onTap,
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = Colors.lightBlue;
    } else if (iswhitekingincheck &&
        piece?.PieceType == ChessPieceType.king &&
        !isWhite) {
      // Mettez en surbrillance la case en rouge si le roi blanc est en échec
      squareColor = Colors.red;
    } else if (isblackkingincheck &&
        piece?.PieceType == ChessPieceType.king &&
        isWhite) {
      // Mettez en surbrillance la case en rouge si le roi noir est en échec
      squareColor = Colors.red;
    } else if (isValidMove) {
      squareColor = Colors.lightBlueAccent;
    } else {
      squareColor = isWhite ? Colors.grey[400] : Colors.grey[600];
    }


    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 7 : 0),
        child: piece != null
            ? Image.asset(
          piece!.PathToImage,
          color: piece!.isWhite ? Colors.white : Colors.black,
        )
            : null,
      ),
    );
  }
}

