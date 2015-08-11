require 'spec_helper'

describe 'persistence' do
  before do
    install_extension
  end

  it 'should persist os_names' do
    query("CREATE TABLE os_name_test AS SELECT 'ios'::os_name, 1 as num")
    query("SELECT * FROM os_name_test").should match 'ios',  1
    query("UPDATE os_name_test SET num = 2")
    query("SELECT * FROM os_name_test").should match 'ios',  2
  end
end
