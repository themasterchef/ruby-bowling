require 'rspec'
require './frame_mapper'

describe FrameMapper do
  let(:mapper) {
    FrameMapper.new
  }

  it "handles an empty array" do
    expected = []
    input = []
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 1-element array" do
    expected = [[1]]
    input = [1]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 2-element normal game" do
    expected = [[1, 2]]
    input = [1, 2]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a 2-element strike game" do
    expected = [[10], [2]]
    input = [10, 2]
    
    expect(mapper.map input).to eq(expected)
  end
  
  it "handles a larger normal game" do
    expected = [[1, 2], [4, 3], [6, 2], [7]] 
    input = [1,2,4,3,6,2,7]
    
    expect(mapper.map input).to eq(expected)
  end
end