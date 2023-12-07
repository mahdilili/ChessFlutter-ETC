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


  //Liste des pièces mangés par le joueur white
  List<ChessPiece> BlackPieceEaten = [];
  //Liste des pièces mangés par le joueur noir
  List<ChessPiece> WhitePieceEaten =[];

  bool isWhiteTurn = true;

  List<int> WhiteKingPos = [7,4];
  List<int> BlackKingPos = [0,4];

  bool checkStatus = false;
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
    //Pas de pièce selectionne et c'est la premiere selection
    if(selectedPiece == null && board[row][col] !=null){
        if(board[row][col]!.isWhite == isWhiteTurn){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
    }
    else if (board[row][col] != null && board[row][col]!.isWhite == selectedPiece!.isWhite){
      selectedPiece = board[row][col];
      selectedRow = row;
      selectedCol = col;
    }

    // si une pièce est selectionnée et que sa destination est vide on la bouge
    else if(selectedPiece != null &&
        validMoves.any((element)=> element[0] == row && element[1] == col)){
      MovePiece(row,col);
    }

    //si une piece selectionnée, il faut calculer les moves valides

     validMoves = CalculerRealValidMoves(selectedRow,selectedCol,selectedPiece, true);
  });

}
List<List<int>> CalculerRealValidMoves(int row, int col , ChessPiece? piece , bool checkSimulation){

  List<List<int>> realValidMove =[];
  List<List<int>> playerMoves = CalculerRawValidMoves(row, col, piece);

  //filtrer les valid moves pour un résultat de king in a check
  if(checkSimulation){
    for(var move in playerMoves){
      int endRow = move[0];
      int endCol = move[1];
      //Stimuler le prochain move pour déterminer s'il est safe
      if(SimulatedMoveSafe(piece!, row, col, endRow, endCol)){
        realValidMove.add(move);
      }
      else {
        realValidMove = playerMoves;
      }
    }
  }
  return realValidMove;
}
// Calculer les Raw valid Moves
  List<List<int>> CalculerRawValidMoves(int row, int col, ChessPiece? selectedpiece){
  List<List<int>> playerMoves = [];
    //Les différentes direction selon la couleur du joueur
  if(selectedpiece == null)
    {
      return [];
    }
    int direction = selectedpiece!.isWhite? -1 : 1;

    switch (selectedpiece.PieceType)
        {
      case ChessPieceType.pawn:
    //pawn peut se déplacer en avant si le carré est vide
      if(bc.isInBoard(row+direction, col)&& board[row+direction][col]==null)
        {
          playerMoves.add([row+direction, col]);
        }
      // pawn peut se déplcer de deux cases si ils sont dans leurs position initiales
      if((row == 1 && !selectedpiece.isWhite) || (row ==6 && selectedpiece.isWhite)){
        if(bc.isInBoard(row+2 * direction, col)&& board[row + 2 * direction][col]==null &&
            board[row + direction][col]==null){
          playerMoves.add([row+2*direction, col]);
        }
      }
      // pawn peut manger une piece en diagonale
      if(bc.isInBoard(row+direction, col-1)&& board[row+direction][col-1] != null
      && board[row+direction][col-1]!.isWhite != selectedpiece.isWhite){
        playerMoves.add([row+direction, col -1]);
      }
      if(bc.isInBoard(row+direction, col+1)&& board[row+direction][col+1] != null
          && board[row+direction][col+1]!.isWhite != selectedpiece.isWhite){
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
                if(board[newRow][newCol]!.isWhite != selectedpiece.isWhite){
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
              if(board[newRow][newCol]!.isWhite != selectedpiece.isWhite)
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
                  if(board[newRow][newCol]!.isWhite != selectedpiece.isWhite){
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
                if(board[newRow][newCol]!.isWhite !=selectedpiece.isWhite)
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
                if(board[newRow][newCol]!.isWhite != selectedpiece.isWhite){
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

  //bouger les pièce


  bool KingIsInCheck(bool isWhiteKing){
    List<int> kingPosition  = isWhiteKing? WhiteKingPos : BlackKingPos;

    for(int i=0 ; i < 8; i++) {
      for (int k = 0; k < 8; k++) {
        if (board[i][k] == null || board[i][k]!.isWhite == isWhiteKing){
          continue;
        }
        List<List<int>> piecesValidMoves = CalculerRealValidMoves(i, k, board[i][k], false);

        if(piecesValidMoves.any((move) => move[0] == kingPosition[0]&& move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }


  bool SimulatedMoveSafe(ChessPiece piece, int startRow, int startCol, int endRow, int endCol){
  //sauvegarder le board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPosition;
    if(piece.PieceType == ChessPieceType.king){
      originalKingPosition = piece.isWhite? WhiteKingPos : BlackKingPos;

      //maj le position du king
      if(piece.isWhite){
        WhiteKingPos  = [endRow,endCol];
      }
      else {
        BlackKingPos = [endRow, endCol];
      }
    }
    //si la pièce est un king

    //stimuler le mouvement
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;
    //vérifier si notre own king est under attack
    bool kingincheck = KingIsInCheck(piece.isWhite);
    //restaurer le state original
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;
    //si la pièce était un king, restaurer sa position originale
    if(piece.PieceType == ChessPieceType.king){
      if(piece.isWhite){
        WhiteKingPos = originalKingPosition!;
      }
      else {
        BlackKingPos = originalKingPosition!;
      }
    }

    //si le king est en echéc = true, donc pas safe , safe move= false
    return !kingincheck;
  }
  //ChessPiece piecePawn = ChessPiece(PieceType:ChessPieceType.pawn, isWhite:false, PathToImage:'lib/images/pawn.png');

  void MovePiece(int newRow, int newCol){
    //Vérifier si la case contient une piece de l'ennemi
    if(board[newRow][newCol] !=null){
      var capturedPiece = board[newRow][newCol];
      if(capturedPiece!.isWhite){
        WhitePieceEaten.add(capturedPiece);
      }
      else{
        BlackPieceEaten.add(capturedPiece);
      }
    }

    //vérifier si le pièce qui va etre bouger est un king
    if(selectedPiece!.PieceType == ChessPieceType.king){
      //mettre a jour les position du king approprié
      WhiteKingPos = [newRow, newCol];
    }
    else {
      BlackKingPos = [newRow, newCol];
    }

    //bouger la pièce et libérer sa case
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;
    //checker si le king est en échec
    if(KingIsInCheck(!isWhiteTurn)){
      checkStatus = true;
    }
    else {
      checkStatus = false;
    }
    setState(() {
      selectedPiece = null;
      selectedCol = -1;
      selectedRow = -1;
      validMoves = [];
    });

    //changer le tour du joeur
    isWhiteTurn = !isWhiteTurn;



  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
        children: [
          //Les pieces mangés pour le joueur noir
          Expanded(child: GridView.builder(itemCount:WhitePieceEaten.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context,index)=>DeadPiece(imagePath: WhitePieceEaten[index].PathToImage,
                  isWhite: true)),),

          Text(checkStatus? "CHECK":""),
          Expanded(
            flex: 4,
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
          //Les pieces mangés du joueur blanc
          Expanded(child: GridView.builder(itemCount:BlackPieceEaten.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context,index)=>DeadPiece(imagePath: BlackPieceEaten[index].PathToImage,
                  isWhite: false)),),
        ],
      ),
    );
  }
}