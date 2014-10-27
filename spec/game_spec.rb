require 'spec_helper'

##
# Test the 'public API' surface of the code,
# as it would be called by a user of the code.
describe Game do
  let(:game) {
    Game.new
  }

  context "using test data from PDF" do

    it "works with Test Data case 1" do
      [1,3,6,3].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 13
    end
  
    it "works with Test Data case 2" do
      [10,4,0].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 18
    end
  
    it "works with Test Data case 3 (triple strike)" do
      [10,10,10].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 60
    end
  end
  
  context "using zero game data" do
  
    it "gives a zero score before any shots are taken" do
      expect(game.score).to eq 0
    end

    it "gives a zero score for an incomplete zero game" do
      [0, 0].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 0
    end
  
    it "gives a zero score for a person who can never hit anything" do
      # Reverse of a perfect game
      12.times do
        game.roll 0
      end
    
      expect(game.score).to eq 0
    end
  end
  
  context "using 'normal' (no bonus) game data" do
    it "works across a whole normal game" do
      # 10 goes, score 8 per frame
      10.times do
        game.roll 5
        game.roll 3
      end
      
      expected = (8 * 10)
      expect(game.score).to eq expected
    end
  
    it "works after the first shot in the game" do
      game.roll 3
      
      expect(game.score).to eq 3
    end
  
    it "gives a normal score for normal frames (1.5 frames)" do
      [5, 3, 1].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 9
    end
  
    it "gives a normal score for normal frames (2 complete frames)" do
      [5, 4, 1, 2].each do |n|
        game.roll n
      end
      
      expected = (5 + 4) + (1 + 2)
      expect(game.score).to eq expected
    end
  end
  
  context "using spares game data" do
  
    it "can calculate a spare" do
      [5, 5].each do |n|
        game.roll n
      end
      
      expect(game.score).to eq 10
    end
  
    it "can calculate a spare (+ half complete frame after)" do
      [5, 5, 1].each do |n|
        game.roll n
      end
      
      expected = (5 + 5 + 1) + 1
      expect(game.score).to eq expected
    end
  
    it "can calculate a spare (+ 1 complete frame after)" do
      [5, 5, 1, 1].each do |n|
        game.roll n
      end
      
      expected = (5 + 5 + 1) + (1 + 1)
      expect(game.score).to eq expected
    end
  end
  
  context "using strike game data" do
    it "can calculate a strike (+ half complete frame after)" do
      [10, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 1) + 1
      expect(game.score).to eq expected
    end
  
    it "can calculate a strike (+ 1 complete frame after)" do
      [10, 1, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 1 + 1) + (1 + 1)
      expect(game.score).to eq expected
    end
  
    it "can calculate a strike" do
      game.roll 10
      
      expect(game.score).to eq 10
    end
  end
  
  context "using double strike game data" do
  
    it "can calculate a double strike" do
      [10, 10].each do |n|
        game.roll n
      end
      
      expected = (10 + 10) + 10
      expect(game.score).to eq expected
    end
  
    it "can calculate a double strike (+ half complete frame after)" do
      [10, 10, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 10 + 1) + (10 + 1) + 1
      expect(game.score).to eq expected
    end
  
    it "can calculate a double strike (+ 1 complete frame after)" do
      [10, 10, 1, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 10 + 1) + (10 + 1 + 1) + (1 + 1)
      expect(game.score).to eq expected
    end
  end
  
  context "using triple strike game data" do
    it "can calculate a triple strike (+ half complete frame after)" do
      [10, 10, 10, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 10 + 10) + (10 + 10 + 1) + (10 + 1) + 1
      expect(game.score).to eq expected
    end
  
    it "can calculate a triple strike (+ 1 complete frame after)" do
      [10, 10, 10, 1, 1].each do |n|
        game.roll n
      end
      
      expected = (10 + 10 + 10) + (10 + 10 + 1) + (10 + 1 + 1) + (1 + 1)
      expect(game.score).to eq expected
    end
  end
  
  context "using special case game data" do
    # When a person bowls a strike at the end, they get 2 bonus shots.
    it "handles a normal game with bonus shots at the end (1 strike 1 normal)" do
      # For the first 9 frames they score 8 per frame
      9.times do
        game.roll 5
        game.roll 3
      end
      
      # Strike happens on 10th shot
      game.roll 10
      
      # Bonus shots (1 strike, 1 normal)
      game.roll 10
      game.roll 1
      
      # 8*9 = the first 9 regular frames
      # In the end game bonus shots, we simply add them up, unlike regular strike scoring.
      expected = (8 * 9) + (10 + 10 + 1)
      expect(game.score).to eq expected
    end
  
    # When a person bowls a strike at the end, they get 2 bonus shots.
    it "handles a normal game with all strikes at the end" do
      # For the first 9 frames they score 8 per frame
      9.times do
        game.roll 5
        game.roll 3
      end
      
      # Strike happens on 10th shot
      # Then bonus shots (2 strikes)
      3.times do
        game.roll 10
      end
      
      # 8*9 = the first 9 regular frames
      # In the end game bonus shots, we simply add them up, unlike regular strike scoring,
      # which would have been (10 + 10 + 10) + (10 + 10) + 10
      expected = (8 * 9) + (10 + 10 + 10)
      expect(game.score).to eq expected
    end
  
    # When a person bowls a spare at the end, they get 1 bonus shot.
    it "handles a normal game with a spare at the end" do
      # For the first 9 frames they score 8 per frame
      9.times do
        game.roll 5
        game.roll 3
      end
      
      # Spare in 10th frame.
      game.roll 5
      game.roll 5
      
      # One bonus
      game.roll 4
      
      # 8*9 = the first 9 regular frames
      # In the end game bonus shots, we simply add them up, unlike regular strike scoring.
      expected = (8 * 9) + (5 + 5 + 4)
      expect(game.score).to eq expected
    end
  
    # When a person bowls a spare at the end, they get 1 bonus shot.
    it "handles a normal game with a spare then strike at the end" do
      # For the first 9 frames they score 8 per frame
      9.times do
        game.roll 5
        game.roll 3
      end
      
      # Spare in 10th frame.
      game.roll 5
      game.roll 5
      
      # One bonus strike
      game.roll 10
      
      # 8*9 = the first 9 regular frames
      # In the end game bonus shots, we simply add them up, unlike regular strike scoring.
      expected = (8 * 9) + (5 + 5 + 10)
      expect(game.score).to eq expected
    end
  
    # See http://en.wikipedia.org/wiki/Perfect_game_(bowling)
    # for more info.
    #
    # This is the special case that requires the 'bonus score reducer' to tap into
    # the recursive scoring logic, and handle the end-game strikes differently
    # to prevent it thinking it is a standard triple strike (which gives a score of 330).
    it "can calculate a perfect game (300)" do
      # In a perfect game, a player bowls 12 strikes
      12.times do
        game.roll 10
      end

      expect(game.score).to eq 300
    end
  end
end