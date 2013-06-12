require 'active_record'
require 'active_record/fixtures'
require 'yaml'

PROJ_DIR = File.join(File.dirname(__FILE__),"..")
puts PROJ_DIR
ActiveRecord::Base.establish_connection(YAML::load_file(File.join(PROJ_DIR,"config","db.yml")))

module TestHelper
  def self.included(child)
    # WARNING: we use transactional fixtures only. This helper should not be
    # used to test transaction dependent code.
    child.around do |example|
      tables = Dir[File.join(PROJ_DIR,"test","fixtures","*.yml")].map{|fn| File.basename(fn,".yml") }
      ActiveRecord::Fixtures.create_fixtures(File.join(PROJ_DIR,"test","fixtures"),tables)
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
    end
  end
end
