require 'rails_helper'

RSpec.describe Food, type: :model do
  subject { FactoryBot.create(:food) }

  before { subject.save }

  it 'should have a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'should have a valid price' do
    subject.price = nil
    expect(subject).not_to be_valid
  end

  it 'should have a valid quantity' do
    subject.quantity = nil
    expect(subject).not_to be_valid
  end
end
