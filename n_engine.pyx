import chess
import chess.polyglot
import random
from score_table import SCORE_TABLE, SIMPLE_SCORE_TABLE


inf = float('inf')

LIBRARY = 'baron30.bin'
DEPTH_LIMIT = 2

class Engine:
	def __init__(self, version, engine_player_color):
		self.engine_player_color = engine_player_color
		self.engc_k = 1 if engine_player_color else -1
	def better(self, a, b):
		return a > b if self.engine_player_color else a < b
	def score(self, board):
		s = 0
		m = 0
		piece_map = board.piece_map()
		#print(piece_map)
		for k, v in piece_map.items():
			piece = v.symbol()
			m += SIMPLE_SCORE_TABLE[piece]
			piece_s = SCORE_TABLE[piece.upper()][k] * (1 if piece.isupper() else -1)
			s+=piece_s
		return m+s/100
	def negamax(self, board, depth, a, b, color):
		if depth == 0:
			return color*self.score(board)
		elif board.is_checkmate():
			return color*inf
		moves = board.legal_moves
		value = -inf
		tb = board
		for x in moves:
			tb.push(x)
			value = max(value, -self.negamax(tb, depth - 1, -b, -a, -color))
			tb.pop()
			a = max(a, value)
			if a >= b:
				break
		return value
	def move(self, board, library=LIBRARY):
		if LIBRARY is not None:
			with chess.polyglot.open_reader(library) as reader:
				try:
					return reader.find(board).move
				except IndexError:
					...
		#return random.choice(list(board.legal_moves)) # Test 1
		moves = board.legal_moves
		tb = board
		best_move = None
		best_value = -inf
		for x in moves:
			tb.push(x)
			#value = self.score(tb)
			value = self.negamax(tb, DEPTH_LIMIT, -inf, inf, self.engc_k)
			if board.is_checkmate():
				return x
			tb.pop()
			#if self.better(value, best_value):
			if value > best_value:
				best_value = value
				best_move = x
		return best_move