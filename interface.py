from importlib import import_module
import json
import chess
import os

VERSION = '1.0'
CONFIG_FILE = "config.json"
config = json.load(open(CONFIG_FILE))

def clear():
	os.system('cls' if os.name == 'nt' else 'clear')

engine = import_module(config['engpath'])
board = chess.Board()

print(config['engname'])
print(config['author'])

start_data_pack = {
	'version' : VERSION, # Protocol Version
	'engine_player_color' : not int(input('Your color (1 - white / 0 - black): ')),
}

eng = engine.Engine(**start_data_pack)


while not board.is_game_over():
	if start_data_pack['engine_player_color'] == 0:
		clear(); print(board)
		h_move = input('Move: ')
		board.push_san(h_move)
		c_move = eng.move(board)
		board.push(c_move)
	else:
		clear(); print(board)
		c_move = eng.move(board)
		board.push(c_move)
		h_move = input('Move: ')
		board.push_san(h_move)