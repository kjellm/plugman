class Plugman
  class BlackWhitePolicy
    
    def initialize(black_list, white_list, &unknown_handler)
      @black           = black_list
      @white           = white_list
      @unknown_handler = unknown_handler
    end
    
    def apply(plugin_files)
      approved = []
      plugin_files.each do |plugin|
        basename = File.basename(plugin)
        if @white.include?(basename)
          approved << plugin
          next
        end
        next if @black.include?(basename)
        approved << plugin if @unknown_handler.call(basename)
      end  
      approved
    end
    
  end
end