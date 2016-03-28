require "bubble-sort.rb"

describe "Bubble Sort" do 
  describe "Regular Bubble Sort" do
    it "returns an empty array, when given one" do
      expect(bubble_sort([])).to match_array([])
    end

    it "returns the exact same elements" do
      expect(bubble_sort([1, 2, 3])).to contain_exactly(2, 3, 1)
    end

    it "keeps an already sorted array" do
      expect(bubble_sort([322, 4023, 7048])).to eq([322, 4023, 7048])
    end

    it "sorts an array in the ascending order" do
      expect(bubble_sort([32, 23, 48])).to eq([23, 32, 48])
    end
  end

  describe "Bubble Sort with user comparator" do

    it "does sort array in the descending order" do
      expect(bubble_sort_by([1,2,-10,78]){ |left,right| right - left}).to eq([78,2,1,-10])
    end

    it "does sort strings by the alphabetical order" do
      expect(bubble_sort_by(["hi","hello","hey"]){ |left,right| left <=> right}).to eq(["hello", "hey", "hi"])
    end

    it "does sort strings by length" do
      expect(bubble_sort_by(["hi","hello","hey"]){ |left,right| left.length - right.length}).to eq(["hi", "hey", "hello"])
    end
  end
end