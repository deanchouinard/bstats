class AdminController < ApplicationController
	
	def load_xml
	end
	
 # def import_xml
  #  require ‘rexml/document’
#    file=params[:document][:file]
#    doc=REXML::Document.new(file.read)
#    doc.root.each_element(’//programme’) do |p|
#      if not Programme.find(:first, :conditions => [ “name=?”, p.attibutes[:name] ]) then
#        @programme=Programme.new
#        @programme.update_attributes(p.attributes)
#      end
#    end
#    redirect_to :action => ‘list’
#  end
end