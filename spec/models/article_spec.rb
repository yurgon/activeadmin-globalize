require 'spec_helper'

# Model taken from the dummy app
describe Article do

  it 'should be translatable' do
    Article.translates?.should be_true
  end

  describe 'localized article' do

    let(:article) { create(:localized_article) }
    subject { article }

    it { should have(2).translations }

    it 'should have italian translation' do
      I18n.with_locale :it do
        article.title.should == 'Italian title'
      end
    end

  end

end