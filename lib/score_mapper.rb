require 'settings'

##
# Like so many other mathsy / algorithmic problems implemented in
# code, it is sometimes cleaner to use a functional programming
# implementation. Ruby's functional extensions allow us to integrate the
# FP backend with the OOP external API surface in the Game class with
# little trouble.
class ScoreMapper
  
  ##
  # Scores all the frames bowled so far. Outputs an array of scores per frame.
  #
  # Frames look like an array of arrays.
  # If we consider that first ball = x, second ball = y, third ball = z,
  # the correspondence between the frames and balls x, y, z looks like this.
  #
  # EXAMPLE 1
  #
  # [[1, 3], [5, 2]]
  #   x  y    z  _
  #
  # Becomes a list of frame scores like:
  # [4, 7]
  #
  # EXAMPLE 2
  #
  # [[10], [1, 3], [5]]
  #   x     y  z    _
  #
  # Becomes a list of frame scores like:
  # [14, 4, 5]
  #
  def map frames, acc=[]
    case frames.length
    
    # Base case, nothing extra to add to the score. Needed to stop the recursion.
    when 0
      return acc
    
    # Cleans up the handling of end-of-list frames
    # instead of putting lots of if not nil guards in the recursive case.
    when 1
      first_ball  = frames[0][0] || 0
      second_ball = frames[0][1] || 0
      
      acc << first_ball + second_ball
      
      return acc
       
    # Recursive case, more than 1 frame worth of shots to compute
    else
      # Insert the || 0 to deal with the case where frame is empty.
      first_ball = frames[0][0] || 0
      
      if first_ball == Settings[:strike]
        # Strike, second ball must come from the (frame + 1).
        # It is also possible that it has not been rolled yet.
        second_ball = frames[1][0] || 0
        
        # If second ball was a strike then third ball will come from frames[2].
        # Otherwise it will come from frames[1].
        # It is also possible that third ball has not been rolled yet.
        third_ball = frames[1][1] || (frames[2][0] if frames[2]) || 0

        acc << first_ball + second_ball + third_ball
        
        return map frames.drop(1), acc
        
      else
        # Not a strike, second ball comes from same frame as first ball.
        second_ball = frames[0][1] || 0
        
        if (first_ball + second_ball) == Settings[:spare]
          # Spare condition, third ball comes from first shot in next frame.
          # Note that it may not have been performed yet.
          third_ball = frames[1][0] || 0
          
          acc << first_ball + second_ball + third_ball
          
          return map frames.drop(1), acc
          
        else
          # Normal condition (no strikes)
          acc << first_ball + second_ball
          
          return map frames.drop(1), acc
        end
      end
    end
  end
end