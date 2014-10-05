require 'spec_helper'

describe VagrantPlugins::OpsWorks::Config do
  let(:unset_value) { described_class::UNSET_VALUE }
  subject { described_class.new.tap { |s| s.finalize! } }

  context 'when enabled is not set' do
    before(:each) do
      subject.enabled = unset_value
    end

    context 'when stack_id is not set' do
      before do
        subject.stack_id = unset_value
        subject.finalize!
      end

      it 'it sets the value of enabled to false' do
        subject.enabled.should be false
      end
    end

    context 'when stack_id is set' do
      before do
        subject.stack_id = 'foo'
        subject.finalize!
      end

      it 'it sets the value of enabled to true' do
        subject.enabled.should be true
      end
    end
  end

  context 'when enabled is set' do
    let(:enabled) { 'foo' }

    before(:each) do
      subject.enabled = enabled
    end

    context 'when stack_id is not set' do
      before do
        subject.stack_id = unset_value
        subject.finalize!
      end

      it 'the value of enable should remain unchanged' do
        subject.enabled.should == enabled
      end
    end

    context 'when stack_id is set' do
      before do
        subject.stack_id = 'foo'
        subject.finalize!
      end

      it 'it sets the value of enabled to true' do
        subject.enabled.should == enabled
      end
    end
  end

  describe "#validate" do
    let(:env) { double('env', root_path: Dir.pwd) }
    let(:config) { double('config', opsworks: subject) }
    let(:machine) { double('machine', config: config, env: env) }

    before do
      subject.finalize!
    end

    context 'when the plugin is enabled' do
      before(:each) do
        subject.stub(enabled: true)
        env.stub_chain(:vagrantfile, :config, :vm, :provisioners, :any?)
      end

      let(:result) { subject.validate(machine) }

      it "returns a Hash with an 'opsworks configuration' key" do
        result.should be_a(Hash)
        result.should have_key("opsworks configuration")
      end

      context 'when all validations pass' do
        it "contains an empty Array for the 'opsworks configuration' key" do
          result["opsworks configuration"].should be_a(Array)
          result["opsworks configuration"].should be_empty
        end
      end
    end

    context 'when the plugin is disabled' do
      let(:machine) { double('machine', env: env) }

      before do
        subject.stub(enabled: false)
      end

      it 'does not perform any validations' do
        machine.should_not_receive(:config)

        subject.validate(machine)
      end
    end
  end
end
