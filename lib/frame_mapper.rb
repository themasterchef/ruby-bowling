class FrameMapper

  ##
  # Splits a raw array of scores
  # into an array of arrays, where each inner array
  # is a bowling frame.
  # External users should not touch the accumulator.
  def map scores, acc=[]
    
    case scores.length
    
    when 0
      # Base case, no more splitting needed.
      return acc
    
    when 1
      acc << scores
      return acc
    
    else
      # Recursive case, more than 1 frame worth of shots to compute
      # Grab the head of the scores list.    
      x = scores[0]
    
      # A strike belongs in its own frame.
      if x == 10
        acc << [x]
        return map scores.drop(1), acc
      else
        acc << [x, scores[1]]
        return map scores.drop(2), acc
      end
    end
  end
end