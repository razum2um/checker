require 'spec_helper'

describe Checker::Modules::Javascript do
  it 'should only check .js files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml', 'f.coffee', 'g.haml', 'h.js']
    mod = Checker::Modules::Javascript.new(files)
    mod.stub(:check_for_executable).and_return(true)
    mod.should_receive(:check_one_file).with('h.js').and_return(true)
    mod.should_not_receive(:check_one_file).with('g.haml')
    mod.should_not_receive(:check_one_file).with('f.coffee')
    mod.should_not_receive(:check_one_file).with('e.yaml')
    mod.should_not_receive(:check_one_file).with('d.yml')
    mod.should_not_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check 
  end
end
