enum ChessPieceType {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king
}

class ChessPiece{
  final ChessPieceType PieceType;
  final bool isWhite;
  final String PathToImage;

  ChessPiece({required this.PieceType, required this.isWhite, required this.PathToImage});
}