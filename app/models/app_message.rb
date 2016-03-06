class AppMessage < ActiveRecord::Base
  belongs_to :user

  def self.national_suicide_prevention_hotline
    "Everyone feels down sometimes.  If you feel you may be a danger to" +
    " yourself, please consider contacting the National Suicide Prevention" +
    " Hotline at 1 (800) 273-8255."
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
