import 'dart:math';

import 'package:clobber/max_win_possibility.dart';

class MinimumIsolate {
  List<List<bool>> board;

  MinimumIsolate(this.board);

  static List<List<bool>> alpha_beta_search(
      List<List<bool>> state, bool computer, int level) {
    print('calculating with alpha-beta...');
    int alpha = -1, beta = 999;
    List<MinimumIsolate> nextSituations = [];
    // finding next situations
    for (int i = 0; i < state.length; i++) {
      for (int j = 0; j < state[i].length; j++) {
        if (state[i][j] != null && state[i][j] == computer) {
          if (i > 0 && state[i - 1][j] != null) {
            if (state[i - 1][j] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i - 1][j] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (i < state.length - 1 && state[i + 1][j] != null) {
            if (state[i + 1][j] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i + 1][j] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (j > 0 && state[i][j - 1] != null) {
            if (state[i][j - 1] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i][j - 1] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (j < state[i].length - 1 && state[i][j + 1] != null) {
            if (state[i][j + 1] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i][j + 1] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
        }
      }
    }
    // invalid tree
    if (nextSituations.isEmpty) {
      return state;
    }
    int v = 999, mi = 0;
    for (int i = 0; i < nextSituations.length; i++) {
      int temp =
          max_value(nextSituations[i].board, alpha, beta, computer, level);
      if (temp < v) {
        v = temp;
        mi = i;
      }
    }
    return nextSituations[mi].board;
  }

  static int max_value(
      List<List<bool>> state, int alpha, int beta, bool computer, int level) {
    print('calculating with alpha-beta...');
    List<MinimumIsolate> nextSituations = [];
    for (int i = 0; i < state.length; i++) {
      for (int j = 0; j < state[i].length; j++) {
        if (state[i][j] != null && state[i][j] == !computer) {
          if (i > 0 && state[i - 1][j] != null && state[i - 1][j] == computer) {
            List<List<bool>> b = MaxWinPossibility.copyBoard(state);
            b[i - 1][j] = computer;
            b[i][j] = null;
            nextSituations.add(MinimumIsolate(b));
          }
          if (i < state.length - 1 &&
              state[i + 1][j] != null &&
              state[i + 1][j] == computer) {
            List<List<bool>> b = MaxWinPossibility.copyBoard(state);
            b[i + 1][j] = computer;
            b[i][j] = null;
            nextSituations.add(MinimumIsolate(b));
          }
          if (j > 0 && state[i][j - 1] != null && state[i][j - 1] == computer) {
            List<List<bool>> b = MaxWinPossibility.copyBoard(state);
            b[i][j - 1] = computer;
            b[i][j] = null;
            nextSituations.add(MinimumIsolate(b));
          }
          if (j < state[i].length - 1 &&
              state[i][j + 1] != null &&
              state[i][j + 1] == computer) {
            List<List<bool>> b = MaxWinPossibility.copyBoard(state);
            b[i][j + 1] = computer;
            b[i][j] = null;
            nextSituations.add(MinimumIsolate(b));
          }
        }
      }
    }
    if (nextSituations.isEmpty || level == 1) {
      int numOfIsolate = 0;
      for (int i = 0; i < state.length; i++) {
        for (int j = 0; j < state[i].length; j++) {
          if (state[i][j] != null && state[i][j] == computer) {
            bool isIsolate = true;
            if (i > 0 && state[i - 1][j] != null) {
              isIsolate = false;
            }
            if (i < state.length - 1 && state[i + 1][j] != null) {
              isIsolate = false;
            }
            if (j > 0 && state[i][j - 1] != null) {
              isIsolate = false;
            }
            if (j < state[i].length - 1 && state[i][j + 1] != null) {
              isIsolate = false;
            }
            if (isIsolate) {
              numOfIsolate++;
            }
          }
        }
      }
      return numOfIsolate;
    }
    int v = -1;
    for (MinimumIsolate mi in nextSituations) {
      v = max(v, min_value(mi.board, alpha, beta, computer, level - 1));
      if (v > beta) return v;
      alpha = max(alpha, v);
    }
    return v;
  }

  static int min_value(
      List<List<bool>> state, int alpha, int beta, bool computer, int level) {
    print('calculating with alpha-beta...');
    int numOfIsolate = 0;
    List<MinimumIsolate> nextSituations = [];
    for (int i = 0; i < state.length; i++) {
      for (int j = 0; j < state[i].length; j++) {
        if (state[i][j] != null && state[i][j] == computer) {
          bool isIsolate = true;
          if (i > 0 && state[i - 1][j] != null) {
            isIsolate = false;
            if (state[i - 1][j] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i - 1][j] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (i < state.length - 1 && state[i + 1][j] != null) {
            isIsolate = false;
            if (state[i + 1][j] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i + 1][j] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (j > 0 && state[i][j - 1] != null) {
            isIsolate = false;
            if (state[i][j - 1] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i][j - 1] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (j < state[i].length - 1 && state[i][j + 1] != null) {
            isIsolate = false;
            if (state[i][j + 1] != computer) {
              List<List<bool>> b = MaxWinPossibility.copyBoard(state);
              b[i][j + 1] = computer;
              b[i][j] = null;
              nextSituations.add(MinimumIsolate(b));
            }
          }
          if (isIsolate) {
            numOfIsolate++;
          }
        }
      }
    }
    if (nextSituations.isEmpty) {
      return numOfIsolate;
    }
    int v = 999;
    for (MinimumIsolate mi in nextSituations) {
      v = min(v, max_value(mi.board, alpha, beta, computer, level));
      if (v <= beta) return v;
      beta = min(beta, v);
    }
    return v;
  }
}
