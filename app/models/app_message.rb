class AppMessage < ActiveRecord::Base
  belongs_to :user

  def self.national_suicide_prevention_hotline
    "Everyone feels down sometimes.  If you feel you may be a danger to" +
    " yourself, please consider contacting the National Suicide Prevention" +
    " Hotline at 1 (800) 273-8255."
  end

  def self.google_therapy_search
    "Everyone feels down sometimes, but help can be just one click away. Would you like to explore local therapy and counselling options? <br>" +
    "Link for local counselors: <a href= >Counselors</a><br>" +
    "Link for local suicide services: <a href='https://www.google.com/#q=suicide+services+near+me'>Help</a>"
  end

  def links
    {
      counselors: Proc.new{ link_to "Counselors", 'https://www.google.com/#q=counselling+near+me'}
      suicide_services: Proc.new{ link_to "Help", 'https://www.google.com/#q=suicide+services+near+me'}
    }
  end

  def self.current_message
    note = last
    note.message if note && note.status == 1
  end

  def self.set_all_inactive
    all.each do |note|
      note.status = 0
      note.save
    end
  end
end
