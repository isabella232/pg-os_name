require 'spec_helper'

describe 'binary_copy' do
  before do
    install_extension
  end

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
