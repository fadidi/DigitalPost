require 'carrierwave/test/matchers'

describe DocumentUploader do
  include CarrierWave::Test::Matchers

  before do
    DocumentUploader.enable_processing = true
    @document = FactoryGirl.create :document
    @uploader = DocumentUploader.new(@document, :document)
    @uploader.store!(File.open('spec/support/documents/sample.txt'))
  end

  after do
    DocumentUploader.enable_processing = false
    @uploader.remove!
  end

  it 'should upload the doc' do
    @uploader.url.should_not be_nil
  end

  pending "should make the image readable only to the owner and not executable" do
    @uploader.should have_permissions(0600)
  end
end
