require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  before do
    PhotoUploader.enable_processing = true
    @unit = FactoryGirl.create :unit
    @uploader = PhotoUploader.new(@unit, :photo)
    @uploader.store!(File.open('spec/support/images/10x10.gif'))
  end

  after do
    PhotoUploader.enable_processing = false
    @uploader.remove!
  end

  it 'should upload the photo' do
    @uploader.url.should_not be_nil
  end

  pending "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0600)
  end

  describe 'golden374' do
    it "should scale down to 374x231" do
      @uploader.golden374.should have_dimensions(374, 231)
    end
  end

  describe 'golden791' do
    it "should scale down to 791x489" do
      @uploader.golden791.should have_dimensions(791, 489)
    end
  end
end
