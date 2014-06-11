require 'spec_helper'

# Model taken from the dummy app
describe Article do

  it 'should be translatable' do
    Article.translates?.should be_true
  end

end