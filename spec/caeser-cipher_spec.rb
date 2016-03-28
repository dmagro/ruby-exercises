require "caeser-cipher.rb"

describe "Caeser Cipher" do
  it "keeps the text unchange for a 0 offset" do
    expect(caeser_cipher("caeser", 0)).to eq("caeser")
  end

  it "shifts text by a given offset" do
    expect(caeser_cipher("caeser", 2)).to eq("ecgugt")
  end

  it "shifts text correctly for offsets over 26" do
    expect(caeser_cipher("caeser", 212)).to eq("geiwiv")
  end

  it "keeps the capitalized characters" do
    expect(caeser_cipher("CaeSer", 2)).to eq("EcgUgt")
  end

  it "does not shift any non-alpha character" do
    expect(caeser_cipher("caeser ciph3r!", 212)).to eq("geiwiv gmtl3v!")
  end

  it "handles characters beyond 'z'" do
    expect(caeser_cipher("tzi germans", 2)).to eq("vbk igtocpu")
  end
end