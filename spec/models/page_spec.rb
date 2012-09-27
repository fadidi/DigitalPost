require 'spec_helper'

describe Page do
  before :each do
    @attr = {
      :title => 'Test Page',
      :user_id => 1
    }
  end

  it {Page.create! @attr}

  # properties
  it {should respond_to(:html)}
  it {should respond_to(:locked_at)}
  it {should respond_to(:locked_by)}
  it {should respond_to(:title)}
  it {should respond_to :user_id}

  # associations
  it {should respond_to :authors}
  it {should respond_to :current_author}
  it {should respond_to :current_revision}
  it {should respond_to :editor}
  it {should respond_to :links_in}
  it {should respond_to :links_out}
  it {should respond_to :revisions}
  it {should respond_to :user}

  # methods
  it {should respond_to(:lock).with(1).argument}
  it {should respond_to :locked?}
  it {should respond_to(:set_html).with(1).argument}
  it {should respond_to :to_param}
  it {should respond_to :unlock}

  describe 'properties' do
    before :each do
      @page = FactoryGirl.create :page
    end

    describe 'to_param' do
      it 'should include the page title in to_param' do
        @page.to_param.should eq "#{@page.id}-#{@page.title.parameterize}"
      end
    end

    describe 'htmls' do
      it 'should set default html' do
        page = Page.new @attr
        page.html.should =~ /no content/i
      end
    end

    describe 'locked_ats' do
      it 'should not be set by default' do
        Page.new(@attr).locked_at.should be_blank
      end

      it 'should be a datetime' do
        Page.new(@attr.merge(:locked_at => Time.now)).locked_at.should be_an_instance_of(ActiveSupport::TimeWithZone)
      end
    end
  end



  describe 'validations' do
    it {Page.new(@attr.merge(:html => '')).should be_valid}
    it {Page.new(@attr.merge(:locked_at => '')).should be_valid}

    describe 'locked_by' do
      it {Page.new(@attr.merge(:locked_by => '')).should be_valid}

      it 'should be an integer' do
        Page.new(@attr.merge(:locked_by => 'a')).should_not be_valid
      end
    end

    describe 'title' do
      it {Page.new(@attr.merge(:title => '')).should_not be_valid}
      it {Page.new(@attr.merge(:title => 'a'*256)).should_not be_valid}
    end

    it {Page.new(@attr.merge(:user_id => '')).should_not be_valid}
  end

  describe 'associations' do
    before :each do
      @page = FactoryGirl.create(:page)
    end

    describe 'authors' do
      before :each do
        FactoryGirl.create(:revision, :page => @page, :author => @user = FactoryGirl.create(:user))
        FactoryGirl.create(:revision, :page => @page, :content => 'changed content', :author => @user)
        FactoryGirl.create(:revision, :author => @user)
        @page.reload
      end

      it 'should return the correct authors' do
        @page.authors.should eq [@user]
      end
    end

    describe 'current_author' do
      before :each do
        FactoryGirl.create(:revision, :page => @page)
        FactoryGirl.create(:revision, :page => @page, :content => 'changed content')
        FactoryGirl.create(:revision, :page => @page, :content => 'yet more changed content', :author => @user = FactoryGirl.create(:user))
        @page.reload
      end

      it 'should return the correct author' do
        @page.current_author.should eq @user
      end
    end

    describe 'current_revision' do
      before :each do
        @revision = FactoryGirl.create(:revision, :page => @page)
        @revision2 = FactoryGirl.create(:revision, :page => @page, :content => 'changed content')
        @page.reload
      end

      it 'should be an instance of Revision' do
        @page.current_revision.should be_an_instance_of Revision
      end

      it 'should return the correct revision' do
        @page.current_revision.should eq @revision2
      end
    end

    describe 'editor' do
      before :each do
        @page = FactoryGirl.create :page
        @user = FactoryGirl.create :user
      end

      it 'should have no editor by default' do
        @page.editor.should be_nil
      end

      it 'should have an editor after locking' do
        @page.lock(@user).editor.should be @user
      end

      it 'should have an editor after unlocking' do
        @page.lock(@user)
        @page.unlock.editor.should be @user
      end
    end

    describe 'links_in' do
      before :each do
        @page = FactoryGirl.create :page
        @revision = FactoryGirl.create(:revision, :content => "content with [page[#{@page.title}]].")
      end

      it 'should be an instance of Reference' do
        @page.links_in.first.should be_an_instance_of Reference
      end

    end

    describe 'links_out' do
      before :each do
        @revision = FactoryGirl.create(:revision, :content => 'content with [page[a link]]', :page => @page = FactoryGirl.create(:page))
        puts @revision.inspect
        puts @page.inspect
        puts Reference.all.inspect
      end

      it 'should be an instance of Reference' do
        @page.links_out.first.should be_an_instance_of Reference
      end
    end

    describe 'revisions' do
      before :each do
        @page = Page.create!(:title => 'test', :user_id => 1)
        @page.update_attributes(:revisions_attributes => [{:content => 'testing', :author_id => 1}])
        @revision = @page.revisions.first
      end

      it 'should be an instance of Revision' do
        @page.revisions.first.should be_an_instance_of Revision
      end

      it 'should return the correct revision' do
        @page.revisions.should eq [@revision]
      end

      it 'should accept nested attributes' do
        lambda do
          @page.update_attributes!(:revisions_attributes => [{:content => 'test', :author_id => 1}])
        end.should change(Revision, :count).by(1)
      end

      it 'should reject if content is blank' do
        lambda do
          @page.update_attributes(:revisions_attributes => [{:content => '', :author_id => 1}])
        end.should_not change(Revision, :count).by(1)
      end

      it 'should destroy revisions on destroy' do
        lambda do
          @page.destroy
        end.should change(Revision, :count).by(-1)
      end
    end
  end

  describe 'methods' do
    describe 'lock(user)' do
      before :each do
        @page = FactoryGirl.create :page
        @user = FactoryGirl.create :user
      end

      it 'should set locked_at' do
        locked_at = @page.locked_at
        @page.lock(@user)
        @page.reload
        @page.locked_at.should_not be_blank
      end

      it 'should return itself' do
        @page.lock(@user).should be @page
      end

      it 'should update locked_at' do
        locked_at = @page.lock(@user).locked_at
        @page.lock(@user).locked_at.should be > locked_at
      end

      it 'should set locked_at to Time.now' do
        @time = Time.now - 1.second
        @page.lock(@user)
        @page.reload.locked_at.should be > @time
      end

      it 'should set locked_by' do
        locked_by = @page.locked_by
        @page.lock(@user).locked_by.should_not eq locked_by
      end

      it 'should update locked_by' do
        locked_by = @page.lock(@user).locked_by
        @page.lock(FactoryGirl.create(:user)).locked_by.should_not eq locked_by
      end
    end

    describe 'locked?' do
      before :each do
        @page = FactoryGirl.create :page
      end

      it 'should return false by default' do
        @page.locked?.should_not be_true
      end

      it 'should return true after locking' do
        @page.lock(FactoryGirl.create(:user)).locked?.should be_true
      end

      it 'should return false 15 min after locking' do
        @page.update_attribute(:locked_at, Time.now - 15.minutes - 1.second)
        @page.locked?.should_not be_true
      end

      it 'should return false after unlocking' do
        @page.lock(FactoryGirl.create(:user))
        @page.unlock.locked?.should_not be_true
      end
    end

    describe 'set_html(content)' do
      before :each do
        @page = FactoryGirl.create :page
      end

      it 'should change html' do
        new_html = @page.html + ' spiffy HTML'
        @page.set_html(new_html)
        @page.html.should eq new_html
      end
    end

    describe 'unlock' do
      before :each do
        @page = FactoryGirl.create :page
      end

      it 'should return itself' do
        @page.unlock.should be @page
      end

      it 'should clear locked_at' do
        @page.lock(@user)
        @page.unlock
        @page.reload.locked_at.should be_blank
      end

      it 'should not clear locked_by' do
        @page.lock(@user)
        @page.unlock.locked_at.should be_blank
      end
    end
  end


  describe 'scopes' do
    describe 'default' do
      it 'should sort by title ASC' do
        @page1 = Page.create(@attr.merge(:title => 'Before you leap'))
        @page2 = Page.create(@attr.merge(:title => 'A bit of heaven'))
        Page.all.should eq [@page2,@page1]
      end
    end
  end
end
