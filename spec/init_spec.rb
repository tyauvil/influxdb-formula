# for serverspec documentation: http://serverspec.org/
require_relative 'spec_helper'

pkgs = ['influxdb']

files = ['/etc/influxdb/influxdb.conf']

dirs = ['/var/lib/influxdb/data',
        '/var/lib/influxdb/meta',
        '/var/lib/influxdb/wal']

ports = ['8086', '2003']

pkgs.each do |pkg|
  describe package("#{pkg}") do
    it { should be_installed }
  end
end

files.each do |file|
  describe file("#{file}") do
    it { should be_file }
  end
end

dirs.each do |dir|
  describe file("#{dir}") do
    it { should be_directory }
    it { should be_owned_by 'influxdb' }
  end
end

describe service('influxdb') do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |port|
  describe port("#{port}") do
    it { should be_listening }
  end
end

# let telegraf send first update
# sleep(30)
#
# describe command('wget -qO- "http://localhost:8086/query?q=select+*+from+cpu+limit+1&db=telegraf" | grep -q dev-vagrant-usc1a-pr-10.0.1.15') do
#   its(:exit_status) { should eq 0 }
# end
