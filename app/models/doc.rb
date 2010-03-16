require 'acts_as_ferret'
require 'rmmseg'  
require 'rmmseg/ferret' 
require 'stringex'

class Doc < ActiveRecord::Base
  # use rmmseg 
  ranalyzer = RMMSeg::Ferret::Analyzer.new { |tokenizer|
 	 Ferret::Analysis::LowerCaseFilter.new(tokenizer)
  }
#	index = Ferret::Index::Index.new(:analyzer => analyzer)
 # GENERIC_ANALYSIS_REGEX = /([a-zA-Z]|[\\xc0-\xdf][\\x80-\\xbf])+|[0-9]+|[\\xe0-\\xef][\\x80-\\xbf][\\x80-\\xbf]/
  #GENERIC_ANALYZER = Ferret::Analysis::RegExpAnalyzer.new(GENERIC_ANALYSIS_REGEX, true)
	# use reuglar exp
    aaa = Ferret::Analysis::RegExpAnalyzer.new(/[a-zA-Z]+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/, true)
    #acts_as_ferret ({:remote=>true, :fields=>[:title, :content], :analyzer => aaa}) #:analyzer =>GENERIC_ANALYZER#,  :analyzer => analyzer  # , :analyzer =>GENERIC_ANALYZER
	
   # use rmmseg
 bbb = Ferret::Analysis::RegExpAnalyzer.new(/[a-zA-Z]+/,true)
#   acts_as_ferret ({ :remote=>true, :fields=>[:title, :content], :ferret=>{:analyzer => bbb} })
   acts_as_ferret  :remote=>true, :fields=>[:title, :content, :uid], :ferret=>{:analyzer => ranalyzer}
  #{:title => {:store => :yes}}
  
  def content
    c = loadContent
	c = c.strip_html_tags(true).convert_accented_entities.
      convert_misc_entities
	logger.info c
	return c
  end
  
  def loadContent

    dir = self.id/100
    dir = "/var/oe/docs/"+dir.to_s+"/"
    path = dir + self.id.to_s
    r = ""
       # logger.info("$$$$$$$$$$:#{path}$$$")
    if FileTest.exist?(path) 
      f = File.new(path, "r") 
      f.each_line do |l|
        r = r + l
      end
      f.close
    else
      logger.error "file #{path} not exist!"
    end
	self[:content]=r
    return r
    
  end
  
  
end
