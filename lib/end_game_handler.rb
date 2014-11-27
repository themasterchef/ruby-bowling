class EndGameHandler

  ##
  # When injected into the scoring flow, this
  # function modifies the behavior of scoring at the end game frames
  # and counts them differently.
  #
  # @num_frames - allows adjustment of when the end game happens, as some non-standard
  # bowling games last longer than 10 frames.
  def map num_frames, frames
    if frames.length > num_frames
      # Get all the end game frames, then smash them together
      # so they are all in 1 frame.
      end_game = frames.drop(num_frames - 1).flatten
      
      first_ball  = end_game[0] || 0
      second_ball = end_game[1] || 0
      third_ball  = end_game[2] || 0
      
      final_frame_score = first_ball + second_ball + third_ball

      # Replace the last N frames with one 'special' frame containing
      # the combined score.
      new_frames = frames.first(num_frames - 1)
      
      # This is a workaround which stops the recursive logic in the score mapper
      # from being able to add the tenth frame score to the ninth, in other words
      # it stops bonus balls from being treated like triple strikes.
      new_frames << [0]
      
      # Now insert the actual score.
      new_frames << [final_frame_score]
      
      return new_frames
      
    else
      # Just return the raw frames, not at end game yet
      return frames
    end
  end
end