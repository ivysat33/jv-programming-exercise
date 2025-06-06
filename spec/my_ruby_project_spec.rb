require 'my_ruby_project'

RSpec.describe MyRubyProject do
  describe '#some_method' do
    it 'does something expected' do
      expect(subject.some_method).to eq(expected_value)
    end
  end
end