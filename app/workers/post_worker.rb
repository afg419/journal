class PostWorker
  include Sidekiq::Worker

  def perform()

  end
end

#call PostWorker.perform_asynch()
