class MaxWinPossibility {
  List<List<bool>> board;
  double winPossibility;
  List<MaxWinPossibility> nextSituations = [];

  MaxWinPossibility({this.board});

  // calculating win possibility for each next movement
  void calculateWinPossibility(bool turn, bool computer) {
    // finding next possible movements
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        if (board[i][j] != null && board[i][j] == turn) {
          if (i > 0 && board[i - 1][j] != null && board[i - 1][j] != turn) {
            List<List<bool>> b = copyBoard(board);
            b[i - 1][j] = turn;
            b[i][j] = null;
            nextSituations.add(MaxWinPossibility(board: b));
          }
          if (i < board.length - 1 &&
              board[i + 1][j] != null &&
              board[i + 1][j] != turn) {
            List<List<bool>> b = copyBoard(board);
            b[i + 1][j] = turn;
            b[i][j] = null;
            nextSituations.add(MaxWinPossibility(board: b));
          }
          if (j > 0 && board[i][j - 1] != null && board[i][j - 1] != turn) {
            List<List<bool>> b = copyBoard(board);
            b[i][j - 1] = turn;
            b[i][j] = null;
            nextSituations.add(MaxWinPossibility(board: b));
          }
          if (j < board[i].length - 1 &&
              board[i][j + 1] != null &&
              board[i][j + 1] != turn) {
            List<List<bool>> b = copyBoard(board);
            b[i][j + 1] = turn;
            b[i][j] = null;
            nextSituations.add(MaxWinPossibility(board: b));
          }
        }
      }
    }
    // if there is no movement left
    // if its computers turn winner is user. otherwise winner is computer
    if (nextSituations.isEmpty) {
      winPossibility = (turn == computer ? 0 : 1);
    // if number of movements is not 0 and its computers turn,
    // then best way with maximum win possibility will be saved.

    } else if (turn == computer) {
      double maxPossibility = -1;
      int maxIndex = -1;
      for (int i = 0; i < nextSituations.length; i++) {
        MaxWinPossibility bs = nextSituations[i];
        bs.calculateWinPossibility(!turn, computer);
        if (bs.winPossibility > maxPossibility) {
          maxPossibility = bs.winPossibility;
          maxIndex = i;
        }
      }
      nextSituations = [nextSituations[maxIndex]];
      winPossibility = nextSituations[0].winPossibility;
      print('calculating with max win possibility...');
    // if number of movements is not 0 and its users turn,
    // then win possibility for each movements will be calculated
    } else {
      double avg = 0;
      for (MaxWinPossibility bs in nextSituations) {
        bs.calculateWinPossibility(!turn, computer);
        avg += bs.winPossibility;
      }
      print('calculating with max win possibility...');
      winPossibility = avg / nextSituations.length;
    }
  }

  static List<List<bool>> copyBoard(List<List<bool>> source) {
    List<List<bool>> result = [];
    for (int i = 0; i < source.length; i++) {
      result.add([]);
      result[i].addAll(source[i]);
    }
    return result;
  }
}
