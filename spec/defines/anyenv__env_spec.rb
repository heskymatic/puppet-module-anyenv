require 'spec_helper'

describe 'anyenv::env' do
  let(:title) { 'anyenvtesting' }

  context 'with user => root, and env => ndenv' do
    let(:params) { {
      :user => 'root',
      :env  => 'ndenv',
    } }

    it { should contain_exec('install ndenv for root') }
    it { should contain_exec('verify ndenv install for root') }
  end
end
