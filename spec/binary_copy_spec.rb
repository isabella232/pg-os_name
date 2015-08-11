require 'spec_helper'

describe 'binary_copy' do
  before do
    install_extension
  end


  test_types_and_values =
    {
     'country' => %w(de us es de zz),
     'device_type' => %w( bot console ipod ipod unknown ),
     'os_name' => %w(android ios windows ios unknown),
     'istore' => ['"1"=>"1"', '"1"=>"2"', '"1"=>"3"', '"2"=>"1"', '"2"=>NULL', '"2"=>"2"'],
     'country_istore' => ['"de"=>"1"', '"es"=>"2"', '"de"=>"3"', '"us"=>"1"', '"zz"=>"2"', '"de"=>NULL'],
     'device_istore' => ['"bot"=>"1"', '"phone"=>"2"', '"bot"=>"3"', '"tablet"=>"1"', '"server"=>"2"', '"server"=>NULL'],
     'os_name_istore' => ['"android"=>"1"', '"windows"=>"2"', '"android"=>"3"', '"ios"=>"1"', '"unknown"=>"2"', '"ios"=>NULL']
   }

  it "should copy data binary from country" do
    query("CREATE TABLE before (a os_name)")
    query("INSERT INTO before VALUES ('android'), ('ios'), ('windows'), ('ios'), ('unknown')")
    query("CREATE TABLE after (a os_name)")
    query("COPY before TO '/tmp/tst' WITH (FORMAT binary)")
    query("COPY after FROM '/tmp/tst' WITH (FORMAT binary)")
    query("SELECT * FROM after").should match \
    ['android'],
    ['ios'],
    ['windows'],
    ['ios'],
    ['unknown']
  end
end
