require 'pdf/reader'

RSpec.describe 'Impnattypo PDF' do
  let(:reader) { PDF::Reader.new('impnattypo-fr.pdf') }

  it 'has 14 pages' do
    expect(reader.page_count).to eq(14)
  end
  it 'is made by LaTeX' do
    expect(reader.info[:Creator]).to match(/LaTeX/)
  end
  it 'has A4 media box on page 1' do
    expect(reader.pages[0].attributes[:MediaBox]).to eq([0, 0, 595.276, 841.89])
  end
  it 'has 5 fonts on page 2' do
    expect(reader.pages[1].fonts.keys.size).to eq(5)
  end
  it 'starts with a title' do
    expect(reader.pages[0].text).to match('impnattypo')
  end
end
