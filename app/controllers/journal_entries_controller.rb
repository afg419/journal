class JournalEntriesController < ApplicationController

  def new
    render layout: 'wide',  :locals => {:background => "dashboard3"}
  end

end
