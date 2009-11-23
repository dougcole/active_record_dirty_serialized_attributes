require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class User < ActiveRecord::Base
  serialize :options, Hash
  include ActiveRecordDirtySerializedAttributes
end


describe "ActiveRecordDirtySerializedAttributes" do
  it "should not save if there are no changes" do
    user = User.create!
    #stupid transaction still fires off a begin and end even without any other executed statements.
    query_count { user.save }.should == 2
  end
end
