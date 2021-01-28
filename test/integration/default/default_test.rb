# InSpec test for recipe test::default

config_content = <<-EOF
datastore-endpoint: "mysql://k3s:k3s@tcp(localhost:3306)/k3s"
node-label:
  - "foo=bar"
  - "something=amazing"
snapshotter: "native"
tls-san:
  - "k3s.example.com"
write-kubeconfig-mode: "0644"
EOF

control 'k3s config' do
  title ''

  describe file('/etc/rancher/k3s/config.yaml') do
    it { should exist }
    its('content') { should eq config_content }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  describe file('/etc/rancher/k3s/k3s.yaml') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
end

control 'k3s service' do
  title ''

  describe service('k3s') do
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
    its('stdout') { should match(/#{sys_info.hostname.downcase}\s*Ready/) }
  end

  describe mysql_session('root', 'gsql').query('SELECT count(*) FROM INFORMATION_SCHEMA.PROCESSLIST WHERE DB = "k3s";') do
    its('stdout.chomp.to_i') { should be > 0 }
  end
end
