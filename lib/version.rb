module ZeroSolution
  VERSION_INFO = [1, 0, 0, 'rc1'].freeze
  VERSION = VERSION_INFO.map(&:to_s).join('.').freeze

  LATEST_UPDATE = 'Apr 20, 2018'

  def self.version
    VERSION
  end

  def self.date
  	LATEST_UPDATE
  end
  
end
