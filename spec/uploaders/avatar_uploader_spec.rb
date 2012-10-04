require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @unit = FactoryGirl.create :unit
    @uploader = AvatarUploader.new(@unit, :avatar)
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

  describe 'span3' do
    it "should scale down to 374x231" do
      @uploader.span3.should have_dimensions(374, 231)
    end
  end

  describe 'span6' do
    it "should scale down to 791x489" do
      @uploader.span6.should have_dimensions(791, 489)
    end
  end
end
