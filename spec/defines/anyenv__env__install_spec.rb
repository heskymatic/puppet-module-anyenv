require 'spec_helper'

describe 'anyenv::env::install' do
  let(:title) { 'anyenvtesting' }

  context 'with user => root, and env => ndenv, and version => v0.10.35' do
    let(:params) { {
      :user    => 'root',
      :env     => 'ndenv',
      :version => 'v0.10.35',
    } }

    it { should contain_exec('install ndenv v0.10.35 for root') }
    it { should contain_exec('verify ndenv v0.10.35 for root') }
  end
end
