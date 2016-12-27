monit_conf 'test' do
  node['monit_test']['monit_conf'].each do |property, value|
    send(property, value)
  end
end
