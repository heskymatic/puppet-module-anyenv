require 'spec_helper'

describe 'anyenv::env::default' do
  let(:title) { 'anyenvtesting' }

  context 'with user => root, and env => ndenv, and version => v0.10.35' do
    let(:params) { {
      :user    => 'root',
      :env     => 'ndenv',
      :version => 'v0.10.35',
    } }

    it { should contain_exec('set ndenv v0.10.35 as default for root') }
    it { should contain_exec('verify ndenv v0.10.35 is default for root') }
  end

  context 'with user => joeuser, and env => ndenv, and version => v0.10.35' do
    let(:params) { {
      :user    => 'joeuser',
      :env     => 'ndenv',
      :version => 'v0.10.35',
    } }

    it { should contain_exec('set ndenv v0.10.35 as default for joeuser') }
    it { should contain_exec('verify ndenv v0.10.35 is default for joeuser') }
  end
end
