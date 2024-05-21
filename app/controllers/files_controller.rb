class FilesController < ApplicationController
  def show
    Aws::S3::Client.new.put_object(bucket: ENV['BUCKET_NAME'], key: 'sample.txt', body: 'body')
    render plain: Aws::S3::Client.new.get_object(bucket: ENV['BUCKET_NAME'], key: 'sample.txt').body.read
  end
end
