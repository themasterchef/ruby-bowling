require './score_mapper'
require './end_game_handler'
require './frame_mapper'

##
# Game is the 'I/O' class. It stores incoming data, but computation is done
# by the functional utility classes.
class Game

  def initialize
    # Just build up the player's scores for this game
    # in a simple Ruby array.
    @scores = []
  end

  def roll shot_score
    @scores << shot_score
    
    # Side effect driven method, do not return @scores.
    return nil
  end
  
  ##
  # Compute the score when asked.
  def score
    # Already have the scores-per-frame in a list
    # so just add it up.
    # An empty game won't have any scores to add up, yielding nil,
    # so in this case we return zero.
    score_list.reduce(:+) || 0
  end
  
  ##
  # Generates a list of the scores per frame so far.
  # Useful in debugging and also visualisation.
  def score_list
    frame_mapper = FrameMapper.new
    score_mapper = ScoreMapper.new
    end_game = EndGameHandler.new
    
    # Function composition using the Funkify gem.
    # Acts like a mapreduce chain.
    # Set end game to kick in after 10 frames (standard game) using partial application.
    return (frame_mapper.map | end_game.map(10) | score_mapper.map).(@scores)
  end
end