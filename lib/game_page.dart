import 'dart:math';

import 'package:clobber/max_win_possibility.dart';
import 'package:clobber/minimum_isolate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamePage extends StatefulWidget {
  final int rows, cols;
  final bool player, starter;

  GamePage({this.rows, this.cols, this.player, this.starter});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  @override
  // current situation of game
  List<List<bool>> board;

  // true if its blacks turn
  bool blacksTurn;
  // max win possibility tree root
  MaxWinPossibility mw;

  AnimationController animationController;

  // coordination for animation
  double x = 0,
      y = 0,
      // coordination for animation offset
      ox = 0,
      oy = 0;

  @override
  void initState() {
    // TODO: implement initState
    board = new List(widget.rows);
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    resetGame();
    super.initState();
  }

  Widget build(BuildContext context) {
    // calculating size for the marbles
    double itemSize = (MediaQuery.of(context).size.width - 20) / widget.rows;
    Image white = Image.asset(
      'images/white checker.png',
      height: itemSize,
      width: itemSize,
    );
    Image black = Image.asset(
      'images/black checker.png',
      height: itemSize,
      width: itemSize,
    );
    Image light = Image.asset(
      'images/empty light.png',
      height: itemSize,
      width: itemSize,
    );
    Image dark = Image.asset(
      'images/empty dark.png',
      height: itemSize,
      width: itemSize,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Clobber',
          style: TextStyle(
              color: Colors.black, fontStyle: FontStyle.italic, fontSize: 24.0),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.of(context).pop(context);
            }),
        actions: [
          // reset game button
          IconButton(
              icon: Icon(
                Icons.replay_rounded,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  resetGame();
                });
              }),
          Container(
            width: 60,
            alignment: Alignment.center,
            color: Colors.black,
            child: Text(
              (blacksTurn ? 'نوبت\nسیاه' : 'نوبت\nسفید'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: 'Homa'),
            ),
          ),
        ],
      ),
      // wooden background of page
      body: Container(
        // setting wooden background for page
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/light wood background.jpg"),
                fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // black border for board
                    Container(
                      width: widget.rows * itemSize + 4,
                      height: 2,
                      color: Colors.black87,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.cols, (ci) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // black border for board
                            Container(
                              height: itemSize,
                              width: 2,
                              color: Colors.black87,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(widget.rows, (ri) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // light or dark background of place
                                    ((ri + ci) % 2 == 0 ? light : dark),
                                    // item in place
                                    (board[ri][ci] == null
                                        ? SizedBox() // empty
                                        : board[ri][ci]
                                            ? blacksTurn && widget.player
                                                ? Draggable(
                                                    child: black,
                                                    data: [ri, ci],
                                                    feedback: black,
                                                    childWhenDragging:
                                                        SizedBox(),
                                                  )
                                                : !blacksTurn && !widget.player
                                                    ? DragTarget(
                                                        builder: (context,
                                                            List<List<int>>
                                                                candidateData,
                                                            rejectedData) {
                                                          return black;
                                                        },
                                                        // this method checks that is dragged item allows to be in here or not
                                                        onWillAccept: (data) {
                                                          if (ri == data[0]) {
                                                            return (ci ==
                                                                    data[1] -
                                                                        1) ||
                                                                (ci ==
                                                                    data[1] +
                                                                        1);
                                                          } else if (ci ==
                                                              data[1]) {
                                                            return (ri ==
                                                                    data[0] -
                                                                        1) ||
                                                                (ri ==
                                                                    data[0] +
                                                                        1);
                                                          } else
                                                            return false;
                                                        },
                                      // this method puts dragged item in it place
                                                        onAccept: (data) {
                                                          setState(() {
                                                            board[ri][ci] =
                                                                !board[ri][ci];
                                                            board[data[0]]
                                                                    [data[1]] =
                                                                null;
                                                            blacksTurn =
                                                                !blacksTurn;
                                                          });
                                                          doMovement();
                                                        },
                                                      )
                                                    : black
                                            : !blacksTurn && !widget.player
                                                ? Draggable(
                                                    child: white,
                                                    data: [ri, ci],
                                                    feedback: white,
                                                    childWhenDragging:
                                                        SizedBox(),
                                                  )
                                                : blacksTurn && widget.player
                                                    ? DragTarget(
                                                        builder: (context,
                                                            List<List<int>>
                                                                candidateData,
                                                            rejectedData) {
                                                          return white;
                                                        },
                                      // this method checks that is dragged item allows to be in here or not
                                      onWillAccept: (data) {
                                                          if (ri == data[0]) {
                                                            return (ci ==
                                                                    data[1] -
                                                                        1) ||
                                                                (ci ==
                                                                    data[1] +
                                                                        1);
                                                          } else if (ci ==
                                                              data[1]) {
                                                            return (ri ==
                                                                    data[0] -
                                                                        1) ||
                                                                (ri ==
                                                                    data[0] +
                                                                        1);
                                                          } else
                                                            return false;
                                                        },
                                      // this method puts dragged item in it place
                                                        onAccept: (data) {
                                                          setState(() {
                                                            board[ri][ci] =
                                                                !board[ri][ci];
                                                            board[data[0]]
                                                                    [data[1]] =
                                                                null;
                                                            blacksTurn =
                                                                !blacksTurn;
                                                          });
                                                          doMovement();
                                                        },
                                                      )
                                                    : white),
                                  ],
                                );
                              }),
                            ),
                            // black border for board
                            Container(
                              height: itemSize,
                              width: 2,
                              color: Colors.black87,
                            ),
                          ],
                        );
                      }),
                    ),
                    // black border for board
                    Container(
                        width: widget.rows * itemSize + 4,
                        height: 2,
                        color: Colors.black87)
                  ],
                ),
                // animation for computer movements
                if (blacksTurn != widget.player)
                  AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        Animation animation = Tween(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn));
                        return Transform(
                          transform: Matrix4.translationValues(
                              10 +
                                  itemSize * ox +
                                  animation.value * itemSize * x,
                              2 +
                                  itemSize * oy +
                                  animation.value * itemSize * y,
                              0.0),
                          child: widget.player ? white : black,
                          alignment: Alignment.center,
                        );
                      })
              ],
            ),
          ),
        ),
      ),
    );
  }

  // setting board
  void resetGame() {
    for (int i = 0; i < widget.rows; i++) {
      board[i] = new List(widget.cols);
      for (int j = 0; j < widget.cols; j++) {
        board[i][j] = (i + j) % 2 != 0;
      }
    }
    mw = null;
    blacksTurn = widget.starter;

    if (widget.starter != widget.player) {
      doMovement();
    }
  }

  // max win possibility method
  void movementWithMaxWinPossibilityAlgorithm() {
    // if tree is not created yet, then create it
    if (mw == null) {
      mw = MaxWinPossibility(board: board);
      mw.calculateWinPossibility(blacksTurn, !widget.player);
    } else { // search for finding the movement that user did in tree
      for (MaxWinPossibility b in mw.nextSituations)
        if (isBoardsEqual(b.board, board)) {
          mw = b;
          break;
        }
    }
    // if there is no moves left for computer, user wins
    // otherwise best way for computer will select.
    if (mw.nextSituations.isNotEmpty) {
      int mi = 0;
      for (int i = 1; i < mw.nextSituations.length; i++) {
        if (mw.nextSituations[mi].winPossibility <
            mw.nextSituations[i].winPossibility) mi = i;
      }
      animateMovement(MaxWinPossibility.copyBoard(mw.nextSituations[mi].board));
      mw = mw.nextSituations[mi];
      if (mw.nextSituations.isEmpty) showLoseDialog();
    } else
      showWinDialog();
  }

  // alpha beta search for minimum isolate method
  void movementWithAlphaBetaSearch(int nextSituations) {
    // determining maximum level of search in tree for best performance
    int level = 1;
    if (nextSituations < 10)
      level = 999;
    else if (nextSituations < 49) {
      level = 8 - (sqrt(nextSituations + 3).floor());
      if (pow(nextSituations, level) / 10000 > 1) level--;
    }
    animateMovement(
        MinimumIsolate.alpha_beta_search(board, !widget.player, level));
  }

  // doing a movement for computer
  void doMovement() {
    // if MaxWinPossibility tree is available do movement with it
    if (mw != null) {
      movementWithMaxWinPossibilityAlgorithm();
    } else {
      // count number of next possible moves
      int nextSituations = 0;
      for (int i = 0; i < board.length; i++) {
        for (int j = 0; j < board[i].length; j++) {
          if (board[i][j] != null && board[i][j] == blacksTurn) {
            if (i > 0 &&
                board[i - 1][j] != null &&
                board[i - 1][j] != blacksTurn) {
              nextSituations++;
            }
            if (i < board.length - 1 &&
                board[i + 1][j] != null &&
                board[i + 1][j] != blacksTurn) {
              nextSituations++;
            }
            if (j > 0 &&
                board[i][j - 1] != null &&
                board[i][j - 1] != blacksTurn) {
              nextSituations++;
            }
            if (j < board[i].length - 1 &&
                board[i][j + 1] != null &&
                board[i][j + 1] != blacksTurn) {
              nextSituations++;
            }
          }
        }
      }
      // if there is no moves left for computer, user wins
      // otherwise best way for computer (with most efficient algorithm) will select.
      if (nextSituations == 0)
        showWinDialog();
      else if (nextSituations > 6) {
        movementWithAlphaBetaSearch(nextSituations);
      } else
        movementWithMaxWinPossibilityAlgorithm();
    }
  }

  // do movement with animation
  void animateMovement(List<List<bool>> newB) {
    List<int> coors = findDifference(board, newB);
    if (coors[0] != -1) {
      x = coors[2].toDouble();
      y = coors[3].toDouble();
      ox = coors[0].toDouble();
      oy = coors[1].toDouble();
      board[coors[0]][coors[1]] = null;
      animationController.forward(from: 0.0).whenComplete(() {
        setState(() {
          board = newB;
          blacksTurn = !blacksTurn;
        });
      });
    }
  }

  // find difference between two board situations
  static List<int> findDifference(List<List<bool>> b1, List<List<bool>> b2) {
    int ii = -1, jj = -1;
    l:
    for (int i = 0; i < b1.length; i++) {
      for (int j = 0; j < b1[i].length; j++) {
        if (b1[i][j] != b2[i][j] && b2[i][j] != null) {
          ii = i;
          jj = j;
          break l;
        }
      }
    }
    if (ii == -1)
      return [-1];
    else if (ii > 0 && b2[ii - 1][jj] == null && b1[ii - 1][jj] != null)
      return [ii - 1, jj, 1, 0];
    else if (ii < b2.length - 1 &&
        b2[ii + 1][jj] == null &&
        b1[ii + 1][jj] != null)
      return [ii + 1, jj, -1, 0];
    else if (jj > 0 && b2[ii][jj - 1] == null && b1[ii][jj - 1] != null)
      return [ii, jj - 1, 0, 1];
    else if (jj < b2[ii].length - 1 &&
        b2[ii][jj + 1] == null &&
        b1[ii][jj + 1] != null)
      return [ii, jj + 1, 0, -1];
    else
      return [-1];
  }

  // check if boards are equal
  bool isBoardsEqual(List<List<bool>> b1, List<List<bool>> b2) {
    if (b1.length != b2.length)
      return false;
    else if (b1[0].length != b2[0].length)
      return false;
    else {
      for (int i = 0; i < b1.length; i++) {
        for (int j = 0; j < b1[i].length; j++) {
          if (b1[i][j] != b2[i][j]) return false;
        }
      }
    }
    return true;
  }

  // winner message
  void showWinDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("images/win.jpg"), fit: BoxFit.fitWidth)),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        color: Colors.white70,
                        child: Text(
                          'بازی دوباره',
                          style: TextStyle(
                              fontFamily: 'Homa',
                              fontSize: 18,
                              color: Colors.deepPurple[900]),
                        ),
                        onPressed: () {
                          setState(() {
                            resetGame();
                          });
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                        color: Colors.white70,
                        child: Text(
                          'خروج',
                          style: TextStyle(
                              fontFamily: 'Homa',
                              fontSize: 18,
                              color: Colors.deepPurple[900]),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                          Navigator.of(context).pop();
                        }),
                  ],
                )),
            margin: EdgeInsets.only(left: 12, right: 12),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  // looser message
  void showLoseDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/lose.jpg',
                  width: 100,
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        child: Text(
                          'بازی دوباره',
                          style: TextStyle(
                            fontFamily: 'Homa',
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            resetGame();
                          });
                          Navigator.of(context).pop();
                        }),
                    FlatButton(
                        child: Text(
                          'خروج',
                          style: TextStyle(
                            fontFamily: 'Homa',
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 12, right: 12),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
