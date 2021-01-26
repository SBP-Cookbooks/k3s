require 'spec_helper'
require_relative '../../libraries/helpers'

RSpec.describe K3sCookbook::Helpers do
  class DummyClass < Chef::Node
    include K3sCookbook::Helpers
  end
  subject { DummyClass.new }

  describe '#k3s_node_ready?' do
    before do
      allow(subject).to receive(:[]).with('hostname').and_return('node2')

      kubectl_get_nodes = double('shellout')
      allow(kubectl_get_nodes).to receive(:run_command)
      allow(kubectl_get_nodes).to receive(:exitstatus).and_return(0)
      allow(kubectl_get_nodes).to receive(:stdout).and_return(output)

      allow_any_instance_of(K3sCookbook::Helpers)
        .to receive(:shell_out)
        .with('kubectl get node node2')
        .and_return(kubectl_get_nodes)
    end

    context 'when node is ready' do
      let(:output) do
        ['NAME    STATUS   ROLES    AGE     VERSION',
         'node1   Ready    master   5m00s   v1.19.4+k3s1',
         'node2   Ready    master   5m00s   v1.19.4+k3s1'].join('\n')
      end

      it 'returns true' do
        expect(subject.k3s_node_ready?).to eq true
      end
    end

    context 'when node is not ready' do
      let(:output) do
        ['NAME    STATUS      ROLES    AGE     VERSION',
         'node1   Ready       master   5m00s   v1.19.4+k3s1',
         'node2   NotReady    master   5m00s   v1.19.4+k3s1'].join('\n')
      end

      it 'returns false' do
        expect(subject.k3s_node_ready?).to eq false
      end
    end
  end
end
