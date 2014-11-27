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
  # Frames look like an array of arrays. The correspondance with x, y, z etc looks like:
  # [[1, 3], [5, 2]]
  #   x  y    z  _
  #
  # and becomes a list of frame scores like:
  # [4, 7]
  #
  # [[10], [1, 3], [5]]
  #   x     y  z    _
  #
  # and becomes
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
      x = frames[0][0] || 0
      y = frames[0][1] || 0
      
      acc << x + y
      
      return acc
       
    # Recursive case, more than 1 frame worth of shots to compute
    else
      # Insert the || 0 to deal with the case where frame is empty.
      x = frames[0][0] || 0
      
      if x == Settings[:strike]
        # Strike. Y must come from the (frame + 1).
        y = frames[1][0] || 0
        # If Y was a strike then Z will come from frames[2].
        # Otherwise it will come from frames[1]. It is possible Z has not been rolled yet.
        z = frames[1][1] || (frames[2][0] if frames[2]) || 0

        acc << x + y + z
        
        return map frames.drop(1), acc
        
      else
        # Not a strike. Y comes from same frame as X.
        y = frames[0][1] || 0
        
        if (x + y) == Settings[:spare]
          # Spare condition. Z comes from first shot in next frame.
          # Note that it may not have been performed yet.
          z = frames[1][0] || 0
          
          acc << x + y + z
          
          return map frames.drop(1), acc
          
        else
          # Normal condition (no strikes)
          acc << x + y
          
          return map frames.drop(1), acc
        end
      end
    end
  end
end