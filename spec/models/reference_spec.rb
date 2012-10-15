require 'spec_helper'

describe Reference do
  before :each do
    @attr = {
      :link_text => 'test text',
      :link_target_id => 1,
      :link_target_type => 'Page',
      :link_source_id => 1,
      :link_source_type => 'Page'
    }
  end

  it {Reference.create! @attr}

  # properties
  it {should respond_to :link_source_id}
  it {should respond_to :link_source_type}
  it {should respond_to :link_target_id}
  it {should respond_to :link_target_type}
  it {should respond_to :link_text}
  it {should respond_to :target_count}

  # associations
  it {should respond_to :link_source}
  it {should respond_to :link_target}

  # methods
  it {should respond_to :is_ambiguous?}
  it {should respond_to :is_missing?}
  it {Reference.should respond_to(:process_string).with(2).arguments}
  it {should respond_to :is_valid?}

  # scopes
  it {Reference.should respond_to :ambiguous}
  it {Reference.should respond_to :missing}
  it {Reference.should respond_to :to_pages}
  it {Reference.should respond_to :valid}

  describe 'properties' do
    describe 'link_text' do
      it 'should be blank by default' do
        Reference.new.link_text.should be_blank
      end
    end
  end

  describe 'validations' do
    describe 'link_source_id' do
      it 'should require a link_source_id' do
        Reference.new(@attr.merge(:link_source_id => '')).should_not be_valid
      end
    end

    describe 'link_source_id' do
      it 'should require a link_source_id' do
        Reference.new(@attr.merge(:link_source_id => '')).should_not be_valid
      end
    end

    describe 'link_target_id' do
      it 'should not require a link_target_id' do
        Reference.new(@attr.merge(:link_target_id => '')).should be_valid
      end
    end

    describe 'link_target_type' do
      it 'should not require a link_target_type' do
        Reference.new(@attr.merge(:link_target_type => '')).should be_valid
      end
    end

    describe 'link_text' do
      it 'should require link_text' do
        Reference.new(@attr.merge(:link_text => '')).should_not be_valid
      end

      it 'should not allow link_text longer than 255 chars' do
        Reference.new(@attr.merge(:link_text => 'a'*256)).should_not be_valid
      end
    end

    pending 'each target/source/text combo should be unique' do
      it 'should not allow duplicate entries' do
        Reference.create! @attr
        Reference.create(@attr).should_not be_valid
      end
    end

    it {Reference.new(@attr.merge(:target_count => '')).should_not be_valid}
    it {Reference.new(@attr.merge(:target_count => 'a')).should_not be_valid}
  end

  describe 'scopes' do
    describe 'default' do
      before :each do
        @reference1 = Reference.create(@attr.merge(:link_text => 'Zzzzz link'))
        @reference2 = Reference.create(@attr.merge(:link_text => 'Aaaa link'))
      end

      it 'should sort by link_text' do
        Reference.all.should start_with @reference2
        Reference.all.should end_with @reference1
      end
    end

    describe 'ambiguous' do
      it 'should include references with target_counts higher than 1' do
        @reference = FactoryGirl.create(:reference, :target_count => 2)
        FactoryGirl.create(:reference, :target_count => 0)
        FactoryGirl.create(:reference, :target_count => 1)
        Reference.ambiguous.should include @reference
      end
    end

    describe 'missing' do
      it 'should include references with target_counts less than 1' do
        FactoryGirl.create(:reference, :target_count => 2)
        @reference = FactoryGirl.create(:reference, :target_count => 0)
        FactoryGirl.create(:reference, :target_count => 1)
        Reference.missing.should include @reference
      end
    end

    describe 'to_pages' do
      before :each do
        FactoryGirl.create(:reference, :link_target => FactoryGirl.create(:page))
        FactoryGirl.create(:reference, :link_target => FactoryGirl.create(:user))
      end

      it 'should return only pages' do
        Reference.to_pages.each do |to_page|
          to_page.link_target_type.should eq 'Page'
        end
      end
    end

    describe 'valid' do
      it 'should include references with target_counts higher equal to 1' do
        FactoryGirl.create(:reference, :target_count => 2)
        FactoryGirl.create(:reference, :target_count => 0)
        @reference = FactoryGirl.create(:reference, :target_count => 1)
        Reference.valid.should include @reference
      end
    end
  end

  describe 'associations' do
    describe 'link_source' do
      before :each do
        @reference = FactoryGirl.create(:reference, :link_source => @page = FactoryGirl.create(:page))
      end

      it 'should return the correct link_source' do
        @reference.link_source.should eq @page
      end

      it 'should be an instance of link_source_type' do
        @reference.link_source.should be_an_instance_of @reference.link_source_type.constantize
      end
    end

    describe 'link_target' do
      before :each do
        @reference = FactoryGirl.create(:reference, :link_target => @page = FactoryGirl.create(:page))
      end

      it 'should return the correct link_target' do
        @reference.link_target.should eq @page
      end

      it 'should be an instance of link_target_type' do
        @reference.link_target.should be_an_instance_of @reference.link_target_type.constantize
      end
    end
  end
  
  describe 'methods' do
    describe 'is_ambiguous?' do
      it {Reference.new(@attr).is_ambiguous?.should_not be_true}

      it 'should be true with target_count > 0' do
        @ref = FactoryGirl.create(:reference, :target_count => 2)
        @ref.is_ambiguous?.should be_true
      end
    end

    describe 'is_missing?' do
      it {Reference.new(@attr).is_missing?.should_not be_true}
      it {Reference.create!(@attr).is_missing?.should be_true}

      it 'should be true with target_count < 1' do
        @ref = FactoryGirl.create(:reference, :target_count => 0)
        @ref.is_missing?.should be_true
      end
    end

    describe 'is_valid?' do
      it {Reference.new(@attr).is_valid?.should_not be_true}

      it 'should be true with target_count == 1' do
        @ref = FactoryGirl.create(:reference, :target_count => 1)
        @ref.is_valid?.should be_true
      end
    end
    
    describe 'process_string' do
      it 'should ignore markdown links' do
        Reference.process_string('this is text containing [a markdown link](http://test.com)', FactoryGirl.create(:page)).should =~ /\[a markdown link\]\(http:\/\/test\.com\)/
      end

      describe 'external' do
        before :each do
          @page = FactoryGirl.create(:page)
        end

        it 'should find and replace external pca links' do
          Reference.process_string('this is text containing [[http://an.external.link]]', @page).should =~ /<a href="http:\/\/an\.external\.link">http:\/\/an\.external\.link<\/a>/
        end

        it 'should create a new reference' do
          expect {
            Reference.process_string('this is text containing [[http://an.external.link]]', @page)
          }.to change(Reference, :count).by(1)
        end

        it 'should not create a new reference for the same link' do
          Reference.process_string('this is text containing [[http://an.external.link]]', @page)
          expect {
            Reference.process_string('this is text containing [[http://an.external.link]]', @page)
          }.to change(Reference, :count).by(0)
        end
      end

      describe 'internal' do
        describe 'unscoped' do
          before :each do
            @page = FactoryGirl.create :page
          end

          context 'with 0 matches' do
            before :each do
              @page.references.destroy_all
              @result = Reference.process_string('some test [[link crazy content]].', @page)
            end

            it 'should set target_count to 0' do
              @page.references.first.target_count.should eq 0
            end

            it 'should set the path to disambiguation' do
              @result.should =~ /"\/references\/#{Reference.first.to_param}"/i
            end

            it 'should append disambiguation icon to link text' do
              @result.should =~ /<span class="icon-random"><\/span><\/a>/i
            end

            it 'should add disambiguation class' do
              @result.should =~ /class="disambiguation"/i
            end
          end

          it 'should create a new reference' do
            expect {
              Reference.process_string('this is text containing [page[an internal link]]', FactoryGirl.create(:page))
            }.to change(Reference, :count).by(1)
          end

          it 'should not create a new reference for the same link' do
            Reference.process_string('this is text containing [page[an internal link]]', @page = FactoryGirl.create(:page))
            expect {
              Reference.process_string('this is text containing [page[an internal link]]', @page)
            }.to change(Reference, :count).by(0)
          end

          it 'should find and replace non-scoped pca links' do
            Reference.process_string('this is text containing [[a pca link]]', @page).should =~ />a pca link.*<\/a>/
          end

          it 'should create link entries in references' do
            expect {
              Reference.process_string('a [[test link]] should work', @page)
            }.to change(Reference, :count).by(1)
          end
        end

        describe 'scoped' do
          it 'should find and replace scoped pca links' do
            Reference.process_string('this is text containing [blarg[a pca link]]', FactoryGirl.create(:page)).should =~ />a pca link.*<\/a>/
          end

          describe 'embeds' do
            context 'img' do
              [Photo].each do |item|
                context item do
                  before :each do
                    @page = FactoryGirl.create :page
                    @sitem = item.to_s.underscore
                    @item = FactoryGirl.create @sitem.to_sym
                  end

                  describe 'with no matches' do
                    it 'should insert an img tag' do
                      Reference.process_string('this is an embedded image. [photo:embed[teststhoostehuansteohuoe]]', @page).should =~ /<img/
                    end

                    it 'should create a reference' do
                      expect {
                        Reference.process_string('this is an embedded image. [photo:embed[teststhoostehuansteohuoe]]', @page)
                      }.to change(Reference, :count).by(1)
                    end

                    it 'should parse paramters' do
                      ['float:left;', 'float:left'].each do |param|
                        Reference.process_string("this is an embedded image. [photo:embed[testeohuoe]#{param}]", @page).should =~ /wiki-float-left/
                      end
                    end
                  end

                  describe 'with 1 match' do
                    before :each do
                      Photo.destroy_all
                      @photo = FactoryGirl.create(:photo)
                    end

                    it 'should insert an img tag' do
                      Reference.process_string("[photo:embed[#{@photo.title}]]", @page).should =~ /<img/
                    end
                  end
                end
              end
            end
          end

          context 'title search based' do
            [Page, Photo].each do |item|
              context item do
                before :each do
                  @page = FactoryGirl.create :page
                  @sitem = item.to_s.underscore
                  @item = FactoryGirl.create @sitem.to_sym
                end

                describe 'with one match' do
                  it 'should be case-insensitive' do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.title.downcase}]] for testing.", @page).should =~ /"\/#{@sitem.pluralize}\/#{@item.to_param}"/i
                  end

                  it 'should set the correct path' do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.title}]] for testing.", @page).should =~ /"\/#{@sitem.pluralize}\/#{@item.to_param}"/i
                  end

                  it 'should change the Reference count' do
                    expect {
                      Reference.process_string("this is text containing [#{@sitem}[#{@item.title}]] for testing.", @page)
                    }.to change(Reference, :count).by(1)
                  end

                  it 'should set target_count to 1' do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.title}]] for testing.", @page)
                    @page.references.count.should eq 1
                    @page.references.first.target_count.should eq 1
                  end
                end

                describe 'with multiple matches' do
                  before :each do
                    @item2 = FactoryGirl.create(@sitem.to_sym, :title => @item.title)
                    @result = Reference.process_string("this is text containing [#{@sitem}[#{@item.title}]] for testing.", @page)
                  end

                  it 'should add a reference' do
                    expect {
                      Reference.process_string("this is text containing [#{@sitem}[#{@item.title}]] for testing.", FactoryGirl.create(:page))
                    }.to change(Reference, :count).by(1)
                  end

                  it 'should set the path to disambiguation' do
                    @result.should =~ /"\/references\/#{Reference.first.to_param}"/i
                  end

                  it 'should append disambiguation icon to link text' do
                    @result.should =~ /<span class="icon-random"><\/span><\/a>/i
                  end

                  it 'should add disambiguation class' do
                    @result.should =~ /class="disambiguation"/i
                  end

                  it 'should set target_count to > 1' do
                    @page.references.count.should eq 1
                    @page.references.first.target_count.should be > 1
                  end
                end

                describe 'with no matches' do
                  before :each do
                    @result = Reference.process_string("new [#{@sitem}[link text such an absurd then]]", @page)
                  end

                  it 'should add a reference' do
                    expect {
                      Reference.process_string("new [#{@sitem}[link text such an absurd then]]", FactoryGirl.create(:page))
                    }.to change(Reference, :count).by(1)
                  end

                  it 'should set the path to missing' do
                    @result.should =~ /"\/references\/#{Reference.first.to_param}"/i
                  end

                  it 'should append missing icon to link text' do
                    @result.should =~ /<span class="icon-remove-circle"><\/span><\/a>/i
                  end

                  it 'should add missing class' do
                    @result.should =~ /class="missing"/i
                  end

                  it 'should set target_count to < 1' do
                    @page.references.count.should eq 1
                    @page.references.first.target_count.should be < 1
                  end
                end
              end
            end
          end

          context 'name handle' do
            [Language, Region, Sector, Unit, User, WorkZone].each do |item|
              context item do
                describe 'with one match' do
                  before :each do
                    @source = FactoryGirl.create(:page)
                    @sitem = item.to_s.underscore
                    @item = FactoryGirl.create @sitem.to_sym
                  end

                  it "should set the correct path to the #{item}" do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.name}]] for testing.", @source).should =~ /"\/#{@sitem.pluralize}\/#{@item.to_param}"/i
                  end

                  it 'should be case-insensitive' do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.name.downcase}]] for testing.", @source).should =~ /"\/#{@sitem.pluralize}\/#{@item.to_param}"/i
                  end

                  it 'should change the Reference count' do
                    expect {
                      Reference.process_string("this is text containing [#{@sitem}[#{@item.name}]] for testing.", @source)
                    }.to change(Reference, :count).by(1)
                  end

                  it 'should set target_count to 1' do
                    Reference.process_string("this is text containing [#{@sitem}[#{@item.name}]] for testing.", @source)
                    @source.references.count.should eq 1
                    @source.references.first.target_count.should eq 1
                  end
                end

                describe 'with no match' do
                  before :each do
                    @source = FactoryGirl.create(:page)
                    @sitem = item.to_s.underscore
                    @item = FactoryGirl.create @sitem.to_sym
                    @result = Reference.process_string("this is text containing [#{@sitem}[gibberish]] for testing.", @source)
                  end

                  it 'should change the Reference count' do
                    expect {
                      Reference.process_string("this is text containing [#{@sitem}[gibberish]] for testing.", FactoryGirl.create(:page))
                    }.to change(Reference, :count).by(1)
                  end

                  it 'should set target_count to 0' do
                    @source.references.count.should eq 1
                    @source.references.first.target_count.should eq 0
                  end

                  it 'should set the path to missing' do
                    @result.should =~ /"\/references\/#{Reference.first.to_param}"/i
                  end

                  it 'should append missing icon to link text' do
                    @result.should =~ /<span class="icon-remove-circle"><\/span><\/a>/i
                  end

                  it 'should add missing class' do
                    @result.should =~ /class="missing"/i
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
