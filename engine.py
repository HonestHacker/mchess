import chess
import random
from score_table import SCORE_TABLE

inf = float('inf')



class Engine:
	def __init__(self, version, engine_player_color):
		self.engine_player_color = engine_player_color
		self.engc_k = 1 if engine_player_color else -1
	def better(self, a, b):
		return a > b if self.engine_player_color else a < b
	def score(self, board):
		s = 0
		for x in board.piece_map().values():
			s += SCORE_TABLE[x.symbol()]
		return s
	def move(self, board):
		#return random.choice(list(board.legal_moves)) # Test 1
		moves = board.legal_moves
		tb = board
		best_move = None
		best_value = -inf*self.engc_k
		for x in moves:
			tb.push(x)
			value = self.score(tb)
			tb.pop()
			if self.better(value, best_value):
				best_value = value
				best_move = x
		return best_move
