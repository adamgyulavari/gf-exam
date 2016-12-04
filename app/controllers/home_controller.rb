class HomeController < ApplicationController
  protect_from_forgery except: :process_push

  def index
    @suites = Suite.order('created_at DESC').limit(20)
  end

  def suite
    @suite = Suite.find(params[:id])
  end

  def process_push
    puts 'yaaay'
    puts params[:pull_request][:user][:login]
    ProcessPushJob.perform_later(params[:pull_request][:user][:login])
    head :ok
  end

  def console
    raise 'f'
  end
end
