require 'settings'
require 'score_mapper'
require 'end_game_handler'
require 'frame_mapper'

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
  
    # Divide up the raw scores into frames.
    frames = FrameMapper.new.map @scores
    
    # Inject custom scoring logic for the 'end game' bonus shots.
    # For this we ask the Settings configuration object how many frames should be
    # in the game.
    end_game_processed_frames = EndGameHandler.new.map Settings[:num_frames], frames
    
    # Obtain a list of scores per frame.
    scores_per_frame = ScoreMapper.new.map end_game_processed_frames
    
    return scores_per_frame
  end
end