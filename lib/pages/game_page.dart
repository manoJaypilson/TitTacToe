import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tictactoe/controllers/game_controller.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/dialogs/custom_dialog.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/game_tile.dart';

import '../core/constants.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(GAME_TITLE),
    );
  }
/*
  List<Widget> _showHistory() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear_all),
        onPressed: _dialogHistory(),
      )
    ];
  }
*/
/*
  _buildHistoryButton() {
    _buildDialogHistory(PlayerXWin, PlayerYWin);
  }
*/
/*
  _dialogHistory() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: Show_History,
          message: "X:" + "\br" + "Y:",
        );
      },
    );
  }
  */

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPlayerMode(),
          _buildBoard(),
          _buildScorePX(),
          _buildScorePY(),
          _buildIsCurrentPlayerTurnText(),
          _buildShareButton(),
          _buildResetButton(),
        ],
      ),
    );
  }

  _buildScorePX() {
    return Container(
      child: Center(
        child: Text("Vitorias X:",
            style: TextStyle(
              fontSize: 20,
            )),
      ),
    );
  }

  _buildScorePY() {
    return Container(
      child: Center(
        child: Text("Vitorias Y:",
            style: TextStyle(
              fontSize: 20,
            )),
      ),
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final tile = _controller.tiles[index];
          return _buildTile(tile);
        },
      ),
    );
  }

  _buildIsCurrentPlayerTurnText() {
    return Container(
      child: Center(
        child: Text(
          "Turno de: " + _controller.isCurrentPlayerTurn(),
        ),
      ),
    );
  }

  _buildResetButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(RESET_BUTTON_LABEL),
      onPressed: _onResetGame,
    );
  }

  _buildShareButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text('Share'),
      onPressed: _sharezadaButton,
    );
  }

  _buildTile(GameTile tile) {
    return GestureDetector(
      onTap: () => _onMarkTile(tile),
      child: Container(
        color: tile.color,
        child: Center(
          child: Text(
            tile.symbol,
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _onResetGame() {
    setState(() {
      _controller.initialize();
    });
  }

  _onMarkTile(GameTile tile) {
    if (!tile.enable) return;

    setState(() {
      _controller.mark(tile);
    });

    _checkWinner();
  }

  _checkWinner() {
    int scoreXWin;
    int scorePyWin;
    var winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isBotTurn) {
        Timer(Duration(seconds: 1), () {
          _onMarkTileByBot();
        });
      }
    } else {
      String symbol =
          winner == WinnerType.player1 ? PLAYER1_SYMBOL : PLAYER2_SYMBOL;
      _showWinnerDialog(symbol);
      if (winner == WinnerType.player1) {
        scoreXWin += 1;
      } else if (winner == WinnerType.player2) {
        scorePyWin += 1;
      }
    }
  }

  _onMarkTileByBot() {
    final id = _controller.automaticMove();
    final tile = _controller.tiles.firstWhere((element) => element.id == id);
    _onMarkTile(tile);
  }

  _showWinnerDialog(String symbol) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: WIN_TITLE.replaceAll('[SYMBOL]', symbol),
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _sharezadaButton() {
    Share.share('Vai na fé...');
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: TIED_TITLE,
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(
          _controller.isSinglePlayer ? SINGLE_PLAYER_MODE : MULTIPLAYER_MODE),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }
}
