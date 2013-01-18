require 'minitest_helper'

class PhotoTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def setup
    stub_request(:post, "https://api.cloudinary.com/v1_1/bigfuel/auto/upload")
      .to_return({:code => 200, :body => %{{"url": "http://res.cloudinary.com/demo/image/upload/v1312461204/sample.jpg", "secure_url": "https://d3jpl91pxevbkh.cloudfront.net/demo/image/upload/v1312461204/sample.jpg", "public_id": "sample", "version": "1312461204", "width": 864, "height": 564, "format": "png", "resource_type": "image", "signature": "abcdefgc024acceb1c5baa8dca46797137fa5ae0c3"}}})
    @photo = build(:photo)
  end

  test "should save with file" do
    assert @photo.save
  end
end