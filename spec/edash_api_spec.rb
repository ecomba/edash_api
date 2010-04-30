require 'spec_helper'

describe Edash::Api do
  before do
    extend Edash::Api
    setup_edash_base
  end

  context 'display build message' do
    before do
      @uri = build_uri('build')
    end

    it 'sends a request' do
      receives_post_form_with(@uri, params_hash(status_pass))
      display_build_message(project, status_pass)
    end

    it 'sends a request with the author' do
      receives_post_form_with(@uri, params_hash(status_pass).merge(:author => author))
      display_build_message(project, status_pass, author)
    end

    it 'sends requests for each status type' do
      [Edash::Api::BUILD_PASS, Edash::Api::BUILD_FAIL, Edash::Api::BUILD_RUNNING].each do |status| 
        receives_post_form_with(@uri, params_hash(status))
        display_build_message(project, status)
      end
    end

    def params_hash(status) 
      {:project => project, :status => status }
    end

    def status_pass
      Edash::Api::BUILD_PASS
    end

    def author
      "Enrique Comba Riepenhausen <enrique@edendevelopment.co.uk>"
    end
  end

  context 'display project progress' do
    it 'sends a request with one progress report' do
      receives_post_form_with(build_uri('progress'), { :project => project, :progress => "[#{progress.to_json}]" })
      display_project_progress(project, progress)
    end

    it 'sends a request with more than one progress report' do
      receives_post_form_with(build_uri('progress'), :project => project,
                              :progress => "[#{progress.to_json},#{progress.to_json}]")
      display_project_progress(project, [progress, progress])
    end
  end

  context 'setup is correct' do
    before do
      @ip = nil
      @port = nil
    end

    it 'bombs when the ip is not set' do
      lambda { display_build_message(project, Edash::Api::BUILD_PASS) }.should raise_error(
        "Please set the ip with @ip = <your_edash_ip_address>")
    end

    it 'bombs when the ip is empty' do
      @ip = ''
      lambda { display_build_message(project, Edash::Api::BUILD_PASS) }.should raise_error(
        "Please set the ip with @ip = <your_edash_ip_address>")
    end

    it 'bombs when the port is not set' do
      @ip = 'someip'
      lambda { display_build_message(project, Edash::Api::BUILD_PASS) }.should raise_error(
        "Please set the port number with @port = <your_edash_port>")
    end

    it 'bombs when the port is empty' do
      @ip = 'someip'
      @port =  0
      lambda { display_build_message(project, Edash::Api::BUILD_PASS) }.should raise_error(
        "Please set the port number with @port = <your_edash_port>")
    end
  end

  def receives_post_form_with(*args)
    Net::HTTP.should_receive(:post_form).with(*args)
  end

  def build_uri(path)
    URI.parse("http://#{@ip}:#{@port}/#{path}")
  end

  def project 
    'Testproject'
  end

  def progress
    Edash::Api::Progress.new(Edash::Api::Progress::STARTED, 30)
  end

  def setup_edash_base
    @ip = 'localhost'
    @port = 9292
  end
end
