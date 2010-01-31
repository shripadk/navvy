require 'rubygems'
require 'sinatra'
require 'haml'

module Navvy
  class Monitor < Sinatra::Base
    set :views,   File.expand_path(File.dirname(__FILE__) + '/monitor/views')
    set :public,  File.expand_path(File.dirname(__FILE__) + '/monitor/public')
    set :static,  true

    before do
      @pending_count =    Job.count(:failed_at => nil, :completed_at => nil)
      @completed_count =  Job.count(:completed_at => {'$ne' => nil})
      @failed_count =     Job.count(:failed_at => {'$ne' => nil})
    end

    get '/' do
      @jobs = Job.all(:order => 'run_at desc, priority desc', :limit => 250)
      haml :index, :layout => true
    end

    get '/pending' do
      @jobs = Job.all(
        :failed_at => nil,
        :completed_at => nil,
        :order => 'priority desc, run_at desc',
        :limit => 250
      )
      haml :index, :layout => true
    end

    get '/completed' do
      @jobs = Job.all(
        :completed_at => {'$ne' => nil},
        :order => 'priority desc, run_at desc',
        :limit => 250
      )
      haml :index, :layout => true
    end

    get '/failed' do
      @jobs = Job.all(
        :failed_at => {'$ne' => nil},
        :order => 'priority desc, run_at desc',
        :limit => 250
      )
      haml :index, :layout => true
    end

    get '/:id' do
      @jobs = Job.all(
        '$where' => "this._id == '#{params[:id]}' || this.parent_id == '#{params[:id]}'",
        :order => 'priority desc, run_at desc',
        :limit => 100
      )
      haml :show
    end
  end
end