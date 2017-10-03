require 'spec_helper'

# Model taken from the dummy app
describe Article do

  it 'should be translatable' do
    Article.translates?.should be_true
  end

  describe 'localized article' do

    let(:article) { create(:localized_article) }
    subject { article }

    it { should have(3).translations }

    it 'should have italian translation' do
      I18n.with_locale :it do
        article.title.should == 'Italian title'
        article.body.should == 'Italian Body'
      end
    end

    it 'should have hungarian translation' do
      I18n.with_locale :hu do
        article.title.should == 'Article title'
        article.body.should == 'Hungarian Body'
      end
    end

  end

end
