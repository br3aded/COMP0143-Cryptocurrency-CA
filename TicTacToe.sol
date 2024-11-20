//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        return a == b && b == c; //checks if a == b == c returns bool 
        
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        uint row = pos / 3; // Get the row index
        uint col = pos % 3; // Get the column index

        if(_threeInALine(board[row*3],board[(row*3) + 1], board[(row*3) + 2])){ // checks row
          return board[row*3];
        }

        if(_threeInALine(board[col],board[col + 3], board[col + 6])){ // checks coloumn
          return board[col];
        }

        if((pos == 0 || pos == 4 || pos == 8) && _threeInALine(board[0],board[4],board[8])){ //checks diagonal
          return board[0];
        }

        if((pos == 2 || pos == 4 || pos == 6) && _threeInALine(board[2],board[4],board[6])){ // checks anti-diagonal
          return board[2];
        }

        for (uint i = 0; i < 9; i++) { //checks game hasn't drawn
          if (board[i] == 0) {
              return 0; 
          }
        }

        return 3; //return draw if no other conditions met
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        require(status == 0, "Game is over"); //ensure status of game is ongoing
        _;
        status = _getStatus(pos); //updates status with getstatus function
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       return msg.sender == players[turn - 1]; //checks message sender is same as current player
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      require(msg.sender == players[turn - 1],"not message senders turn"); //requires current player 
      _;
      turn = (turn % 2) + 1;  //updates player turn
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      return pos < 9 && board[pos] == 0;  //checks move is valid
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      require(pos < 9 , "position out of bounds"); //ensures move is with board bounds
      require(board[pos] == 0, "position not valid"); //ensures move hasn't already been made on the board
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn; //places player piece
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
