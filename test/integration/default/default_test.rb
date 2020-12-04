# InSpec test for recipe test::default

control 'k3s service' do
  title ''

  describe service 'k3s' do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe port(6443) do
    its('processes') { should include 'k3s-server' }
    its('protocols') { should include 'tcp' }
    its('addresses') { should include '0.0.0.0' }
  end
end

control 'k3s health' do
  title ''

  # Small delay needed for the node to become ready
  describe command('sleep 30; kubectl get nodes') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/#{sys_info.hostname.downcase}\s*Ready\s*master/) }
  end
end
