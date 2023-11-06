import 'package:chessappmobile/models/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart';
class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Square({super.key, required  this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context){
    return Container(
      color: isWhite? Colors.grey[400] : Colors.grey[600],
      child: piece != null ? Image.asset(piece!.PathToImage,
        color: piece!.isWhite ? Colors.white : Colors.black,
      )
          :null,
    );
  }
}