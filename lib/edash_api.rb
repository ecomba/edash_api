require 'net/http'
require 'uri'
require 'edash/progress'

module Edash
  module Api

    BUILD_FAIL    = 'fail'
    BUILD_PASS    = 'pass'
    BUILD_RUNNING = 'building'

    def display_build_message(project, status, author = nil)
      assert_setup
      post(build_message_uri, parameters_for_build_message(project, status, author))
    end

    def display_project_progress(project, progress)
      assert_setup
      post(project_progress_uri, parameters_for_project_progress(project, progress))
    end

    private
    def assert_setup
      raise("Please set the ip with @ip = <your_edash_ip_address>") if @ip.nil? || @ip.empty?
      raise("Please set the port number with @port = <your_edash_port>") if @port.nil? || @port == 0
    end

    def post(uri, parameters)
      Net::HTTP.post_form(uri, parameters)
    end

    def parameters_for_build_message(project, status, author)
      parameters = {:project => project, :status => status}
      parameters.merge!(:author => author) if author
      parameters
    end

    def base_uri_string
      "http://#{@ip}:#{@port}/"
    end

    def build_message_uri
      URI.parse("#{base_uri_string}build")
    end

    def project_progress_uri
      URI.parse("#{base_uri_string}progress")
    end

    def parameters_for_project_progress(project, progress)
      { :project => project, :progress => create_progress_report(progress) }
    end

    def create_progress_report(progress)
      progress_report = "[#{progress.to_json}]" unless progress.is_a? Array
      progress_report = "[#{progress.map{|progress| progress.to_json}.join(',')}]" if progress.is_a? Array
      progress_report
    end
  end
end
