require 'spec_helper'

describe 'monit::default' do
  context 'default attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'creates the monitrc' do
      expect(chef_run).to render_file('/etc/monit/monitrc')
        .with_content("set alert #{chef_run.node[:monit][:notify_email]}")
    end

    it 'creates directory /etc/monit/conf.d/' do
      expect(chef_run).to create_directory '/etc/monit/conf.d/'
    end
  end

  context 'email alerts disabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal[:monit][:email_alerts?] = false
      end.converge(described_recipe)
    end

    it 'creates the monitrc' do
      expect(chef_run).not_to render_file('/etc/monit/monitrc')
        .with_content("set alert #{chef_run.node[:monit][:notify_email]}")
    end
  end
end
