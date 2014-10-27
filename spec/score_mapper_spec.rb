require 'spec_helper'

describe ScoreMapper do
  let(:mapper) {
    ScoreMapper.new
  }

  it "handles an empty array" do
    expected = [0]
    input = [[]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 1-element array" do
    expected = [1]
    input = [[1]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 2-element normal game" do
    expected = [3]
    input = [[1, 2]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 2-element strike game" do
    expected = [12, 2]
    input = [[10], [2]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a triple strike game" do
    expected = [30, 20, 10]
    input = [[10], [10], [10]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a larger normal game" do
    expected = [3, 7, 8, 7]
    input = [[1, 2], [4, 3], [6, 2], [7]]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a spare" do
    input = [[7, 3], [4, 2]]
    expected = [14, 6]
    
    expect(mapper.map input).to eq(expected)
  end
end