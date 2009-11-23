$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_record_dirty_serialized_attributes'
require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'active_record'
ActiveRecord::Base.logger = Logger.new STDOUT
ActiveRecord::Base.establish_connection(:adapter => 'postgresql', :database => 'gem_tests', :username => 'gem', :password => 'gem', :host => 'localhost')
ActiveRecord::Migrator.up('spec/migrate')

Spec::Runner.configure do |config|
  
end

def query_count(num = 1)
  ActiveRecord::Base.connection.class.class_eval do
    self.query_count = 0
    alias_method :execute, :execute_with_query_counting
  end
  yield
ensure
  ActiveRecord::Base.connection.class.class_eval do
    alias_method :execute, :execute_without_query_counting
  end
  return ActiveRecord::Base.connection.query_count
end

def assert_no_queries(&block)
  assert_queries(0, &block)
end

ActiveRecord::Base.connection.class.class_eval do
  cattr_accessor :query_count
  alias_method :execute_without_query_counting, :execute
  def execute_with_query_counting(sql, name = nil)
    self.query_count += 1
    execute_without_query_counting(sql, name)
  end
end
