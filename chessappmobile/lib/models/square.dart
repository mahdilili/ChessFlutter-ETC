import 'package:chessappmobile/models/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart';
class Square extends StatelessWidget {
  final bool isWhite;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  final ChessPiece? piece;
  const Square({super.key, required this.isWhite, required this.piece, required this.isSelected,
    required this.onTap, required this.isValidMove});

  @override
  Widget build(BuildContext context){
    Color? squareColor;

    if(isSelected){
      squareColor = Colors.lightBlue;
    }
    else if (isValidMove)
      {
        squareColor = Colors.lightBlueAccent;
      }
    else {
      squareColor = isWhite? Colors.grey[400] : Colors.grey[600];
    }
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove? 7:0),
        child: piece != null ? Image.asset(piece!.PathToImage,
          color: piece!.isWhite ? Colors.white : Colors.black,
        )
            :null,
      ),
    );
  }
}