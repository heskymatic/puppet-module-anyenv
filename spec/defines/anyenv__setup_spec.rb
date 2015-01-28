require 'spec_helper'

describe 'anyenv::setup' do
  let(:title) { 'anyenvtesting' }

  context 'with user => root, and home => /root' do
    let(:params) { {
      :user => 'root',
      :home => '/root'
    } }

    it { should contain_vcsrepo('/root/.anyenv') }
    it { should contain_exec('prepend path in /root/.bash_profile') }
    it { should contain_exec('append eval in /root/.bash_profile') }
    it { should contain_exec('verify the anyenv install for root') }
  end
end
