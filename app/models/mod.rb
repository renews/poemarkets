class Mod < ActiveRecord::Base
  
	has_many :item_mods
	has_many :items, through: :item_mods
	
	def self.implicit
	  self.where(explicit: false)
  end
  
  def self.explicit
    self.where(explicit: true)
  end
  
  def self.option_tags(explicit=true, selected=false)
    output = ''
    if explicit
      output += '<optgroup label="Popular">'
      self.where(explicit: true, popular:true).order(total: :desc, name: :asc).each do |mod|
        output += self.option(mod, selected)
      end
      output += "</optgroup>"
      output += '<optgroup label="Total">'
      self.where(explicit: true, total: true, popular: false).order(:name).each do |mod|
        output += self.option(mod, selected)
      end
      output += "</optgroup>"
      output += '<optgroup label="Other">'
      self.where(explicit: true, total: false, popular: false).order(:name).each do |mod|
        output += self.option(mod, selected)
      end
      output += "</optgroup>"
    else
      self.where(explicit: false).order(:name).each do |mod|
        output += self.option(mod, selected)
      end
    end
    output
  end
	
	def select_name
	  if self.total
	    '(total) ' + self.name
	  else
	    self.name
    end
  end
  
  private
  
  def self.option(mod, selected)
    output = ''
    output += "<option value=\"#{mod.id}\""
    output += " class=\"total\" data-label=\"<span class='label label-success'>total</span>\"" if mod.total
    output += " selected=\"selected\"" if mod.id == selected
    output += ">#{mod.select_name}</option>"
    output
  end
  
end
