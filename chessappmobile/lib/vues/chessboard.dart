import 'package:chessappmobile/controleurs/board_controleur.dart';
import 'package:chessappmobile/controleurs/deadpiece_controleur.dart';
import 'package:chessappmobile/models/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  //la pièce selectionne dans le board, si aucune piece est sélectionné, cette variable sera null
  ChessPiece? selectedPiece;

  // les row et col de la pièce sélectionné
  int selectedRow = -1;
  int selectedCol = -1;

  // La liste des valid moves pour la piece selectionnée
  List<List<int>> validMoves = [];

  //liste des pièces blancs qui ont été mangées
  List<ChessPiece> whitePiecesEaten = [];
  //liste des pièces noirs qui ont été mangées
  List<ChessPiece> blackPiecesEaten = [];

  //déterminer le tour actuel
  bool isWhiteTurn = true;

  //position initiale des kings
  List<int> whiteKingPosition = [7,4];
  List<int> blackKingPosition = [0,4];

  bool checkStatus = false;

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

  //Placer les rooks
  newBoard[0][0]= ChessPiece(PieceType: ChessPieceType.rook , isWhite:false, PathToImage: 'lib/images/rook.png');
  newBoard[7][0]= ChessPiece(PieceType: ChessPieceType.rook , isWhite:true, PathToImage: 'lib/images/rook.png');
  newBoard[0][7]= ChessPiece(PieceType: ChessPieceType.rook , isWhite:false, PathToImage: 'lib/images/rook.png');
  newBoard[7][7]= ChessPiece(PieceType: ChessPieceType.rook , isWhite:true, PathToImage: 'lib/images/rook.png');

  //Place knight
  newBoard[0][1] = ChessPiece(PieceType: ChessPieceType.knight, isWhite: false, PathToImage: 'lib/images/knight.png');
  newBoard[0][6] = ChessPiece(PieceType: ChessPieceType.knight, isWhite: false, PathToImage: 'lib/images/knight.png');
  newBoard[7][1] = ChessPiece(PieceType: ChessPieceType.knight, isWhite: true, PathToImage: 'lib/images/knight.png');
  newBoard[7][6] = ChessPiece(PieceType: ChessPieceType.knight, isWhite: true, PathToImage: 'lib/images/knight.png');

  //placer les bishops
  newBoard[0][2] = ChessPiece(PieceType: ChessPieceType.bishop, isWhite: false, PathToImage: 'lib/images/bishop.png');
  newBoard[0][5] = ChessPiece(PieceType: ChessPieceType.bishop, isWhite: false, PathToImage: 'lib/images/bishop.png');
  newBoard[7][2] = ChessPiece(PieceType: ChessPieceType.bishop, isWhite: true, PathToImage: 'lib/images/bishop.png');
  newBoard[7][5] = ChessPiece(PieceType: ChessPieceType.bishop, isWhite: true, PathToImage: 'lib/images/bishop.png');

  //Place queen
  newBoard[0][3] = ChessPiece(PieceType: ChessPieceType.queen, isWhite: false, PathToImage: 'lib/images/queen.png');
  newBoard[7][3] = ChessPiece(PieceType: ChessPieceType.queen, isWhite: true, PathToImage: 'lib/images/queen.png');

  //Place kings
  newBoard[0][4] = ChessPiece(PieceType: ChessPieceType.king, isWhite: false, PathToImage: 'lib/images/king.png');
  newBoard[7][4] = ChessPiece(PieceType: ChessPieceType.king, isWhite: true, PathToImage: 'lib/images/king.png');

  board = newBoard;
}

void PieceSelectionnee(int row, int col){
  setState(() {
    if(selectedPiece == null && board[row][col] !=null){
      if(board[row][col]!.isWhite == isWhiteTurn){
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    }

    else if(board[row][col] != null && board[row][col]!.isWhite == selectedPiece!.isWhite){
      selectedPiece = board[row][col];
      selectedRow = row;
      selectedCol = col;
    }

    // si il ya une piece selectionne et que le joueur clique sur un square valide, on bouge la piece
    else if(selectedPiece != null && validMoves.any((element) => element[0] == row && element[1] == col)){
      BougerPiece(row, col);
    }
    //si une piece selectionnée, il faut calculer les moves valides

     validMoves = CalculerRawValidMoves(selectedRow,selectedCol,selectedPiece);
  });

}

// Calculer les Raw valid Moves
  List<List<int>> CalculerRawValidMoves(int row, int col, ChessPiece? piecee){
  List<List<int>> playerMoves = [];
  if(piecee == null){
    return [];
  }
    //Les différentes direction selon la couleur du joueur
    int direction = piecee.isWhite? -1 : 1;

    switch (piecee.PieceType)
        {
      case ChessPieceType.pawn:
    //pawn peut se déplacer en avant si le carré est vide
      if(bc.isInBoard(row+direction, col)&& board[row+direction][col]==null)
        {
          playerMoves.add([row+direction, col]);
        }
      // pawn peut se déplcer de deux cases si ils sont dans leurs position initiales
      if((row == 1 && !piecee.isWhite) || (row ==6 && piecee.isWhite)){
        if(bc.isInBoard(row+2 * direction, col)&& board[row + 2 * direction][col]==null &&
            board[row + direction][col]==null){
          playerMoves.add([row+2*direction, col]);
        }
      }
      // pawn peut manger une piece en diagonale
      if(bc.isInBoard(row+direction, col-1)&& board[row+direction][col-1] != null
      && board[row+direction][col-1]!.isWhite != piecee.isWhite){
        playerMoves.add([row+direction, col -1]);
      }
      if(bc.isInBoard(row+direction, col+1)&& board[row+direction][col+1] != null
          && board[row+direction][col+1]!.isWhite!= piecee.isWhite){
        playerMoves.add([row+direction, col +1]);
      }
        break;
      case ChessPieceType.rook:
      //direction horizontale et verticale
      var directions = [
        [-1,0], //up
        [1,0], // down
        [0,-1], //left
        [0,1] //right
      ];

      for(var direction in directions)
        {
          var i =1;
          while(true){
            var newRow = row+i * direction[0];
            var newCol  = col+i *direction[1];
            if(!bc.isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol] !=null)
              {
                if(board[newRow][newCol]!.isWhite != piecee.isWhite){
                  playerMoves.add([newRow,newCol]); //mangable
                }
                break; // bloquer
              }
            playerMoves.add([newRow,newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.knight:
      // toutes les 8 "L" moves possibles
      var knightMoves = [
        [-2,-1],
        [-2,1],
        [-1,-2],
        [-1,2],
        [1,-2],
        [1,2],
        [2,-1],
        [2,1]
      ];

      for(var move in knightMoves)
        {
          var newRow = row+move[0];
          var newCol = col+move[1];
          if(!bc.isInBoard(newRow, newCol))
            {
              continue;
            }
          if(board[newRow][newCol]!=null)
            {
              if(board[newRow][newCol]!.isWhite != piecee.isWhite)
                {
                  playerMoves.add([newRow,newCol]);
                }
              continue;
            }
          playerMoves.add([newRow,newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //directions diagonales
      var directions = [
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
      ];
      for(var direction in directions)
        {
          var i =1;
          while(true)
            {
              var newRow = row+i * direction[0];
              var newCol = col+i * direction[1];
              if(!bc.isInBoard(newRow, newCol)){
                  break;
              }
              if(board[newRow][newCol]!=null)
                {
                  if(board[newRow][newCol]!.isWhite != piecee.isWhite){
                    playerMoves.add([newRow,newCol]);
                  }
                  break;
                }
              playerMoves.add([newRow,newCol]);
              i++;
            }
        }
        break;
      case ChessPieceType.queen:
    //Toutes les 8 directions
      var directions = [
        [-1,0],
        [1,0],
        [0,-1],
        [0,1],
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
      ];

      for (var direction in directions)
        {
          var i = 1;
          while(true)
            {
              var newRow = row+i *direction[0];
              var newCol = col +i * direction[1];
              if(!bc.isInBoard(newRow, newCol))
                {
                  break;
                }
              if(board[newRow][newCol]!=null){
                if(board[newRow][newCol]!.isWhite !=piecee.isWhite)
                  {
                    playerMoves.add([newRow,newCol]);
                  }
                break;
              }

              playerMoves.add([newRow,newCol]);
              i++;
            }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1]
        ];
        for(var direction in directions)
          {
            var newRow = row +direction[0];
            var newCol = col +direction[1];
            if(!bc.isInBoard(newRow, newCol)){
              continue;
            }
            if(board[newRow][newCol]!=null)
              {
                if(board[newRow][newCol]!.isWhite != piecee.isWhite){
                  playerMoves.add([newRow,newCol]);
                }
                continue;
              }

            playerMoves.add([newRow,newCol]);
          }
        break;
      default:
    }
    return playerMoves;
  }

  void BougerPiece(int newRow, int newCol){


  //si le nouveau square contient une piece ennemi
    if(board[newRow][newCol] !=null){
      var capturedPiece = board[newRow][newCol];
      if(capturedPiece!.isWhite)
        {
          whitePiecesEaten.add(capturedPiece);
        }
      else{
        blackPiecesEaten.add(capturedPiece);
      }
    }
  //bouger la pièce et libérer sa place

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;


    //voir si l'un des kings est en attaque

    if(isKingInCheck(!isWhiteTurn)){
      checkStatus = true;
    }
    else{
      checkStatus = false;
    }
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //changer le tour actuel
    isWhiteTurn = !isWhiteTurn;
  }

bool isKingInCheck(bool isWhiteKing){
  List<int> kingPosition = isWhiteKing? whiteKingPosition:blackKingPosition;

  //checker si une piece ennemi peut attacker le king
  for(int i=0 ; i<8 ; i++){
    for(int j=0 ; j<8 ; j++){
      if(board[i][j]== null || board[i][j]!.isWhite == isWhiteKing){
        continue;
      }

      List<List<int>> pieceValidMoves = CalculerRawValidMoves(i, j, board[i][j]);

      //checker si la position du king est dans la liste des moves valides
      if(pieceValidMoves.any((element) => element[0] == kingPosition[0] && element[1] == kingPosition[1])){
        return true;
      }

    }
  }
  return false;
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
        children: [
          Expanded(child: GridView.builder(
            itemCount: whitePiecesEaten.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context,index)=>DeadPiece(imagePath: whitePiecesEaten[index].PathToImage, isWhite: true))),
          Text(checkStatus? "CHECK" :""),

          Expanded(
            flex: 3,
            child: GridView.builder (
              itemCount: 8*8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), //Pour une grille 8 par 8
                itemBuilder: (context,  index) {

                int row = index ~/8;
                int col = index % 8;

                //Vérifier si le square est selectionnée ou pas
                bool isSelected = selectedRow == row && selectedCol == col;

                //vérifier si le square selectionnée est disponible
                bool isvalidMove= false;
                for(var position in validMoves)
                  {
                    //Comparer les col et les rows
                    if(position[0]  == row && position[1] == col)
                      {
                        isvalidMove = true;
                      }
                  }
                  return Square(
                  isWhite: bc.isWhite(index),
                  piece: board[row][col],
                    isSelected: isSelected,
                    isValidMove: isvalidMove,
                    onTap: ()=> PieceSelectionnee(row, col),
                  );
                },
            ),
          ),
          Expanded(child: GridView.builder(
              itemCount: blackPiecesEaten.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context,index)=>DeadPiece(imagePath: blackPiecesEaten[index].PathToImage, isWhite: false))),
        ],
      ),
    );
  }
}