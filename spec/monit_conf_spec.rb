require 'spec_helper'

describe 'monit_conf' do
  let(:monit_conf) { Mash.new }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['monit_conf']) do |node|
      monit_conf.each do |key, value|
        node.normal['monit_test']['monit_conf'][key] = value
      end
    end.converge('monit_test')
  end

  context 'process' do
    it 'matches by pid file' do
      monit_conf['pid'] = '/var/run/test.pid'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check process test')
        .with_content('with pidfile /var/run/test.pid')
    end

    it 'matches by regular expression' do
      monit_conf['regexp'] = 'test\.sh'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check process test')
        .with_content("with matching 'test\\.sh'")
    end

    it 'needs either pid or regexp' do
      expect(Chef::Log).to receive(:fatal)
        .with(/process requires a pid attribute or a regexp expression/)
      chef_run
    end
  end

  context 'program' do
    it 'matches by path' do
      monit_conf['type'] = :program
      monit_conf['path'] = '/path/to/my/program.sh'
      monit_conf['timeout'] = '999 seconds'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check program test')
        .with_content('with path /path/to/my/program.sh')
        .with_content('with timeout 999 seconds')
    end

    it 'needs a path and a timeout' do
      monit_conf['type'] = :program
      expect(Chef::Log).to receive(:fatal)
        .with(/program requires a path and a timeout attribute/)
      chef_run
    end
  end

  context 'file' do
    it 'matches by path' do
      monit_conf['type'] = :file
      monit_conf['path'] = '/path/to/my/file'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check file test')
        .with_content('with path /path/to/my/file')
    end

    it 'needs a path' do
      monit_conf['type'] = :file
      expect(Chef::Log).to receive(:fatal)
        .with(/file requires a path attribute/)
      chef_run
    end
  end

  context 'filesystem' do
    it 'matches by path' do
      monit_conf['type'] = :filesystem
      monit_conf['path'] = '/dev/my/filesystem'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check filesystem test')
        .with_content('with path /dev/my/filesystem')
    end
  end

  context 'host' do
    it 'magic-matches by address' do
      monit_conf['type'] = :host
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check host test')
        .with_content('with address 127.0.0.1')
    end
  end

  context 'custom template' do
    it 'uses a custom template from monit_test cookbook' do
      monit_conf['template'] = 'custom_conf.erb'
      monit_conf['cookbook'] = 'monit_test'
      expect(chef_run).to render_file('/etc/monit/conf.d/test.conf')
        .with_content('check program test')
    end
  end
end
