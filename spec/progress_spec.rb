require 'spec_helper'

describe Edash::Api::Progress do
  context 'progress markers' do
    it 'has a started marker' do
      create_progress(Edash::Api::Progress::STARTED).status.should == 'started'
    end

    it 'has a finished marker' do
      create_progress(Edash::Api::Progress::FINISHED).status.should == 'finished'
    end

    it 'has an percentage of progress' do
      create_progress(Edash::Api::Progress::STARTED, 10).percentage.should == 10
    end
  end

  context 'printing' do
    it 'prints to json' do
      create_progress(Edash::Api::Progress::STARTED, 20).to_json.should == "[\"started\",\"20\"]"
    end
  end

  def create_progress(status, percentage = 0)
    Edash::Api::Progress.new(status, percentage)
  end
end
