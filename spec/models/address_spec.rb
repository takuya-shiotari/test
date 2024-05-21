RSpec.describe Address do
  describe '#name' do
    it 'returns name' do
      address = Address.new(pref: 'tokyo')
      expect(address.pref).to eq 'tokyo'
    end
  end

  describe '#to_s' do
    it 'returns name value' do
      address = Address.new(pref: 'tokyo')
      expect(address.to_s).to eq 'tokyo'
    end
  end
end
