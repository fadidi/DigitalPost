require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @user = FactoryGirl.create :user
    @uploader = AvatarUploader.new(@user, :avatar)
    @uploader.store!(File.open('spec/support/images/10x10.gif'))
  end

  after do
    AvatarUploader.enable_processing = false
    @uploader.remove!
  end

  it 'should upload the photo' do
    @uploader.url.should_not be_nil
  end

  pending "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0600)
  end

  describe 'square250' do
    it "should scale down to 250x250" do
      @uploader.square250.should have_dimensions(250, 250)
    end
  end

  describe 'square50' do
    it "should scale down to 50x50" do
      @uploader.square50.should have_dimensions(50, 50)
    end
  end
end
