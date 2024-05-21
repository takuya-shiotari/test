RSpec.describe Comment do
  describe '#body' do
    it 'returns body value' do
      comment = Comment.new('body')
      expect(comment.body).to eq 'body'
    end
  end

  describe '#to_s' do
    it 'returns body value' do
      comment = Comment.new('body')
      expect(comment.to_s).to eq 'body'
    end
  end

  describe '#==' do
    it 'checks comment equality' do
      comment = Comment.new('body')
      expect(comment).to eq Comment.new('body')
    end
  end
end
